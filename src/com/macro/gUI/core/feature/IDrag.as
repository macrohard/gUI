package com.macro.gUI.core.feature
{
	import com.macro.gUI.core.IControl;
	
	import flash.display.BitmapData;


	/**
	 * 控件支持拖拽
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IDrag extends IControl
	{
		/**
		 * 能否拖拽
		 * @param target 点击的目标控件，基本控件或复合控件的内部控件
		 * @return
		 *
		 */
		function getDraggable(target:IControl):Boolean;

		/**
		 * DragMode为DIRECT时调用，由控件内部自行实现拖拽操作
		 * @param target 点击的实际控件，基本控件或复合控件的内部控件
		 * @param x 全局坐标
		 * @param y 全局坐标
		 *
		 */
		function setDragCoord(target:IControl, x:int, y:int):void;

	}
}
