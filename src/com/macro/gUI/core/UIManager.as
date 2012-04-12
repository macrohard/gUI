package com.macro.gUI.core
{
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.renders.IRenderEngine;
	import com.macro.gUI.renders.RenderMode;
	import com.macro.gUI.renders.layeredRender.LayeredRenderEngine;
	import com.macro.gUI.renders.mergedRender.MergeRenderEngine;
	import com.macro.gUI.skin.SkinManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;


	/**
	 * 界面管理器
	 * 使用Stage3D时，需要分散渲染，否则从内存上传位图数据到显存会带来巨大开销。
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class UIManager
	{

		/**
		 * 渲染器
		 */
		private var _render:IRenderEngine;

		/**
		 * 交互管理器
		 */
		private var _interactionManager:InteractionManager;


		/**
		 * 根容器
		 */
		private var _root:Container;
		
		/**
		 * 主容器，所有控件都在此容器中
		 */
		private var _main:Container;
		
		/**
		 * 弹出窗口容器
		 */
		private var _popup:Container;


		/**
		 * 界面管理器
		 * @param renderMode 渲染模式
		 * @param container 显示容器
		 * @param width 宽度
		 * @param height 高度
		 * 
		 */
		public function UIManager(renderMode:int, container:DisplayObjectContainer, width:int, height:int)
		{
			_root = new Container(width, height);
			
			if (renderMode == RenderMode.RENDER_MODE_MERGE)
			{
				_render = new MergeRenderEngine(_root, container, width, height);
			}
			else if (renderMode == RenderMode.RENDER_MODE_LAYER)
			{
				_render = new LayeredRenderEngine(_root, container, width, height);
			}
			else
			{
				throw new Error("Unsupport Render Mode!");
			}
			_skinManager = new SkinManager();
			_interactionManager = new InteractionManager(_root, container);
			
			AbstractControl.init(_render, _skinManager);
			
			_main = new Container(width, height);
			_popup = new Container(width, height);
			_root.addChild(_main);
			_root.addChild(_popup);
		}


		private var _skinManager:SkinManager;

		/**
		 * 皮肤管理器
		 * @return
		 *
		 */
		public function get skinManager():SkinManager
		{
			return _skinManager;
		}

		
		
		/**
		 * 主容器
		 * @return 
		 * 
		 */
		public function get mainContainer():IContainer
		{
			return _main;
		}


		
		/**
		 * 添加弹出窗口
		 * @param window
		 * @param modal 是否模态
		 *
		 */
		public function addPopupWindow(window:IContainer,
									   modal:Boolean = true):void
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
