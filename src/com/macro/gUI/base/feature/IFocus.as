package com.macro.gUI.base.feature
{
	import com.macro.gUI.base.IControl;

	/**
	 * 控件可以聚焦，凡是可以交互的控件均应能聚焦
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IFocus
	{
		
		/**
		 * 获取焦点的顺序，当用户按下Tab键时，自动聚焦到控件聚焦索引数组中下一个控件上
		 * @return 
		 * 
		 */
		function get tabIndex():int;
		
		/**
		 * 是否启用
		 * @return 
		 * 
		 */
		function get enabled():Boolean;
		
		/**
		 * 测试坐标是否在控件范围内
		 * @return 返回点击位置所在的控件，如果返回的是一个IButton，则坐标在控件范围内，且是热区；
		 * 如果返回的是非null，则坐标在控件范围内；如果返回的是null，则在控件范围外。
		 * 
		 */
		function hitTest(x:int, y:int):IControl;
	}
}