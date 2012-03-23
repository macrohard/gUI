package com.macro.gUI.base
{
	import flash.geom.Rectangle;

	/**
	 * 复合式控件，由一系列基础控件及容器控件组合而成
	 * @author Macro776@gmail.com
	 * 
	 */
	public interface IComposite extends IControl
	{
		
		/**
		 * 复合控件的根容器
		 * @return 
		 * 
		 */
		function get container():IContainer;
	}
}