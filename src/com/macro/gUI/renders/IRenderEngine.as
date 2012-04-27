package com.macro.gUI.renders
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;


	/**
	 * UI渲染接口
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IRenderEngine
	{

		/**
		 * 更新控件坐标
		 * @param control
		 * @param x
		 * @param y
		 *
		 */
		function updateCoord(control:IControl, x:int, y:int):void;

		/**
		 * 更新控件绘制
		 * @param control
		 * @param isRebuild 是否重建了位图对象，一般是因为控件尺寸的变更
		 *
		 */
		function updatePaint(control:IControl, isRebuild:Boolean):void;

		/**
		 * 更新容器子级
		 * @param container 容器
		 * 
		 */
		function updateChildren(container:IContainer):void;
	}
}
