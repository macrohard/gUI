package com.macro.gUI.events
{
	import flash.events.Event;
	
	/**
	 * UI界面事件基类，不支持事件冒泡
	 * @author "Macro <macro776@gmail.com>"
	 * 
	 */
	public class UIEvent extends Event
	{
		/**
		 * 重设尺寸
		 */
		public static const RESIZE:String = "resize";
		
		
		public function UIEvent(type:String)
		{
			super(type, false, false);
		}
	}
}