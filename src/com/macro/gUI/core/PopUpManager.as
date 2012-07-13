package com.macro.gUI.core
{
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.events.TouchEvent;
	
	import flash.utils.Dictionary;


	/**
	 * 弹出窗口管理器<br/>
	 * 弹出菜单始终处于最顶层，同时最多只有一个菜单弹出，弹出新菜单时会自动关闭旧菜单<br/>
	 * 模态窗口和非模态窗口允许同时弹出多个，模态窗口会使用Container封装，并添加半透明背景，以隔离鼠标操作
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class PopUpManager
	{

		/**
		 * 弹出窗口容器
		 */
		private var _popupContainer:IContainer;


		/**
		 * 弹出菜单，如ComboBox控件的下拉列表
		 */
		private var _popupMenu:IControl;

		/**
		 * 菜单宿主控件
		 */
		private var _initiator:IControl;

		/**
		 * 模态窗口哈希表
		 */
		private var _modalWindows:Dictionary;


		/**
		 * 弹出窗口管理器
		 * @param popupContainer 弹出窗口容器
		 *
		 */
		public function PopUpManager(uiManager:UIManager)
		{
			_popupContainer = uiManager._popup;
			_modalWindows = new Dictionary(true);
		}
		
		

		/**
		 * 添加弹出窗口
		 * @param window
		 * @param isModal 是否模态
		 * @param isCenter 是否居中显示
		 * @param isAutoBringToFront 是否自动前置弹出窗口
		 * 
		 */
		public function addPopupWindow(window:IControl, isModal:Boolean = false, isCenter:Boolean = false, isAutoBringToFront:Boolean = true):void
		{
			if (isCenter)
			{
				centerPopup(window);
			}

			if (isModal)
			{
				var c:Container = new Container(_popupContainer.width, _popupContainer.height);
				c.backgroundColor = 0x33000000;
				c.addChild(window);
				_modalWindows[window] = c;
				_popupContainer.addChildAt(c, getPopupWindowLayer());
			}
			else
			{
				_popupContainer.addChildAt(window, getPopupWindowLayer());
			}
			
			if (isAutoBringToFront)
			{
				window.addEventListener(TouchEvent.MOUSE_DOWN, windowActivateHandler);
			}
		}
		
		private function windowActivateHandler(e:TouchEvent):void
		{
			bringToFront(e.control);
		}
		
		/**
		 * 移除弹出窗口
		 * @param window
		 *
		 */
		public function removePopupWindow(window:IControl):void
		{
			var c:Container = _modalWindows[window];
			if (c != null)
			{
				_popupContainer.removeChild(c);
				_modalWindows[window] = null;
				delete _modalWindows[window];
				window.removeEventListener(TouchEvent.MOUSE_DOWN, windowActivateHandler);
			}
			else
			{
				_popupContainer.removeChild(window);
			}
		}
		
		/**
		 * 将弹出窗口移到其它弹出窗口之前
		 * @param window 弹出窗口
		 *
		 */
		public function bringToFront(window:IControl):void
		{
			var c:Container = _modalWindows[window];
			if (c != null)
			{
				_popupContainer.removeChild(c);
				_popupContainer.addChildAt(c, getPopupWindowLayer());
			}
			else
			{
				_popupContainer.removeChild(window);
				_popupContainer.addChildAt(window, getPopupWindowLayer());
			}
		}

		/**
		 * 居中显示弹出窗口
		 * @param window
		 *
		 */
		public function centerPopup(window:IControl):void
		{
			window.x = _popupContainer.width - window.width >> 1;
			window.y = _popupContainer.height - window.height >> 1;
		}

		/**
		 * 添加弹出菜单。一次只允许弹出一个菜单，旧菜单将被自动关闭
		 * @param menu 菜单
		 * @param initiator 菜单宿主控件
		 *
		 */
		public function addPopupMenu(menu:IControl, initiator:IControl):void
		{
			// 移除旧菜单
			removePopupMenu();

			_popupMenu = menu;
			_initiator = initiator;
			_popupContainer.addChild(menu);
		}

		/**
		 * 移除弹出菜单
		 *
		 */
		public function removePopupMenu():void
		{
			if (_popupMenu != null)
			{
				_popupContainer.removeChild(_popupMenu);
				_popupMenu = null;
				_initiator = null;
			}
		}
		
		
		
		/**
		 * 移除所有弹出容器子项
		 * 
		 */
		public function removeAll():void
		{
			_popupContainer.removeChildren();
			for (var obj:Object in _modalWindows)
			{
				var window:IControl = obj as IControl;
				_modalWindows[window] = null;
				delete _modalWindows[window];
				window.removeEventListener(TouchEvent.MOUSE_DOWN, windowActivateHandler);
			}
			_popupMenu = null;
			_initiator = null;
		}


		/**
		 * 检测是否有需要关闭的菜单
		 * @param control
		 *
		 */
		internal function autoClosePopupMenu(control:IControl):void
		{
			if (_popupMenu != null)
			{
				if (control != _initiator && control != _popupMenu)
				{
					removePopupMenu();
				}
			}
		}



		/**
		 * 取得弹出窗口的层级
		 * @return
		 *
		 */
		private function getPopupWindowLayer():int
		{
			// 如果当前有弹出菜单，则返回弹出菜单所在的层级
			if (_popupMenu != null)
			{
				return _popupContainer.getChildIndex(_popupMenu);
			}

			// 返回最高层级
			return _popupContainer.numChildren;
		}
		
		
		public function resize(width:int, height:int):void
		{
			for each (var c:Container in _modalWindows)
			{
				c.resize(width, height);
			}
		}
	}
}
