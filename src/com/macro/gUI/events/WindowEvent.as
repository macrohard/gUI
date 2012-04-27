package com.macro.gUI.events
{
	/**
	 * 窗口容器事件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class WindowEvent extends UIEvent
	{
		/**
		 * 最小化按钮被点击
		 */
		public static const MIN_BUTTON_CLICK:String = "minimize.button.click";
		
		/**
		 * 最大化按钮被点击
		 */
		public static const MAX_BUTTON_CLICK:String = "maximize.button.click";
		
		/**
		 * 关闭按钮被点击
		 */
		public static const CLOSE_BUTTON_CLICK:String = "close.button.click";
		
		
		public function WindowEvent(type:String)
		{
			super(type);
		}
	}
}