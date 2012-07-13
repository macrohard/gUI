package com.macro.gUI.events
{
	/**
	 * 组合框事件
	 * @author yangyi
	 * 
	 */
	public class ComboBoxEvent extends UIEvent
	{
		
		/**
		 * 用户选择
		 */
		public static const SELECT:String = "select";
		
		
		public function ComboBoxEvent(type:String)
		{
			super(type);
		}
	}
}