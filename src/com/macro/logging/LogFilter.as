package com.macro.logging
{
	import flash.utils.Dictionary;


	public class LogFilter
	{

		private var _logLevels:Dictionary;

		private var _rootLevel:int = LogLevel.ALL;

		public function get rootLevel():int
		{
			return _rootLevel;
		}

		public function set rootLevel(value:int):void
		{
			_rootLevel = value;
		}


		public function LogFilter(level:int)
		{
			_rootLevel = level;
			_logLevels = new Dictionary();
		}

		public function addLogLevel(category:String, level:int):void
		{
			_logLevels[category] = level;
		}

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
			if (_logLevels[category])
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