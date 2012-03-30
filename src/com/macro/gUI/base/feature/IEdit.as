package com.macro.gUI.base.feature
{
	import flash.text.TextField;


	/**
	 * 控件可编辑，主要是TextInput
	 * @author Macro <macro776@gmail.com>
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
