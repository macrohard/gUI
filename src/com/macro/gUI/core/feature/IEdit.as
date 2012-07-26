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
		
		function set editable(value:Boolean):void;
		
		/**
		 * 限制用户输入的字符集
		 * @return 
		 * 
		 */
		function get restrict():String;
		
		function set restrict(value:String):void;
		
		/**
		 * 开始编辑
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
