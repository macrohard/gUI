package com.macro.gUI.assist
{
	/**
	 * 拖动模式
	 * @author Macro776@gmail.com
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
		 * 实时拖动，直接设置控件的x, y。注意，不能改变控件的层级
		 */
		public static const REALTIME:int = 2;
		
		/**
		 * 拖动替代图像，替代图像显示在最上层。调用控件的getDragImage接口来获取替代图像
		 */
		public static const COPY:int = 3;
	}
}