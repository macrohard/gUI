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
		 * 可视区域
		 */
		public var containerRect:Rectangle;
		
		/**
		 * 滚动目标
		 */
		public var scrollTarget:IControl;
		
		/**
		 * 边距，使用left, top, right, bottom定义
		 */
		public var padding:Rectangle;
		
		/**
		 * 滚动条控制的视口，由ScrollBar控件使用。
		 * @param containerRect 可视区域
		 * @param scrollTarget 滚动目标
		 * @param padding 边距，使用left, top, right, bottom定义
		 * 
		 */
		public function Viewport(containerRect:Rectangle, scrollTarget:IControl, padding:Rectangle = null)
		{
			this.containerRect = containerRect;
			this.scrollTarget = scrollTarget;
			this.padding = padding ? padding : new Rectangle();
		}
		
		/**
		 * 可卷动区域与目标的宽度比
		 * @return 
		 * 
		 */
		public function get ratioH():Number
		{
			return (containerRect.width - padding.left - padding.right) / scrollTarget.rect.width;
		}
		
		/**
		 * 可卷动区域与目标的高度比
		 * @return 
		 * 
		 */
		public function get ratioV():Number
		{
			return (containerRect.height - padding.top - padding.bottom) / scrollTarget.rect.height;
		}
		
		/**
		 * 水平卷动
		 * @param ratio
		 * 
		 */
		public function scrollH(ratio:Number):void
		{
			var x:int = containerRect.x + padding.left;
			var w:int = scrollTarget.rect.width - (containerRect.width - padding.left - padding.right);
			scrollTarget.rect.x = x - w * ratio;
		}
		
		/**
		 * 垂直卷动
		 * @param ratio
		 * 
		 */
		public function scrollV(ratio:Number):void
		{
			var y:int = containerRect.y + padding.top;
			var h:int = scrollTarget.rect.height - (containerRect.height - padding.top - padding.bottom);
			scrollTarget.rect.y = y - h * ratio;
		}
	}
}