package com.macro.gUI.core
{
	import com.macro.gUI.containers.Container;
	
	/**
	 * 弹出窗口管理器，是一个特殊容器，它继承自Container。
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class PopupManager extends Container
	{
		/**
		 * 
		 * @param width
		 * @param height
		 * 
		 */
		public function PopupManager(width:int=100, height:int=100)
		{
			super(width, height);
		}
	}
}