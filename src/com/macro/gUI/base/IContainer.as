package com.macro.gUI.base
{
	import flash.display.BitmapData;

	/**
	 * 容器
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IContainer extends IComposite
	{
		/**
		 * 容器顶层画布，用于形成遮挡效果
		 * @return 
		 * 
		 */
		function get bitmapDataCover():BitmapData;
		
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