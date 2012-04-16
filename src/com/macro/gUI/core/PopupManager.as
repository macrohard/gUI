package com.macro.gUI.core
{
	import com.macro.gUI.containers.Container;


	/**
	 * 弹出窗口管理器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class PopupManager
	{
		private var _popupContainer:IContainer;
		

		private var _menu:IControl;
		
		private var _modalWindow:IControl;
		
		private var _modals:Vector.<IControl>;
		

		/**
		 * 弹出窗口管理器
		 * @param popupContainer 弹出窗口容器
		 *
		 */
		public function PopupManager(popupContainer:IContainer)
		{
			_popupContainer = popupContainer;
		}

		/**
		 * 添加弹出窗口
		 * @param window
		 * @param modal 是否模态
		 *
		 */
		public function addPopupWindow(window:IControl,
									   modal:Boolean = true):void
		{
		}

		/**
		 * 移除弹出菜单或窗口
		 * @param popupItem
		 *
		 */
		public function removePopupWindow(window:IControl):void
		{
		}
		
		/**
		 * 将弹出窗口移到其它弹出窗口之前
		 * @param window
		 * 
		 */
		public function bringToFront(window:IControl):void
		{
			
		}
		
		/**
		 * 居中显示弹出窗口
		 * @param window
		 * 
		 */
		public function centerPopup(window:IControl):void
		{
			
		}

		/**
		 * 添加弹出菜单
		 * @param menu
		 *
		 */
		public function addPopupMenu(menu:IControl):void
		{
			_menu = menu;
			_popupContainer.addChild(_menu);
		}

		public function removePopupMenu(menu:IControl):void
		{
			if (_menu != null && _menu == menu)
			{
				_popupContainer.removeChild(_menu);
				_menu = null;
			}
		}
	}
}
