package com.macro.logging
{
	import com.macro.utils.StrUtil;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.getQualifiedClassName;


	/**
	 * 日志工具
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Logger
	{

		private static var _appender:IAppender;

		public static function get appender():IAppender
		{
			return _appender;
		}


		private static var _filter:LogFilter;

		public static function get filter():LogFilter
		{
			return _filter;
		}


		/**
		 * 初始化日志工具
		 * @param appender 日志输出
		 * @param filter 日志过滤
		 *
		 */
		public static function init(appender:IAppender, filter:LogFilter):void
		{
			_appender = appender;
			_filter = filter;
		}


		public static function trace(cls:Object, message:String,
									 ... params):void
		{
			var category:String = getCategory(cls);
			if (_filter.filter(category, LogLevel.ALL))
			{
				_appender.send(category, StrUtil.format(message, params),
							   LogLevel.ALL);
			}
		}

		public static function debug(cls:Object, message:String,
									 ... params):void
		{
			var category:String = getCategory(cls);
			if (_filter.filter(category, LogLevel.DEBUG))
			{
				_appender.send(category, StrUtil.format(message, params),
							   LogLevel.DEBUG);
			}
		}

		public static function info(cls:Object, message:String, ... params):void
		{
			var category:String = getCategory(cls);
			if (_filter.filter(category, LogLevel.INFO))
			{
				_appender.send(category, StrUtil.format(message, params),
							   LogLevel.INFO);
			}
		}

		public static function warn(cls:Object, message:String, ... params):void
		{
			var category:String = getCategory(cls);
			if (_filter.filter(category, LogLevel.WARN))
			{
				_appender.send(category, StrUtil.format(message, params),
							   LogLevel.WARN);
			}
		}

		public static function error(cls:Object, message:String,
									 ... params):void
		{
			var category:String = getCategory(cls);
			if (_filter.filter(category, LogLevel.ERROR))
			{
				_appender.send(category, StrUtil.format(message, params),
							   LogLevel.ERROR);
			}
		}

		public static function fatal(cls:Object, message:String,
									 ... params):void
		{
			var category:String = getCategory(cls);
			if (_filter.filter(category, LogLevel.FATAL))
			{
				_appender.send(category, StrUtil.format(message, params),
							   LogLevel.FATAL);
			}
		}

		public static function getCategory(cls:Object):String
		{
			var category:String = (cls is String ? String(cls) : getQualifiedClassName(cls));
			return category.replace("::", ".");
		}

	}
}
