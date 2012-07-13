package com.macro.gUI.events
{
	/**
	 * 复选框事件
	 * @author yangyi
	 * 
	 */
	public class CheckBoxEvent extends UIEvent
	{
		
		/**
		 * 用户选择
		 */
		public static const SELECT:String = "select";
		
		
		public function CheckBoxEvent(type:String)
		{
			super(type);
		}
	}
}