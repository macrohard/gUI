package com.macro.gUI.core.feature
{
	import com.macro.gUI.core.IControl;
	
	/**
	 * 控件可切换选中与未选中状态
	 * @author yangyi
	 * 
	 */
	public interface ISelect extends IControl
	{
		function get selected():Boolean;
		
		function set selected(value:Boolean):void;
	}
}