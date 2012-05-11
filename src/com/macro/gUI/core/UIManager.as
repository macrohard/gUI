package com.macro.gUI.core
{
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.renders.IRenderEngine;
	import com.macro.gUI.renders.RenderMode;
	import com.macro.gUI.renders.layeredRender.LayeredRenderEngine;
	import com.macro.gUI.renders.mergedRender.MergeRenderEngine;
	import com.macro.gUI.skin.SkinManager;
	
	import flash.display.DisplayObjectContainer;


	/**
	 * 界面管理器
	 * 使用Stage3D时，需要分散渲染，否则从内存上传位图数据到显存会带来巨大开销。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class UIManager
	{
		
		/**
		 * 皮肤管理器
		 */
		public var skinManager:SkinManager;


		/**
		 * 渲染器
		 */
		public var renderer:IRenderEngine;
		
		/**
		 * 弹出窗口管理器
		 *
		 */
		public var popupManager:PopupManager;


		/**
		 * 交互管理器
		 */
		internal var interactionManager:InteractionManager;
		
		
		/**
		 * 根容器
		 */
		private var _root:Container;



		/**
		 * 界面管理器
		 * @param renderMode 渲染模式
		 * @param container 显示对象容器
		 * @param width 宽度
		 * @param height 高度
		 *
		 */
		public function UIManager(renderMode:int, displayObjectContainer:DisplayObjectContainer, width:int, height:int)
		{
			_root = new Container(width, height);
			_stage = new Container(width, height);
			_main = new Container(width, height);
			_popup = new Container(width, height);
			_top = new Container(width, height);

			if (renderMode == RenderMode.RENDER_MODE_MERGE)
			{
				renderer = new MergeRenderEngine(_root, displayObjectContainer);
			}
			else if (renderMode == RenderMode.RENDER_MODE_LAYER)
			{
				renderer = new LayeredRenderEngine(_root, displayObjectContainer);
			}
			else
			{
				throw new Error("Unsupport Render Mode!");
			}

			skinManager = new SkinManager();
			popupManager = new PopupManager(this);
			interactionManager = new InteractionManager(this, displayObjectContainer);

			AbstractControl.init(this);
			
			// 初始化整个UI体系层级结构
			_root.setStage(_stage);
			_stage.addChild(_main);
			_stage.addChild(_popup);
			
			_root.addChild(_stage);
			_root.addChild(_top);
		}
		
		

		private var _stage:Container;

		/**
		 * 根容器
		 */
		public function get stage():IContainer
		{
			return _stage;
		}


		private var _main:Container;

		/**
		 * 主容器，所有控件都在此容器中
		 * @return
		 *
		 */
		public function get mainContainer():IContainer
		{
			return _main;
		}


		private var _popup:Container;

		/**
		 * 弹出窗口容器
		 */
		public function get popupContainer():IContainer
		{
			return _popup;
		}


		private var _top:Container;

		/**
		 * 最上层容器，一般用于交互管理器绘制焦点框、拖拽替身图像、Tip信息显示等
		 * 此容器中的控件不参与交互
		 */
		public function get topContainer():IContainer
		{
			return _top;
		}
		
		
		
		/**
		 * 舞台宽度
		 * @return 
		 * 
		 */
		public function get stageWidth():int
		{
			return _stage.width;
		}
		
		/**
		 * 舞台高度
		 * @return 
		 * 
		 */
		public function get stageHeight():int
		{
			return _stage.height;
		}
		
		
		public function resizeStage(width:int, height:int):void
		{
			_root.resize(width, height);
			_stage.resize(width, height);
			_main.resize(width, height);
			_popup.resize(width, height);
			_top.resize(width, height);
			popupManager.resize(width, height);
		}
	}
}
