package com.macro.gUI.base.feature
{
	import flash.events.KeyboardEvent;


	/**
	 * 控件可以接收键盘操作，前提条件是控件可以获取焦点
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IKeyboard extends IFocus
	{

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
