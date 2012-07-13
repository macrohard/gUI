package com.macro.gUI.events
{
	/**
	 * 滚动条事件
	 * @author yangyi
	 * 
	 */
	public class ScrollBarEvent extends UIEvent
	{
		
		/**
		 * 值变化
		 */
		public static const VALUE_CHANGED:String = "value.changed";
		
		/**
		 * 控件目标发生滚动时
		 */
		public static const SCROLL:String = "scroll";
		
		
		public function ScrollBarEvent(type:String)
		{
			super(type);
		}
	}
}