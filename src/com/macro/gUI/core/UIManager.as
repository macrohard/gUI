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
		 * 渲染器
		 */
		public var renderer:IRenderEngine;
		
		/**
		 * 皮肤管理器
		 */
		public var skinManager:SkinManager;

		/**
		 * 交互管理器
		 */
		public var interactiveManager:InteractiveManager;
		
		/**
		 * 拖放管理器
		 */
		public var dragManager:DragManager;
		
		/**
		 * 焦点管理器
		 */
		public var focusManager:FocusManager;
		
		/**
		 * 弹出窗口管理器
		 *
		 */
		public var popupManager:PopUpManager;
		
		
		/**
		 * 根容器
		 */
		internal var _root:Container;
		
		/**
		 * 主容器，此容器中的控件会被交互管理器监测
		 */
		internal var _main:Container;
		
		/**
		 * 舞台容器，所有控件都在此容器中
		 */
		private var _stage:Container;

		/**
		 * 弹出窗口容器
		 */
		internal var _popup:Container;
		
		/**
		 * 最上层容器，一般用于交互管理器绘制焦点框、拖拽替身图像、Tip信息显示等
		 * 此容器中的控件不参与交互
		 */
		internal var _top:Container;
		

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
			_root.name = "Root";
			_main = new Container(width, height);
			_main.name = "Main";
			_stage = new Container(width, height);
			_stage.name = "Stage";
			_popup = new Container(width, height);
			_popup.name = "Popup";
			_top = new Container(width, height);
			_top.name = "Top";

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
			popupManager = new PopUpManager(this);
			dragManager = new DragManager(this);
			focusManager = new FocusManager(this, displayObjectContainer);
			interactiveManager = new InteractiveManager(this, displayObjectContainer);

			AbstractControl.init(this);
			
			// 初始化整个UI体系层级结构
			_main.addChild(_stage);
			_main.addChild(_popup);
			
			_root.addChild(_main);
			_root.addChild(_top);
		}
		
		
		/**
		 * 舞台容器，所有控件都在此容器中
		 * @return
		 *
		 */
		public function get stage():IContainer
		{
			return _stage;
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
			_main.resize(width, height);
			_stage.resize(width, height);
			_popup.resize(width, height);
			_top.resize(width, height);
			popupManager.resize(width, height);
		}
	}
}
