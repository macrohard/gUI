package com.macro.gUI.assist
{


	/**
	 * 边距定义。对于控件，它定义了显示内容与四周的距离；对于容器，它定义了可视范围
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Margin
	{
		
		/**
		 * 左边距
		 */
		public var left:int;
		
		/**
		 * 上边距
		 */
		public var top:int;
		
		/**
		 * 右边距
		 */
		public var right:int;
		
		/**
		 * 下边距
		 */
		public var bottom:int;
		
		/**
		 * 边距定义
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 *
		 */
		public function Margin(left:int = 0, top:int = 0, right:int = 0, bottom:int = 0)
		{
			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
		}
	}
}
