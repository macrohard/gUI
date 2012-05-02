package com.macro.gUI.skin
{


	/**
	 * 动画皮肤类型接口。<br/>
	 * 由于皮肤需要实现九切，因此，动画类型的皮肤就需要不断重绘，使用须谨慎。<br/>
	 * // TODO AbstractControl中实现对_skin赋值时的处理，添加侦听及移除侦听
	 * // TODO 在设置stage时，如果在舞台上，则开始播放动画，否则应停止
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
		
		function removeRepaintListener(paint:Function):void;
		
		function start():void;
		
		function stop():void;
	}
}
