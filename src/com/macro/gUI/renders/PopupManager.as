package com.macro.gUI.renders
{
	import com.macro.gUI.base.IContainer;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.containers.Container;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;


	/**
	 * 最上层窗口管理器，包括弹出菜单及浮动窗口，协同UIManager工作
	 * 它是一个特殊控件，派生自Container，此控件保持与RootContainer相同大小，
	 * 并且在子控件数量大于1且模态时，设置背景色为半透明黑色
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class PopupManager extends Container
	{
		private var _popupControlsMap:Dictionary;

		private var _popupContainer:IContainer;

		private var _popupSprite:Sprite;


		private var _modal:Boolean;


		public function PopupManager()
		{
			_popupControlsMap = new Dictionary(true);
		}

		public function get modal():Boolean
		{
			return _modal;
		}


		/**
		 * 添加弹出窗口
		 * @param window
		 * @param modal 是否模态
		 *
		 */
		public function addPopupWindow(window:IContainer, modal:Boolean):void
		{

		}

		/**
		 * 添加弹出菜单
		 * @param menu
		 *
		 */
		public function addPopupMenu(menu:IControl):void
		{

		}

		/**
		 * 移除弹出菜单或窗口
		 * @param popupItem
		 *
		 */
		public function removePopup(popupItem:IControl):void
		{

		}
	}
}
