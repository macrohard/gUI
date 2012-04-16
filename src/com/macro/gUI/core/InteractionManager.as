package com.macro.gUI.core
{

	import com.macro.gUI.assist.CHILD_REGION;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.controls.TextInput;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.core.feature.IFocus;
	import com.macro.gUI.core.feature.IKeyboard;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;


	/**
	 * 交互管理器，通过协同UIManager工作，监听RootSprite的键盘、鼠标操作，
	 * 然后定位到正确的IControl，设置其相应的状态，并通过它派发事件<br/>
	 * 首先根据控件的rect定义递归搜索直到具体的IControl，再通过hitTest测试找到真正的IControl
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class InteractionManager
	{

		/**
		 * 显示对象容器
		 */
		private var _displayObjectContainer:DisplayObjectContainer;

		/**
		 * 根容器控件
		 */
		private var _root:IContainer;



		/**
		 * 弹出窗口管理器
		 */
		private var _popupManager:PopupManager;

		/**
		 * 拖拽管理器
		 */
		private var _dragManager:DragManager;

		/**
		 * 焦点管理器
		 */
		private var _focusManager:FocusManager;



		/**
		 * 鼠标点击的外层控件，基本控件或复合控件
		 */
		private var _mouseControl:IControl;

		/**
		 * 鼠标点击的实际目标控件，如复合控件内的控件
		 */
		private var _mouseTarget:IControl;



		/**
		 * 交互管理器
		 * @param root
		 * @param top
		 * @param container
		 *
		 */
		public function InteractionManager(uiManager:UIManager, displayObjectContainer:DisplayObjectContainer)
		{
			_root = uiManager.root;
			_displayObjectContainer = displayObjectContainer;

			_popupManager = uiManager.popupManager;
			_dragManager = new DragManager();
			_focusManager = new FocusManager(uiManager.topContainer, displayObjectContainer);

			displayObjectContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			displayObjectContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			displayObjectContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}


		protected function mouseDownHandler(e:MouseEvent):void
		{
			findTargetControl(_root, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);

			// 如果有弹出菜单时，就及时关闭之
			_popupManager.removePopupMenu(_mouseControl);

			// 处理焦点
			_focusManager.focus(_mouseControl);

			if (_mouseControl == null || _mouseControl.enabled == false || _mouseTarget.enabled == false)
			{
				return;
			}

			// 处理鼠标按下
			if (_mouseControl is IButton)
			{
				(_mouseControl as IButton).mouseDown(_mouseTarget);
			}

			// 处理拖拽
			if (_mouseControl is IDrag)
			{
				_dragManager.startDrag(_mouseControl as IDrag, _mouseTarget);
			}
		}

		protected function mouseUpHandler(e:MouseEvent):void
		{
			if (_dragManager.isDragging)
			{
				// 结束拖拽
				findTargetControl(_root, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);

				_dragManager.stopDrag(_mouseControl);
			}
			else
			{
				// 处理鼠标松开
				if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
				{
					(_mouseControl as IButton).mouseUp(_mouseTarget);
				}
			}
		}

		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (_dragManager.isDragging)
			{
				// 正在拖拽
				_dragManager.setDragCoord(_displayObjectContainer.mouseX, _displayObjectContainer.mouseY);
			}
			else
			{
				var tempC:IControl = _mouseControl;
				var tempT:IControl = _mouseTarget;
				findTargetControl(_root, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);

				// 在同一个控件范围内移动时不作处理
				if (tempT == _mouseTarget)
				{
					return;
				}

				// 处理鼠标离开
				if (tempC is IButton && tempC.enabled && tempT.enabled)
				{
					(tempC as IButton).mouseOut(tempT);
					Mouse.cursor = MouseCursor.AUTO;
				}

				// 处理鼠标进入
				if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
				{
					(_mouseControl as IButton).mouseOver(_mouseTarget);

					if (_mouseTarget is IButton)
					{
						Mouse.cursor = MouseCursor.BUTTON;
					}
				}
			}
		}



		/**
		 * 遍历查找鼠标所在的控件
		 * @param control
		 * @return
		 *
		 */
		protected function findTargetControl(control:IControl, mouseX:int, mouseY:int):Boolean
		{
			var target:IControl = control.hitTest(mouseX, mouseY);
			if (target != null)
			{
				if (control is IContainer && target is CHILD_REGION)
				{
					var container:IContainer = control as IContainer;
					for (var i:int = container.numChildren - 1; i >= 0; i--)
					{
						if (findTargetControl(container.children[i], mouseX, mouseY))
						{
							return true;
						}
					}

					if (control.bitmapData == null)
					{
						_mouseTarget = null;
						_mouseControl = null;
						return false;
					}
				}

				_mouseTarget = target;
				_mouseControl = control;
				return true;
			}
			else
			{
				_mouseTarget = null;
				_mouseControl = null;
				return false;
			}

		}

	}
}
