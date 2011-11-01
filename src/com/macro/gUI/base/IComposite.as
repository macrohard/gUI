package com.macro.gUI.base
{
	import flash.geom.Rectangle;

	/**
	 * 复合式控件
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IComposite extends IControl
	{
		/**
		 * 子控件
		 * @return 
		 * 
		 */
		function get children():Vector.<IControl>;
		
		/**
		 * 可视范围，它影响容器内的控件的可见性。
		 * 此属性定义的是与基类rect的间距。 如基类rect定义的是[0, 0, 100, 100]，containerRect定义是[5, 5, 5, 5]，
		 * 则实际容器矩形是[5, 5, 95, 95]。
		 * 通常情况下，此属性值基于皮肤九切片中心区域来定义
		 * @return 
		 * 
		 */
		function get containerRect():Rectangle;
	}
}