package com.macro.gUI
{
	import com.macro.gUI.base.IControl;

	/**
	 * 焦点管理器。
	 * 当按下Tab键切换焦点时，只在当前控件父容器一层搜索，不下探
	 * @author Macro776@gmail.com
	 * 
	 */
	public class FocusManager
	{
		
		private var _focusControl:IControl;
		
		public function FocusManager()
		{
		}

		public function get focusControl():IControl
		{
			return _focusControl;
		}

		public function set focusControl(value:IControl):void
		{
			_focusControl = value;
		}

	}
}