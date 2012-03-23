package com.macro.gUI.base.feature
{
	import com.macro.gUI.base.feature.IFocus;
	

	/**
	 * 控件可以接收鼠标操作
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IButton extends IFocus
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