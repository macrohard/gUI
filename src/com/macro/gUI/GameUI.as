package com.macro.gUI
{
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.renders.IRenderEngine;
	import com.macro.gUI.renders.layeredRender.LayeredRenderEngine;
	import com.macro.gUI.renders.mergedRender.MergeRenderEngine;
	import com.macro.gUI.skin.SkinManager;
	import com.macro.logging.LogFilter;
	import com.macro.logging.LogLevel;
	import com.macro.logging.Logger;
	import com.macro.logging.TraceAppender;

	import flash.display.DisplayObjectContainer;
	import com.macro.gUI.core.UIManager;


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





		private static var _uiManager:UIManager;

		/**
		 * 界面管理器
		 * @return
		 *
		 */
		public static function get uiManager():UIManager
		{
			return _uiManager;
		}


		/**
		 * 皮肤管理器
		 * @return
		 *
		 */
		public static function get skinManager():SkinManager
		{
			return _uiManager.skinManager;
		}



		/**
		 * 初始化GameUI
		 * @param renderMode 渲染模式
		 * @param container 显示容器，如Stage
		 *
		 */
		public static function init(renderMode:int,
									container:DisplayObjectContainer):void
		{

			_uiManager = new UIManager(renderMode, container);

			Logger.init(new TraceAppender(), new LogFilter(LogLevel.ALL));
			Logger.info(GameUI, "version:{0}", version);
		}

	}
}
