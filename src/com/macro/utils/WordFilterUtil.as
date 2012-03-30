package com.macro.utils
{


	/**
	 * 敏感词过滤
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class WordFilterUtil
	{
		public static var lawlessWord:String;

		public static const CYPHER_TEXT:String = "********************";

		/**
		 * 按消息逐字过滤处理，而不是按字典逐条处理
		 * @param msg
		 * @return
		 *
		 */
		public static function filter(msg:String):String
		{
			var len:int = msg.length;
			for (var i:int; i < len; i++)
			{
				var char:String = msg.charAt(i);
				var start:int = 0;
				var index:int = lawlessWord.indexOf(char, start);
				while (index != -1)
				{
					if (index == 0 || lawlessWord.charCodeAt(index - 1) == 10)
					{
						var j:int = index + 1;
						while (lawlessWord.charCodeAt(j) != 10 && j < lawlessWord.length)
						{
							j++;
						}

						var s:String = lawlessWord.substring(index, j);
						j = j - index;
						if (msg.substr(i, j) == s)
						{
							msg = msg.substring(0, i) + CYPHER_TEXT.substr(0, j) + msg.substring(i + j);
							i += j;
							break;
						}
					}

					start = index + 1;
					index = lawlessWord.indexOf(char, start);
				}
			}
			return msg;

		}
	}
}
