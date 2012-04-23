package com.macro.gUI.events
{
	/**
	 * 滚动条事件
	 * @author "Macro <macro776@gmail.com>"
	 * 
	 */
	public class ScrollEvent extends UIEvent
	{
		/**
		 * 控件目标发生滚动时
		 */
		public static const SCROLL:String = "scroll";
		
		
		public function ScrollEvent(type:String)
		{
			super(type);
		}
	}
}