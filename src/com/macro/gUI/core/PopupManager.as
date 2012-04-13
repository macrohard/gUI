package com.macro.gUI.core
{
	import com.macro.gUI.containers.Container;
	
	/**
	 * 弹出窗口管理器，是一个特殊容器，它继承自Container。
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class PopupManager extends Container
	{
		
		private var _menu:IControl;
		
		/**
		 * 弹出窗口管理器
		 * @param width
		 * @param height
		 * 
		 */
		public function PopupManager(width:int=100, height:int=100)
		{
			super(width, height);
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
		 * 添加弹出菜单
		 * @param menu
		 *
		 */
		public function addPopupMenu(menu:IControl):void
		{
			_menu = menu;
			addChild(_menu);
		}
		
		public function removePopupMenu():void
		{
			if (_menu != null)
			{
				removeChild(_menu);
				_menu = null;
			}
		}
	}
}