package com.macro.gUI.skin
{


	/**
	 * 动画皮肤类型接口。<br/>
	 * 由于皮肤需要实现九切，因此，动画类型的皮肤就需要不断重绘，
	 * 开销较大，需要仔细斟酌使用。<br/>
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IAnimationSkin extends ISkin
	{
		/**
		 * 添加重绘侦听<br/>
		 * 实现此接口要注意，需要使用弱引用方式来注册侦听器，以免控件无法正确销毁
		 * @param paint 控件的绘制方法
		 *
		 */
		function addRepaintListener(paint:Function):void;
	}
}
