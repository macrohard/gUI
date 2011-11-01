package com.macro.logging
{
	public interface IAppender
	{
		function send(category:String, message:String, level:int):String;
	}
}