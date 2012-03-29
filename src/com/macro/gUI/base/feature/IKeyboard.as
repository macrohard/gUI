package com.macro.gUI.base.feature
{
	import flash.events.KeyboardEvent;

	/**
	 * 控件可以接收键盘操作，即可以接受焦点
	 * @author macro776@gmail.com
	 * 
	 */
	public interface IKeyboard
	{
		/**
		 * 获取焦点的顺序，当用户按下Tab键时，自动聚焦到索引数组中下一个控件上
		 * @return 
		 * 
		 */
		function get tabIndex():int;
		
		/**
		 * 按键按下
		 * @param e
		 * 
		 */
		function keyDown(e:KeyboardEvent):void;
		
		/**
		 * 按键弹起
		 * @param e
		 * 
		 */
		function keyUp(e:KeyboardEvent):void;
		
	}
}