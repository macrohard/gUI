package com.macro.gUI.managers
{
	import com.macro.gUI.base.IComposite;
	import com.macro.gUI.base.IContainer;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.render.RComposite;
	import com.macro.gUI.render.RContainer;
	import com.macro.gUI.render.RControl;

	import flash.display.Sprite;
	import flash.utils.Dictionary;


	/**
	 * 最上层窗口管理器，包括弹出菜单及浮动窗口，协同UIManager工作
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


		public function init():void
		{

		}

		/**
		 * 渲染控件
		 * @param container
		 *
		 */
		private function render(container:IComposite):void
		{
//			var parent:RComposite = _popupControlsMap[container];
//			for each (var child:IControl in container.children)
//			{
//				if (child is IContainer)
//				{
//					var subcontainer:RContainer = _popupControlsMap[child];
//					if (!subcontainer)
//					{
//						subcontainer = new RContainer(IContainer(child));
//						render(IContainer(child));
//						_popupControlsMap[child] = subcontainer;
//					}
//					
//					parent.container.addChild(subcontainer.canvas);
//					parent.container.addChild(subcontainer.container);
//					parent.container.addChild(subcontainer.mask);
//					parent.container.addChild(subcontainer.cover);
//					
//				}
//				else if (child is IComposite)
//				{
//					var subcomposite:RComposite = _popupControlsMap[child];
//					if (!subcomposite)
//					{
//						subcomposite = new RComposite(IComposite(child));
//						render(IComposite(child));
//						_popupControlsMap[child] = subcomposite;
//					}
//					
//					parent.container.addChild(subcomposite.canvas);
//					parent.container.addChild(subcomposite.container);
//					parent.container.addChild(subcomposite.mask);
//					
//				}
//				else if (child is IControl)
//				{
//					var subcontrol:RControl = _popupControlsMap[child];
//					if (!subcontrol)
//					{
//						subcontrol = new RControl(child);
//						_popupControlsMap[child] = subcontrol;
//					}
//					
//					parent.container.addChild(subcontrol.canvas);
//					
//				}
//			}
		}

		/**
		 * 销毁弹出容器
		 *
		 */
		public function disposePopupSprite():void
		{
			for each (var child:RControl in _popupControlsMap)
				child.dispose();

			_popupControlsMap = new Dictionary(true);
			_popupContainer = null;
			_popupSprite = null;
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
