package com.macro.gUI.core.feature
{
	import com.macro.gUI.core.IControl;


	/**
	 * 控件可聚焦
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IFocus extends IControl
	{
		/**
		 * 获取焦点的顺序，当用户按下Tab键时，自动聚焦到索引数组中下一个控件上。
		 * 如果返回值是一个负数，则表示该控件不接受聚焦
		 * @return
		 *
		 */
		function get tabIndex():int;
	}
}
