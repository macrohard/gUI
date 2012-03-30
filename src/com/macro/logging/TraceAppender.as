package com.macro.logging
{
	import com.macro.utils.StrUtil;


	public class TraceAppender implements IAppender
	{
		private static const _seperator:String = " ";


		public var includeCategory:Boolean = true;

		public var includeLevel:Boolean = true;

		public var includeTime:Boolean = true;


		public function TraceAppender()
		{
		}

		public function send(category:String, message:String, level:int):String
		{
			var msg:String = "";
			if (includeTime)
			{
				msg += StrUtil.getTimeString() + _seperator;
			}

			if (includeLevel)
			{
				msg += "[" + LogLevel.getLevelString(level) + "]" + _seperator;
			}

			if (includeCategory)
			{
				msg += category + ":" + _seperator;
			}

			msg += message;
			trace(msg);

			return msg;
		}
	}
}
