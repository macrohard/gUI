package com.macro.gUI.events
{
	/**
	 * 标签面板容器事件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class TabPanelEvent extends UIEvent
	{
		/**
		 * 当前标签变更
		 */
		public static const TAB_CHANGED:String = "tab.changed";
		
		
		public function TabPanelEvent(type:String)
		{
			super(type);
		}
	}
}