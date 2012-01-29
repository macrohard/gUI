package com.macro.logging
{
	import flash.utils.Dictionary;


	/**
	 * 日志过滤器
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class LogFilter
	{

		private var _logLevels:Dictionary;

		private var _rootLevel:int = LogLevel.ALL;

		/**
		 * 日志输出总阀
		 * @return 
		 * 
		 */
		public function get rootLevel():int
		{
			return _rootLevel;
		}

		/**
		 * 日志输出总阀
		 * @param value
		 * 
		 */
		public function set rootLevel(value:int):void
		{
			_rootLevel = value;
		}


		public function LogFilter(level:int)
		{
			_rootLevel = level;
			_logLevels = new Dictionary();
		}

		/**
		 * 添加对应类路径的过滤级别
		 * @param category
		 * @param level
		 * 
		 */
		public function addLogLevel(category:String, level:int):void
		{
			_logLevels[category] = level;
		}

		/**
		 * 移除对应类路径的过滤级别
		 * @param category
		 * 
		 */
		public function removeLogLevel(category:String):void
		{
			_logLevels[category] = null;
			delete _logLevels[category];
		}

		/**
		 * 过滤日志
		 * @param path
		 * @param level
		 * @return true则表示日志可以发送
		 *
		 */
		public function filter(category:String, level:int):Boolean
		{
			var logLevel:int = findLevel(category);

			if (level >= logLevel)
				return true;
			else
				return false;
		}

		private function findLevel(category:String):int
		{
			if (_logLevels[category] != null)
				return _logLevels[category];
			
			var p:String = getParentPath(category);
			if (p)
				return findLevel(p);
			else
				return _rootLevel;
		}
		
		private function getParentPath(path:String):String
		{
			var idx:int = path.lastIndexOf(".");
			if (idx == -1)
				return null;
			return path.substr(0, idx);
		}
	}
}