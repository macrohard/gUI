package com.macro.gUI.core
{

	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;


	/**
	 * 交互管理器，通过协同UIManager工作，监听RootSprite的键盘、鼠标操作，
	 * 然后定位到正确的IControl，设置其相应的状态，并通过它派发事件<br/>
	 * 首先根据控件的rect定义递归搜索直到具体的IControl，再通过hitTest测试找到真正的IControl
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class InteractiveManager
	{

		private var _displayObjectContainer:DisplayObjectContainer;

		/**
		 * 主容器控件
		 */
		private var _main:IContainer;



		/**
		 * 弹出窗口管理器
		 */
		private var _popupManager:PopUpManager;

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
		 * @param uiManager
		 * @param displayObjectContainer
		 *
		 */
		public function InteractiveManager(uiManager:UIManager, displayObjectContainer:DisplayObjectContainer)
		{
			_main = uiManager.main;
			_displayObjectContainer = displayObjectContainer;
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);

			_popupManager = uiManager.popupManager;
			_dragManager = new DragManager(uiManager.top);
			_focusManager = new FocusManager(uiManager.top, _displayObjectContainer);
		}
		
		public function get mouseControl():IControl
		{
			return _mouseControl;
		}


		protected function mouseDownHandler(e:MouseEvent):void
		{
			findTargetControl(_main, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);

			// 处理弹出菜单
			_popupManager.autoClosePopupMenu(_mouseControl);

			// 处理焦点
			_focusManager.focus(_mouseControl, _mouseTarget);

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
				_dragManager.stopDrag();
			}

			var tempC:IControl = _mouseControl;
			var tempT:IControl = _mouseTarget;
			findTargetControl(_main, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);

			if (tempT != _mouseTarget)
			{
				// 处理鼠标离开
				if (tempC is IButton && tempC.enabled && tempT.enabled)
				{
					Mouse.cursor = MouseCursor.AUTO;
					(tempC as IButton).mouseOut(tempT);
				}
			}

			// 处理鼠标弹起
			if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
			{
				if (_mouseTarget is IButton)
				{
					Mouse.cursor = MouseCursor.BUTTON;
				}
				(_mouseControl as IButton).mouseUp(_mouseTarget);
			}
		}

		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (_dragManager.isDragging)
			{
				// 正在拖拽
				_dragManager.setDragCoord(_displayObjectContainer.mouseX, _displayObjectContainer.mouseY);
				return;
			}


			var tempC:IControl = _mouseControl;
			var tempT:IControl = _mouseTarget;
			findTargetControl(_main, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);

			// 在同一个目标控件范围内移动时不作处理
			if (tempT == _mouseTarget)
			{
				return;
			}

			// 处理鼠标离开
			if (tempC is IButton && tempC.enabled && tempT.enabled)
			{
				Mouse.cursor = MouseCursor.AUTO;
				(tempC as IButton).mouseOut(tempT);
			}

			// 处理鼠标进入
			if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
			{
				if (_mouseTarget is IButton)
				{
					Mouse.cursor = MouseCursor.BUTTON;
				}
				(_mouseControl as IButton).mouseOver(_mouseTarget);
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
			var target:IControl;
			if (control.visible)
			{
				target = control.hitTest(mouseX, mouseY);
			}
			if (target != null)
			{
				if (control is IContainer && target == AbstractContainer.CHILD_REGION)
				{
					var container:IContainer = control as IContainer;
					for (var i:int = container.numChildren - 1; i >= 0; i--)
					{
						if (findTargetControl(container.getChildAt(i), mouseX, mouseY))
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