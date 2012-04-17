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
		 * 皮肤管理器
		 */
		public var skinManager:SkinManager;


		/**
		 * 弹出窗口管理器
		 *
		 */
		public var popupManager:PopupManager;


		/**
		 * 交互管理器
		 */
		private var _interactionManager:InteractionManager;


		/**
		 * 渲染器
		 */
		private var _render:IRenderEngine;



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
			_main = new Container(width, height);
			_popup = new Container(width, height);
			_top = new Container(width, height);

			if (renderMode == RenderMode.RENDER_MODE_MERGE)
			{
				_render = new MergeRenderEngine(_root, displayObjectContainer);
			}
			else if (renderMode == RenderMode.RENDER_MODE_LAYER)
			{
				_render = new LayeredRenderEngine(_root, displayObjectContainer);
			}
			else
			{
				throw new Error("Unsupport Render Mode!");
			}

			skinManager = new SkinManager();
			popupManager = new PopupManager(_popup);
			_interactionManager = new InteractionManager(this, displayObjectContainer);

			AbstractControl.init(this);

			// 初始化整个UI体系层级结构
			_root.addChild(_main);
			_root.addChild(_popup);
			_root.addChild(_top);
		}


		private var _root:IContainer;

		/**
		 * 根容器
		 */
		internal function get root():IContainer
		{
			return _root;
		}


		private var _main:IContainer;

		/**
		 * 主容器，所有控件都在此容器中
		 * @return
		 *
		 */
		public function get mainContainer():IContainer
		{
			return _main;
		}


		private var _popup:IContainer;

		/**
		 * 弹出窗口容器
		 */
		internal function get popupContainer():IContainer
		{
			return _popup;
		}


		private var _top:IContainer;

		/**
		 * 最上层窗口容器，一般用于交互管理器绘制焦点框、拖拽替身图像等
		 */
		internal function get topContainer():IContainer
		{
			return _top;
		}



		/**
		 * 添加弹出窗口
		 * @param window
		 * @param isModal 是否模态
		 * @param isCenter 是否居中显示
		 * 
		 */
		public function addPopupWindow(window:IContainer, isModal:Boolean = false, isCenter:Boolean = false):void
		{
			popupManager.addPopupWindow(window, isModal, isCenter);
		}

		/**
		 * 移除弹出窗口
		 * @param popupItem
		 *
		 */
		public function removePopupWindow(window:IControl):void
		{
			popupManager.removePopupWindow(window);
		}
	}
}
