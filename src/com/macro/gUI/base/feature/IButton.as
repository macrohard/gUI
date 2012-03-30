package com.macro.gUI.base.feature
{


	/**
	 * 控件具有鼠标状态
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IButton
	{

		/**
		 * 鼠标按下
		 *
		 */
		function mouseDown():void;

		/**
		 * 鼠标松开
		 *
		 */
		function mouseUp():void;

		/**
		 * 鼠标移入
		 *
		 */
		function mouseOver():void;

		/**
		 * 鼠标移出
		 *
		 */
		function mouseOut():void;

	}
}
