package com.macro.gUI.base
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 控件
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IControl
	{
		/**
		 * 画布
		 * @return 
		 * 
		 */
		function get bitmapData():BitmapData;
		
		/**
		 * 控件坐标及大小
		 * @return 
		 * 
		 */
		function get rect():Rectangle;
		
		/**
		 * 透明度
		 * @return 
		 * 
		 */
		function get alpha():Number;
		
		/**
		 * 控件是否可见
		 * @return 
		 * 
		 */
		function get visible():Boolean;
		
		/**
		 * 获取父级容器
		 * @return 
		 * 
		 */
		function get parent():IContainer;
		
		/**
		 * 获取控件的全局坐标
		 * @return 
		 * 
		 */
		function localToGlobal():Point;
		
	}
}