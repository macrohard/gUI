package com.macro.gUI
{
	import com.macro.gUI.skin.impl.BitmapSkin;
	import com.macro.logging.LogFilter;
	import com.macro.logging.LogLevel;
	import com.macro.logging.Logger;
	import com.macro.logging.TraceAppender;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import com.macro.gUI.managers.SkinManager;
	import com.macro.gUI.managers.UIManager;


	/**
	 * GameUI核心类
	 * @author Macro776@gmail.com
	 *
	 */
	public class GameUI
	{
		/**
		 * 版本号
		 */
		public static const vertion:String = "0.5";



		private static var _skinManager:SkinManager;
		
		

		private static var _uiManager:UIManager;
		
		
		
		/**
		 * 皮肤管理器
		 * @return 
		 * 
		 */
		public static function get skinManager():SkinManager
		{
			return _skinManager;
		}
		
		/**
		 * 根显示对象
		 * @return 
		 * 
		 */
		public static function get uiManager():UIManager
		{
			return _uiManager;
		}
		
		/**
		 * 初始化GameUI
		 * 
		 */
		public static function init():void
		{
			if (_uiManager)
			{
				return;
			}
			
			_uiManager = new UIManager();
			_skinManager = new SkinManager();
			
			Logger.init(new TraceAppender(), new LogFilter(LogLevel.ALL));
			Logger.info(GameUI, "version:{0}", vertion);
		}
		
	}
}