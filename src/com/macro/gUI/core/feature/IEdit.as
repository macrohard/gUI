package com.macro.gUI.core.feature
{
	import flash.text.TextField;


	/**
	 * 控件可编辑，主要是TextInput
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IEdit extends IFocus
	{

		/**
		 * 是否可编辑
		 * @return
		 *
		 */
		function get editable():Boolean;
		
		/**
		 * 开始编辑
		 * @return
		 *
		 */
		function beginEdit():TextField;
		
		/**
		 * 结束编辑
		 * @param text
		 * 
		 */
		function endEdit(text:String):void;

	}
}
