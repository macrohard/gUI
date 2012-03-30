package com.macro.gUI.assist
{


	/**
	 * 拖动模式
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class DragMode
	{
		/**
		 * 不支持拖放
		 */
		public static const NONE:int = 0

		/**
		 * 内部实现，将调用控件的setDragPos接口
		 */
		public static const INTERNAL:int = 1;

		/**
		 * 拖动替代图像，替代图像显示在最上层。调用控件的getDragImage接口来获取替代图像
		 */
		public static const AVATAR:int = 2;

		/**
		 * 实时拖动，直接设置控件的x, y
		 */
		public static const DIRECT:int = 3;
	}
}
