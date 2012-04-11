package com.macro.utils
{


	public class StrUtil
	{

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
			{
				return message;
			}

			var len:int = params.length;
			for (var i:int = 0; i < len; i++)
			{
				var param:* = params[i];
				if (param is Error)
				{
					var e:Error = param as Error;
					param = "\n" + e.getStackTrace();
				}
				message = message.replace(new RegExp("\\{" + i + "\\}", "g"),
													 param);
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
			{
				date = new Date();
			}

			var ms:int = date.milliseconds;
			var mill:String = ":" + (ms < 10 ? "00" + ms : (ms < 100 ? "0" + ms : ms));

			return date.toTimeString().split(" ")[0] + mill;
		}

		/**
		 * 获取时间表示的字符串形式
		 * @param time 从1970年1月1日0时0分0秒开始的时间戳，毫秒为单位
		 * @return
		 *
		 */
		public static function getTimeStr(time:Number):String
		{
			var date:Date = new Date(0);
			date.setTime(time + date.timezoneOffset * 60000);
			return date.toTimeString().split(" ")[0];
		}

		/**
		 * 获取日期表示的字符串形式，如：1970-1-1
		 * @param time 从1970年1月1日0时0分0秒开始的时间戳，毫秒为单位
		 * @return
		 *
		 */
		public static function getDateStr(time:Number):String
		{
			var date:Date = new Date(0);
			date.setTime(time + date.timezoneOffset * 60000);
			return date.fullYear + "-" + date.month + "-" + date.date;
		}

		/**
		 * 将色彩数值转换为字符串，格式如：#FFFFFF
		 * @param color
		 * @return
		 *
		 */
		public static function getColorStr(color:int):String
		{
			var str:String = color.toString(16);
			return "#" + str;
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
			{
				text = text.substr(0, index1);
			}
			else if (index2 > -1)
			{
				text = text.substr(0, index2);
			}

			return text;
		}

		/**
		 * 移除两边空白
		 * @param char
		 * @return
		 *
		 */
		public static function trim(str:String):String
		{
			if (str == null)
			{
				return null;
			}
			return rtrim(ltrim(str));
		}

		/**
		 * 移除左边空白
		 * @param char
		 * @return
		 *
		 */
		public static function ltrim(str:String):String
		{
			if (str == null)
			{
				return null;
			}
			var pattern:RegExp = /^\s*/;
			return str.replace(pattern, "");
		}

		/**
		 * 移除右边空白
		 * @param char
		 * @return
		 *
		 */
		public static function rtrim(str:String):String
		{
			if (str == null)
			{
				return null;
			}
			var pattern:RegExp = /\s*$/;
			return str.replace(pattern, "");
		}
	}
}
