package com.macro.gUI.assist
{
	import com.macro.gUI.base.AbstractControl;
	
	import flash.geom.Rectangle;


	/**
	 * 滚动条控制的视口
	 * @author Macro <macro776@gmail.com>
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
		public var scrollTarget:AbstractControl;

		/**
		 * 边距
		 */
		public var padding:Margin;

		/**
		 * 滚动条控制的视口，由ScrollBar控件使用。
		 * 当滚动目标的高宽大于可视区域时，滚动条才会起作用
		 * @param containerRect 可视区域
		 * @param scrollTarget 滚动目标
		 * @param padding 边距
		 *
		 */
		public function Viewport(containerRect:Rectangle, scrollTarget:AbstractControl, padding:Margin = null)
		{
			this.containerRect = containerRect;
			this.scrollTarget = scrollTarget;
			this.padding = padding ? padding : new Margin();
		}

		/**
		 * 可卷动区域与目标的宽度比
		 * @return
		 *
		 */
		public function get ratioH():Number
		{
			return (containerRect.width - padding.left - padding.right) / scrollTarget.width;
		}

		/**
		 * 可卷动区域与目标的高度比
		 * @return
		 *
		 */
		public function get ratioV():Number
		{
			return (containerRect.height - padding.top - padding.bottom) / scrollTarget.height;
		}

		/**
		 * 水平卷动
		 * @param ratio
		 *
		 */
		public function scrollH(ratio:Number):void
		{
			var x:int = containerRect.x + padding.left;
			var w:int = scrollTarget.width - (containerRect.width - padding.left - padding.right);
			scrollTarget.x = x - w * ratio;
		}

		/**
		 * 垂直卷动
		 * @param ratio
		 *
		 */
		public function scrollV(ratio:Number):void
		{
			var y:int = containerRect.y + padding.top;
			var h:int = scrollTarget.height - (containerRect.height - padding.top - padding.bottom);
			scrollTarget.y = y - h * ratio;
		}
	}
}
