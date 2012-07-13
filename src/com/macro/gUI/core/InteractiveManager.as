package com.macro.gUI.core
{

	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.events.TouchEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;


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
		private var _popupMgr:PopUpManager;

		/**
		 * 拖拽管理器
		 */
		private var _dragMgr:DragManager;

		/**
		 * 焦点管理器
		 */
		private var _focusMgr:FocusManager;



		/**
		 * 鼠标点击的外层控件，基本控件或复合控件
		 */
		private var _mouseControl:IControl;

		/**
		 * 鼠标点击的实际目标控件，如复合控件内的控件
		 */
		private var _mouseTarget:IControl;
		
		
		
		/**
		 * 鼠标按下位置
		 */
		protected var _mouseDownPoint:Point;
		
		/**
		 * 鼠标点击位置
		 */
		protected var _clickPoint:Point;
		
		/**
		 * 鼠标点击时间戳
		 */
		protected var _clickTime:int;



		/**
		 * 交互管理器
		 * @param uiManager
		 * @param displayObjectContainer
		 *
		 */
		public function InteractiveManager(uiManager:UIManager, displayObjectContainer:DisplayObjectContainer)
		{
			_main = uiManager._main;
			_displayObjectContainer = displayObjectContainer;
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			_displayObjectContainer.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);

			_popupMgr = uiManager.popupManager;
			_dragMgr = uiManager.dragManager;
			_focusMgr = uiManager.focusManager;
		}
		
		public function get mouseControl():IControl
		{
			return _mouseControl;
		}


		protected function mouseDownHandler(e:MouseEvent):void
		{
			search();

			// 处理弹出菜单
			_popupMgr.autoClosePopupMenu(_mouseControl);

			// 处理焦点
			_focusMgr.focus(_mouseControl, _mouseTarget);

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
				_dragMgr.startDrag(_mouseControl as IDrag, _mouseTarget);
			}
			
			
			// 处理鼠标按下事件
			_mouseControl.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_DOWN, _mouseControl));
			_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_DOWN, _mouseControl));
			// 记录鼠标按下位置
			_mouseDownPoint = new Point(e.stageX, e.stageY);
		}

		protected function mouseUpHandler(e:MouseEvent):void
		{
			if (_dragMgr.isDragging)
			{
				// 结束拖拽
				_dragMgr.stopDrag();
			}

			var tempC:IControl = _mouseControl;
			var tempT:IControl = _mouseTarget;
			search();

			if (tempT != _mouseTarget)
			{
				// 处理鼠标离开
				if (tempC is IButton && tempC.enabled && tempT.enabled)
				{
					if (Mouse.cursor == MouseCursor.BUTTON)
					{
						Mouse.cursor = MouseCursor.AUTO;
					}
					(tempC as IButton).mouseOut(tempT);
				}
				
				// 处理鼠标离开事件
				if (tempC != null && tempC != _mouseControl)
				{
					tempC.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, tempC));
					_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, tempC));
				}
			}

			// 处理鼠标松开
			if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
			{
				if (_mouseTarget is IButton && Mouse.cursor == MouseCursor.AUTO)
				{
					Mouse.cursor = MouseCursor.BUTTON;
				}
				(_mouseControl as IButton).mouseUp(_mouseTarget);
			}
			
			
			if (_mouseControl != null)
			{
				// 处理鼠标松开事件
				_mouseControl.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_UP, _mouseControl));
				_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_UP, _mouseControl));
				
				// 如果有按下位置，则执行Click测试
				if (_mouseDownPoint != null)
				{
					if (_mouseControl.doubleClickEnabled && getTimer() - _clickTime < 400 && _clickPoint != null && _mouseDownPoint.equals(_clickPoint))
					{
						_mouseControl.dispatchEvent(new TouchEvent(TouchEvent.DOUBLE_CLICK, _mouseControl));
						_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.DOUBLE_CLICK, _mouseControl));
						_clickPoint = null;
					}
					else
					{
						_mouseControl.dispatchEvent(new TouchEvent(TouchEvent.CLICK, _mouseControl));
						_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.CLICK, _mouseControl));
						_clickPoint = _mouseDownPoint;
						_clickTime = getTimer();
					}
					_mouseDownPoint = null;
				}
			}
		}

		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (_dragMgr.isDragging)
			{
				// 正在拖拽
				_dragMgr.setDragCoord(_displayObjectContainer.mouseX, _displayObjectContainer.mouseY);
				return;
			}


			var tempC:IControl = _mouseControl;
			var tempT:IControl = _mouseTarget;
			search();

			// 在同一个目标控件范围内移动时不作处理
			if (tempT == _mouseTarget)
			{
				return;
			}

			// 处理鼠标离开
			if (tempC is IButton && tempC.enabled && tempT.enabled)
			{
				if (Mouse.cursor == MouseCursor.BUTTON)
				{
					Mouse.cursor = MouseCursor.AUTO;
				}
				(tempC as IButton).mouseOut(tempT);
			}
			
			// 处理鼠标进入
			if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
			{
				if (_mouseTarget is IButton && Mouse.cursor == MouseCursor.AUTO)
				{
					Mouse.cursor = MouseCursor.BUTTON;
				}
				(_mouseControl as IButton).mouseOver(_mouseTarget);
			}
			
			
			if (tempC != _mouseControl)
			{
				// 处理鼠标离开事件
				if (tempC != null)
				{
					tempC.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, tempC));
					_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, tempC));
				}
				
				// 处理鼠标进入事件
				if (_mouseControl != null)
				{
					_mouseControl.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OVER, _mouseControl));
					_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OVER, _mouseControl));
				}
			}
		}
		
		protected function mouseOutHandler(e:MouseEvent):void
		{
			if (_mouseControl == null)
			{
				return;
			}
			
			// 处理鼠标离开
			if (_mouseControl is IButton && _mouseControl.enabled && _mouseTarget.enabled)
			{
				if (Mouse.cursor == MouseCursor.BUTTON)
				{
					Mouse.cursor = MouseCursor.AUTO;
				}
				(_mouseControl as IButton).mouseOut(_mouseTarget);
			}
			
			// 处理鼠标离开事件
			_mouseControl.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, _mouseControl));
			_displayObjectContainer.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, _mouseControl));
			
			_mouseControl = null;
			_mouseTarget = null;
		}
		
		
		private function search():void
		{
			var ret:Vector.<IControl> = findTargetControl(_main, _displayObjectContainer.mouseX, _displayObjectContainer.mouseY);
			if (ret == null)
			{
				_mouseControl = null;
				_mouseTarget = null;
			}
			else
			{
				_mouseControl = ret[0];
				_mouseTarget = ret[1];
			}
		}



		/**
		 * 遍历查找坐标位置所在的控件
		 * @param control 查找的起点控件
		 * @param x 全局坐标，即显示对象容器的本地坐标
		 * @param y 全局坐标，即显示对象容器的本地坐标
		 * @return 如果未找到目标，则返回null，找到目标时，返回一个数组，第一项是找到的外层控件，第二项是实际目标控件
		 * 
		 */
		public function findTargetControl(control:IControl, x:int, y:int):Vector.<IControl>
		{
			var target:IControl;
			if (control.visible && control.mouseEnabled)
			{
				target = control.hitTest(x, y);
			}
			if (target != null)
			{
				if (control is IContainer && target == AbstractContainer.CHILD_REGION)
				{
					var container:IContainer = control as IContainer;
					for (var i:int = container.numChildren - 1; i >= 0; i--)
					{
						var ret:Vector.<IControl> = findTargetControl(container.getChildAt(i), x, y);
						if (ret != null)
						{
							return ret;
						}
					}

					if (control.bitmapData == null)
					{
						return null;
					}
				}

				return new <IControl> [control, target];
			}
			else
			{
				return null;
			}

		}

	}
}
