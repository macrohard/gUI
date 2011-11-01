package com.macro.logging
{


	public class LogLevel
	{
		public static const FATAL:int = 1000;

		public static const ERROR:int = 8;

		public static const WARN:int = 6;

		public static const INFO:int = 4;

		public static const DEBUG:int = 2;

		public static const ALL:int = 0;


		private static const LEVEL_STRING:Vector.<String> = new <String> ["FATAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"];

		public static function getLevelString(level:int):String
		{
			switch (level)
			{
				case FATAL:
					return LEVEL_STRING[0];
				case ERROR:
					return LEVEL_STRING[1];
				case WARN:
					return LEVEL_STRING[2];
				case INFO:
					return LEVEL_STRING[3];
				case DEBUG:
					return LEVEL_STRING[4];
				default:
					return LEVEL_STRING[5];
			}
		}
	}
}