package com.macro.gUI
{
	import com.macro.gUI.base.AbstractControl;
	import com.macro.gUI.managers.IRenderEngine;
	import com.macro.gUI.managers.InteractionManager;
	import com.macro.gUI.managers.SkinManager;
	import com.macro.gUI.managers.layeredRender.LayeredRenderEngine;
	import com.macro.gUI.managers.mergedRender.MergeRenderEngine;
	import com.macro.logging.LogFilter;
	import com.macro.logging.LogLevel;
	import com.macro.logging.Logger;
	import com.macro.logging.TraceAppender;
	
	import flash.display.Stage;


	/**
	 * GameUI核心类
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class GameUI
	{
		/**
		 * 版本号
		 */
		public static const version:String = "0.5";



		/**
		 * 合并渲染
		 */
		public static const RENDER_MODE_MERGE:int = 0;

		/**
		 * 分层渲染
		 */
		public static const RENDER_MODE_LAYER:int = 1;

		/**
		 * 硬件渲染
		 */
		public static const RENDER_MODE_STAGE3D:int = 2;




		private static var _skinManager:SkinManager;

		/**
		 * 皮肤管理器
		 * @return
		 *
		 */
		public static function get skinManager():SkinManager
		{
			return _skinManager;
		}



		private static var _uiManager:IRenderEngine;

		/**
		 * 界面管理器
		 * @return
		 *
		 */
		public static function get uiManager():IRenderEngine
		{
			return _uiManager;
		}

		
		
		private static var _interactionManager:InteractionManager;


		/**
		 * 初始化GameUI
		 *
		 */
		public static function init(renderMode:int, stage:Stage):void
		{
			if (renderMode == RENDER_MODE_MERGE)
			{
				_uiManager = new MergeRenderEngine();
			}
			else if (renderMode == RENDER_MODE_LAYER)
			{
				_uiManager = new LayeredRenderEngine();
			}
			else
			{
				throw new Error("Unsupport Render Mode!");
			}
			
			_interactionManager = new InteractionManager(stage);
			_skinManager = new SkinManager();

			AbstractControl.init(_uiManager, _skinManager);

			Logger.init(new TraceAppender(), new LogFilter(LogLevel.ALL));
			Logger.info(GameUI, "version:{0}", version);
		}

	}
}
