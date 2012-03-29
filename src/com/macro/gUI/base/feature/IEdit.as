package com.macro.gUI.base.feature
{
	import flash.text.TextField;

	/**
	 * 可编辑控件，主要是TextInput
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IEdit
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
		 * 
		 */
		function endEdit():void;
	}
}