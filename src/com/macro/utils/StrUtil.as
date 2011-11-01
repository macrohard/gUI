package com.macro.utils
{


	public class StrUtil
	{
		
		public static const EMPTY:String = "";
		
		/**
		 * 格式化字符串。使用样例：<br/>
		 * StrUtil.format("role id[{0}] identity:{1}", role.duelId, role.identity);<br/>
		 * 结果是role.duelId替换{0}，role.identity替换{1}。<br/>
		 * @param message 源字符串
		 * @param params 替换参数
		 * @return 使用替换参数格式化后的字符串
		 * 
		 */
		public static function format(message:String, params:Array):String
		{
			if (!params)
				return message;
			
			var len:int = params.length;
			for (var i:int = 0; i < len; i++)
			{
				var param:* = params[i];
				if (param is Error)
				{
					var e:Error = param as Error;
					param = "\n" + e.getStackTrace();
				}
				message = message.replace(new RegExp("\\{" + i + "\\}", "g"), param);
			}
			return message;
		}
		
		/**
		 * 得到日期格式字符串
		 * @param date
		 * @return 
		 * 
		 */
		public static function getTimeString(date:Date = null):String
		{
			if (!date)
				date = new Date();
			
			var h:int = date.hours;
			var m:int = date.minutes;
			var s:int = date.seconds;
			var ms:int = date.milliseconds;
			
			var hour:String = String(h < 10 ? "0" + h : h);
			var minu:String = String(m < 10 ? "0" + m : m)
			var seco:String = String(s < 10 ? "0" + s : s)
			var mill:String = String(ms < 10 ? "00" + ms : (ms < 100 ? "0" + ms : ms))
			
			return hour + ":" + minu + ":" + seco + ":" + mill;
		}
		
		/**
		 * 去掉换行符后的字符串
		 * @param text
		 * @return 
		 * 
		 */
		public static function trimLines(text:String):String
		{
			var index1:int = text.indexOf("\n");
			var index2:int = text.indexOf("\r");
			
			if (index1 > -1 && (index2 == -1 || index1 < index2))
				text = text.substr(0, index1);
			else if (index2 > -1)
				text = text.substr(0, index2);
			
			return text;
		}
	}
}