package com.macro.gUI.events
{
	/**
	 * 滑槽事件
	 * @author "Macro <macro776@gmail.com>"
	 * 
	 */
	public class SliderEvent extends UIEvent
	{
		/**
		 * 滑槽值变化
		 */
		public static const VALUE_CHANGED:String = "value.changed";
		
		
		public function SliderEvent(type:String)
		{
			super(type);
		}
	}
}