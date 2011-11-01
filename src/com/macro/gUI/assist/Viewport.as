package com.macro.gUI.assist
{
	import com.macro.gUI.base.IControl;
	
	import flash.geom.Rectangle;

	/**
	 * 滚动条控制的视口
	 * @author Macro776@gmail.com
	 * 
	 */
	public class Viewport
	{
		/**
		 * 可视范围
		 */
		public var containerRect:Rectangle;
		
		/**
		 * 滚动目标
		 */
		public var scrollTarget:IControl;
		
		/**
		 * 边距
		 */
		public var margin:Rectangle;
		
		/**
		 * 滚动条控制的视口，由ScrollBar控件使用。
		 * @param containerRect
		 * @param scrollTarget
		 * @param margin
		 * 
		 */
		public function Viewport(containerRect:Rectangle, scrollTarget:IControl, margin:Rectangle)
		{
			this.containerRect = containerRect;
			this.scrollTarget = scrollTarget;
			this.margin = margin;
		}
	}
}