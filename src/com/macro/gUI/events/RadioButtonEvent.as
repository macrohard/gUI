package com.macro.gUI.events
{
	/**
	 * 单选框事件
	 * @author yangyi
	 * 
	 */
	public class RadioButtonEvent extends UIEvent
	{
		
		/**
		 * 用户选择
		 */
		public static const SELECT:String = "select";
		
		
		public function RadioButtonEvent(type:String)
		{
			super(type);
		}
	}
}