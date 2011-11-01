package com.macro.gUI.base.feature
{
	import flash.display.BitmapData;

	/**
	 * 控件可以拖动
	 * @author macro776@gmail.com
	 * 
	 */
	public interface IDrag extends IFocus
	{
		/**
		 * 拖动方式，参见DragMode枚举
		 * @return 
		 * 
		 */
		function get dragMode():int;
		
		/**
		 * DragMode为COPY时调用，获取拖动图像
		 * @return 返回null时，放弃拖动操作
		 * 
		 */
		function getDragImage():BitmapData;
		
		/**
		 * DragMode为INTERNAL时调用，由控件内部自行实现拖放操作
		 * @param x 相对于控件的横坐标
		 * @param y 相对于控件的纵坐标
		 * 
		 */
		function setDragPos(x:int, y:int):void;
		
	}
}