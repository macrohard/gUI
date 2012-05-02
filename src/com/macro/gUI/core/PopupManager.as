package com.macro.gUI.core
{
	import com.macro.gUI.controls.Canvas;


	/**
	 * 弹出窗口管理器<br/>
	 * 窗口层级按从底到顶：普通弹出窗口 -> 模态弹出窗口 -> 弹出菜单<br/>
	 * 非模态窗口允许同时弹出多个容器，模态窗口一次只允许弹出一个，
	 * 如果有多个模态窗口，将会被队列。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class PopupManager
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
		 * 当前模态窗口
		 */
		private var _modalWindow:IControl;

		/**
		 * 模态窗口队列
		 */
		private var _modals:Vector.<IControl>;

		/**
		 * 模态窗口半透明背景
		 */
		private var _modalBg:Canvas;


		/**
		 * 弹出窗口管理器
		 * @param popupContainer 弹出窗口容器
		 *
		 */
		public function PopupManager(uiManager:UIManager)
		{
			_popupContainer = uiManager.popupContainer;
			_modals = new Vector.<IControl>();
		}
		
		
		private function get modalBg():Canvas
		{
			if (_modalBg == null)
			{
				_modalBg = new Canvas(_popupContainer.width, _popupContainer.height);
				_modalBg.backgroundColor = 0x33000000;
			}
			return _modalBg;
		}
		

		/**
		 * 添加弹出窗口
		 * @param window
		 * @param isModal 是否模态
		 * @param isCenter 是否居中显示
		 *
		 */
		public function addPopupWindow(window:IControl, isModal:Boolean = false, isCenter:Boolean = false):void
		{
			if (isCenter)
			{
				centerPopup(window);
			}

			if (isModal)
			{
				if (_modalWindow == null)
				{
					var layer:int = getPopupWindowLayer(true);
					_popupContainer.addChildAt(window, layer);
					_popupContainer.addChildAt(modalBg, layer);
					_modalWindow = window;
				}
				else
				{
					_modals.push(window);
				}
			}
			else
			{
				_popupContainer.addChildAt(window, getPopupWindowLayer(false));
			}
		}

		/**
		 * 移除弹出菜单或窗口
		 * @param window
		 *
		 */
		public function removePopupWindow(window:IControl):void
		{
			_popupContainer.removeChild(window);

			if (_modalWindow == window)
			{
				// 模态窗口队列中还有元素时，立即弹出新的模态窗口
				if (_modals.length > 0)
				{
					window = _modals.shift();
					_popupContainer.addChildAt(window, getPopupWindowLayer(true));
					_modalWindow = window;
				}
				else // 模态窗口队列中没有元素了，则移除模态窗口背景控件
				{
					_popupContainer.removeChild(modalBg);
					_modalWindow = null;
				}
			}
		}

		/**
		 * 将弹出窗口移到其它弹出窗口之前
		 * @param window 普通弹出窗口
		 *
		 */
		public function bringToFront(window:IControl):void
		{
			// 如果调整层级的窗口是模态窗口，则不处理
			if (_modalWindow != null && window == _modalWindow)
			{
				return;
			}

			_popupContainer.removeChild(window);
			_popupContainer.addChildAt(window, getPopupWindowLayer(false));
		}

		/**
		 * 居中显示弹出窗口
		 * @param window
		 *
		 */
		public function centerPopup(window:IControl):void
		{
			window.x = modalBg.width - window.width >> 1;
			window.y = modalBg.height - window.height >> 1;
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
		 * @param isModal 是否模态窗口
		 * @return
		 *
		 */
		private function getPopupWindowLayer(isModal:Boolean):int
		{
			// 如果不是模态窗口，且当前已有模态窗口，则返回模态窗口背景控件所在的层级
			if (!isModal && _modalWindow != null)
			{
				return _popupContainer.getChildIndex(modalBg);
			}

			// 如果当前有弹出菜单，则返回弹出菜单所在的层级
			if (_popupMenu != null)
			{
				return _popupContainer.getChildIndex(_popupMenu);
			}

			// 返回最高层级
			return _popupContainer.numChildren;
		}
	}
}
