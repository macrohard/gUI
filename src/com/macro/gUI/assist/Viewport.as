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
		public function Viewport(containerRect:Rectangle, scrollTarget:IControl, margin:Rectangle = null)
		{
			this.containerRect = containerRect;
			this.scrollTarget = scrollTarget;
			this.margin = margin ? margin : new Rectangle();
		}
		
		/**
		 * 可卷动区域与目标的宽度比
		 * @return 
		 * 
		 */
		public function get ratioH():Number
		{
			return (containerRect.width - margin.left - margin.right) / scrollTarget.rect.width;
		}
		
		/**
		 * 可卷动区域与目标的高度比
		 * @return 
		 * 
		 */
		public function get ratioV():Number
		{
			return (containerRect.height - margin.top - margin.bottom) / scrollTarget.rect.height;
		}
		
		/**
		 * 水平卷动
		 * @param ratio
		 * 
		 */
		public function scrollH(ratio:Number):void
		{
			var x:int = containerRect.x + margin.left;
			var w:int = scrollTarget.rect.width - (containerRect.width - margin.left - margin.right);
			scrollTarget.rect.x = x - w * ratio;
		}
		
		/**
		 * 垂直卷动
		 * @param ratio
		 * 
		 */
		public function scrollV(ratio:Number):void
		{
			var y:int = containerRect.y + margin.top;
			var h:int = scrollTarget.rect.height - (containerRect.height - margin.top - margin.bottom);
			scrollTarget.rect.y = y - h * ratio;
		}
	}
}