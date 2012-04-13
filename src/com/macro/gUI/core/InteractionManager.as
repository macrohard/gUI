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
		 * 显示容器
		 */
		private var _container:DisplayObjectContainer;

		/**
		 * 根容器
		 */
		private var _root:IContainer;

		/**
		 * 最上层窗口容器
		 */
		private var _top:IContainer;

		/**
		 * 弹出窗口管理器
		 */
		private var _popupManager:PopupManager;



		/**
		 * 鼠标点击的外层控件，基本控件或复合控件
		 */
		private var _mouseControl:IControl;

		/**
		 * 鼠标点击的实际目标控件，如复合控件内的控件
		 */
		private var _mouseTarget:IControl;


		
		/**
		 * 
		 */
		private var _dragManager:DragManager;
		
		/**
		 * 
		 */
		private var _focusManager:FocusManager;
		
		/**
		 * 
		 */
		private var _editManager:EditManager;



		/**
		 * 交互管理器
		 * @param root
		 * @param top
		 * @param container
		 *
		 */
		public function InteractionManager(uiManager:UIManager, container:DisplayObjectContainer)
		{
			_root = uiManager.root;
			_top = uiManager.topContainer;
			_popupManager = uiManager.popupManager;
			_container = container;
			
			_dragManager = new DragManager();
			_editManager = new EditManager(container);
			_focusManager = new FocusManager(_editManager);
			

			container.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			container.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			container.addEventListener(KeyboardEvent.KEY_DOWN, _focusManager.keyDownHandler);
			container.addEventListener(KeyboardEvent.KEY_UP, _focusManager.keyUpHandler);
		}


		protected function mouseDownHandler(e:MouseEvent):void
		{
			findTargetControl(_root);
			
			// 如果有弹出菜单时，就及时关闭之
			_popupManager.removePopupMenu(_mouseControl);

			// 处理焦点
			if (_mouseControl is IFocus && _mouseControl.enabled)
			{
				_focusManager.setFocus(_mouseControl as IFocus);
			}
			else
			{
				_focusManager.setFocus(null);
			}

			// 处理编辑框
			if (_editManager._editControl != null)
			{
				if (_editManager._editControl == _mouseControl)
				{
					_editManager.focusEditBox();
					return;
				}
				else
				{
					_editManager.endEdit();
				}
			}
			if (_mouseControl is IEdit)
			{
				_editManager._editControl = _mouseControl as IEdit;
				_editManager.beginEdit();
				return;
			}

			if (_mouseTarget != null && _mouseControl.enabled &&
					_mouseTarget.enabled)
			{
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
		}

		protected function mouseUpHandler(e:MouseEvent):void
		{
			if (_dragManager._dragControl == null)
			{
				// 处理鼠标松开
				if (_mouseControl != null && _mouseControl.enabled &&
						_mouseTarget.enabled)
				{
					if (_mouseControl is IButton)
					{
						(_mouseControl as IButton).mouseUp(_mouseTarget);
					}
				}
			}
			else
			{
				// 结束拖拽
				findTargetControl(_root);

				_dragManager.stopDrag(_mouseControl);
			}
		}

		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (_dragManager._dragControl == null)
			{
				var tempC:IControl = _mouseControl;
				var tempT:IControl = _mouseTarget;
				findTargetControl(_root);

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
				if (_mouseControl != null && _mouseControl.enabled &&
						_mouseTarget.enabled)
				{
					if (_mouseControl is IButton)
					{
						(_mouseControl as IButton).mouseOver(_mouseTarget);

						if (_mouseTarget is IButton)
						{
							Mouse.cursor = MouseCursor.BUTTON;
						}
					}
				}

			}
			else
			{
				_dragManager.dragging(_container.mouseX, _container.mouseY);
			}
		}

		/**
		 * 遍历查找鼠标所在的控件
		 * @param control
		 * @return
		 *
		 */
		protected function findTargetControl(control:IControl):Boolean
		{
			var target:IControl = control.hitTest(_container.mouseX,
												  _container.mouseY);
			if (target != null)
			{
				if (control is IContainer && target is CHILD_REGION)
				{
					var container:IContainer = control as IContainer;
					for (var i:int = container.numChildren - 1; i >= 0; i--)
					{
						if (findTargetControl(container.children[i]))
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
