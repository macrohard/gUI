package com.macro.gUI
{
	import com.macro.gUI.base.IComposite;
	import com.macro.gUI.base.IContainer;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.render.R_Composite;
	import com.macro.gUI.render.R_Container;
	import com.macro.gUI.render.R_Control;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;


	/**
	 * 界面管理器，构建基于Sprite的视图结构，并处理控件的添加、删除行为
	 * @author Macro776@gmail.com
	 *
	 */
	public class UIManager
	{
		private var _interactionManager:InteractionManager;

		private var _popupManager:PopupManager;


		
		private var _controlsMap:Dictionary;
		
		

		private var _rootContainer:IContainer;

		private var _rootSprite:Sprite;
		
		
		
		


		public function UIManager()
		{
			_interactionManager = new InteractionManager(this);
			_popupManager = new PopupManager();
			
			_controlsMap = new Dictionary(true);
		}

		public function get rootContainer():IContainer
		{
			return _rootContainer;
		}

		public function get rootSprite():Sprite
		{
			return _rootSprite;
		}

		/**
		 * 渲染根容器
		 * @param container
		 * @return
		 *
		 */
		public function renderRootSprite(container:IContainer):Sprite
		{
			if (_rootContainer)
				disposeRootSprite();

			var rootcontainer:R_Container = new R_Container(container);
			
			_rootSprite = new Sprite();
			_rootSprite.addChild(rootcontainer.canvas);
			_rootSprite.addChild(rootcontainer.container);
			_rootSprite.addChild(rootcontainer.mask);
			_rootSprite.addChild(rootcontainer.cover);
			_controlsMap[container] = rootcontainer;

			render(container);

			_rootContainer = container;
			_interactionManager.init();
			_popupManager.init();
			
			return _rootSprite;
		}


		/**
		 * 渲染控件
		 * @param container
		 *
		 */
		private function render(container:IComposite):void
		{
			var parent:R_Composite = _controlsMap[container];
			for each (var child:IControl in container.children)
			{
				if (child is IContainer)
				{
					var subcontainer:R_Container = _controlsMap[child];
					if (!subcontainer)
					{
						subcontainer = new R_Container(IContainer(child));
						render(IContainer(child));
						_controlsMap[child] = subcontainer;
					}

					parent.container.addChild(subcontainer.canvas);
					parent.container.addChild(subcontainer.container);
					parent.container.addChild(subcontainer.mask);
					parent.container.addChild(subcontainer.cover);

				}
				else if (child is IComposite)
				{
					var subcomposite:R_Composite = _controlsMap[child];
					if (!subcomposite)
					{
						subcomposite = new R_Composite(IComposite(child));
						render(IComposite(child));
						_controlsMap[child] = subcomposite;
					}

					parent.container.addChild(subcomposite.canvas);
					parent.container.addChild(subcomposite.container);
					parent.container.addChild(subcomposite.mask);

				}
				else if (child is IControl)
				{
					var subcontrol:R_Control = _controlsMap[child];
					if (!subcontrol)
					{
						subcontrol = new R_Control(child);
						_controlsMap[child] = subcontrol;
					}

					parent.container.addChild(subcontrol.canvas);

				}
			}
		}


		/**
		 * 销毁根容器
		 *
		 */
		public function disposeRootSprite():void
		{
			for each (var child:R_Control in _controlsMap)
				child.dispose();

			_controlsMap = new Dictionary(true);
			_rootContainer = null;
			_rootSprite = null;
			
			_popupManager.disposePopupSprite();
		}



		/**
		 * 更新控件的位置
		 * @param control
		 *
		 */
		public function updateLocation(control:IControl):void
		{
			var rcontrol:R_Control = _controlsMap[control];
			if (rcontrol)
				rcontrol.updateLocation();
		}

		/**
		 * 更新控件的源图，这是由于控件的源图尺寸发生了变化，重新创建了BitmapData
		 * @param control
		 *
		 */
		public function updateSource(control:IControl):void
		{
			var rcontrol:R_Control = _controlsMap[control];
			if (rcontrol)
				rcontrol.updateSource();
		}

		/**
		 * 更新控件的透明度
		 * @param control
		 *
		 */
		public function updateAlpha(control:IControl):void
		{
			var rcontrol:R_Control = _controlsMap[control];
			if (rcontrol)
				rcontrol.updateAlpha();
		}

		/**
		 * 更新控件的可见性
		 * @param control
		 *
		 */
		public function updateVisible(control:IControl):void
		{
			var rcontrol:R_Control = _controlsMap[control];
			if (rcontrol)
				rcontrol.updateVisible();
		}



		/**
		 * 更新容器，通常是由于addChild或removeChild
		 * @param container
		 *
		 */
		public function updateContainer(container:IContainer):void
		{
			var rcontainer:R_Container = _controlsMap[container];
			if (rcontainer)
			{
				while (rcontainer.container.numChildren > 0)
					rcontainer.container.removeChildAt(0);

				render(container);
			}
		}


		/**
		 * 添加弹出窗口
		 * @param window
		 * @param modal 是否模态
		 * 
		 */
		public function addPopupWindow(window:IContainer, modal:Boolean = true):void
		{
			_popupManager.addPopupWindow(window, modal);
		}

		/**
		 * 添加弹出菜单
		 * @param menu
		 *
		 */
		public function addPopupMenu(menu:IControl):void
		{
			_popupManager.addPopupMenu(menu);
		}

		/**
		 * 移除弹出菜单或窗口
		 * @param popupItem
		 *
		 */
		public function removePopup(popupItem:IControl):void
		{
			_popupManager.removePopup(popupItem);
		}


	}
}
