package com.macro.gUI.core.feature
{
	import com.macro.gUI.core.IControl;
	
	import flash.events.IEventDispatcher;


	/**
	 * 控件具有鼠标状态
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IButton extends IControl
	{

		/**
		 * 鼠标按下
		 * @param target 点击的目标控件，基本控件或复合控件的内部控件
		 *
		 */
		function mouseDown(target:IControl):void;

		/**
		 * 鼠标松开
		 * @param target 点击的目标控件，基本控件或复合控件的内部控件
		 *
		 */
		function mouseUp(target:IControl):void;

		/**
		 * 鼠标移入
		 * @param target 点击的目标控件，基本控件或复合控件的内部控件
		 *
		 */
		function mouseOver(target:IControl):void;

		/**
		 * 鼠标移出
		 * @param target 点击的目标控件，基本控件或复合控件的内部控件
		 *
		 */
		function mouseOut(target:IControl):void;

	}
}
