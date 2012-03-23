package com.macro.gUI.base
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * 容器
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IContainer extends IControl
	{
		/**
		 * 容器顶层画布，用于形成遮挡效果
		 * @return 
		 * 
		 */
		function get bitmapDataCover():BitmapData;
		
		/**
		 * 可视范围边距，它影响子控件的可见性。<br>
		 * 如：容器尺寸定义是(100, 100)，margin定义是[5, 5, 5, 5]，
		 * 则容器可视范围矩形是[5, 5, 95, 95]，注意，margin中四个数值是left, top, right, bottom
		 * @return 
		 * 
		 */
		function get margin():Rectangle;
		
		/**
		 * 子控件
		 * @return 
		 * 
		 */
		function get children():Vector.<IControl>;
		
		/**
		 * 添加子控件
		 * @param child
		 * 
		 */
		function addChild(child:IControl):void;
		
		/**
		 * 在给定深度添加子控件
		 * @param child
		 * @param index
		 * 
		 */
		function addChildAt(child:IControl, index:int):void;
		
		/**
		 * 移除子控件
		 * @param child
		 * 
		 */
		function removeChild(child:IControl):void;
		
		/**
		 * 移除指定深度的控件，并将其返回
		 * @param index
		 * @return 
		 * 
		 */
		function removeChildAt(index:int):IControl;
	}
}