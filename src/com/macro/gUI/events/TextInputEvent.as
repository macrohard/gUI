package com.macro.gUI.events
{
	/**
	 * 编辑文本框事件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class TextInputEvent extends UIEvent
	{
		/**
		 * 开始编辑
		 */
		public static const EDIT_BEGIN:String = "edit.begin";
		
		/**
		 * 结束编辑
		 */
		public static const EDIT_FINISH:String = "edit.finish";
		
		
		public function TextInputEvent(type:String)
		{
			super(type);
		}
	}
}