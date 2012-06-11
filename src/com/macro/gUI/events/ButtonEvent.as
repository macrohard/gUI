package com.macro.gUI.events
{
	/**
	 * 按钮事件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class ButtonEvent extends UIEvent
	{
		/**
		 * 鼠标悬停
		 */
		public static const MOUSE_OVER:String = "mouse.over";
		
		/**
		 * 鼠标按下
		 */
		public static const MOUSE_DOWN:String = "mouse.down";
		
		/**
		 * 鼠标松开
		 */
		public static const MOUSE_UP:String = "mouse.up";
		
		/**
		 * 鼠标移出
		 */
		public static const MOUSE_OUT:String = "mouse.out";
		
		/**
		 * 单击事件
		 */
		public static const CLICK:String = "click";
		
		/**
		 * 双击事件
		 */
		public static const DOUBLE_CLICK:String = "double.click";
		
		
		public function ButtonEvent(type:String)
		{
			super(type);
		}
	}
}