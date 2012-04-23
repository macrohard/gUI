package com.macro.gUI.events
{
	/**
	 * 列表框事件
	 * @author "Macro <macro776@gmail.com>"
	 * 
	 */
	public class ListEvent extends UIEvent
	{
		/**
		 * 选择一个列表项
		 */
		public static const SELECT:String = "select";
		
		
		public function ListEvent(type:String)
		{
			super(type);
		}
	}
}