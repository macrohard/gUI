package com.macro.gUI
{
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
		 * 初始化GameUI。建议对Stage作如下初始化设置：<p>
		 * stage.stageFocusRect = false;<br/>
		 * stage.tabChildren = false;<br/>
		 * stage.scaleMode = StageScaleMode.NO_SCALE;</p>
		 *
		 * @param container 显示容器，如stage
		 * @param width 显示容器的宽度，如stage.stageWidth
		 * @param height 显示容器的高度，如stage.stageHeight
		 * @param renderMode 渲染模式，默认使用合并渲染
		 *
		 */
		public static function init(container:DisplayObjectContainer, width:int, height:int, renderMode:int = 0):void
		{
			if (container == null)
			{
				throw new Error("Stage can not be null.");
			}
			_uiManager = new UIManager(renderMode, container, width, height);

			Logger.init(new TraceAppender(), new LogFilter(LogLevel.ALL));
			Logger.info(GameUI, "version:{0}", version);
		}

	}
}
