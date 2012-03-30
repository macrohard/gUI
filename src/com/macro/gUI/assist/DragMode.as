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
		 * 内部实现，将调用控件的setDragCoord接口
		 */
		public static const DIRECT:int = 1;

		/**
		 * 拖动替身图像，替身图像显示在最上层。调用控件的getDragImage接口来获取替身图像
		 */
		public static const AVATAR:int = 2;

	}
}
