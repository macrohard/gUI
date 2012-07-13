package com.macro.gUI.events
{
	/**
	 * 列表框事件
	 * @author yangyi
	 * 
	 */
	public class ListEvent extends UIEvent
	{
		
		/**
		 * 用户选择
		 */
		public static const SELECT:String = "select";
		
		
		public function ListEvent(type:String)
		{
			super(type);
		}
	}
}