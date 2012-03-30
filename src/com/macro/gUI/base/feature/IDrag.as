package com.macro.gUI.base.feature
{
	import flash.display.BitmapData;


	/**
	 * 控件支持拖动
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IDrag
	{
		/**
		 * 拖动方式，参见DragMode枚举
		 * @return
		 *
		 */
		function get dragMode():int;

		/**
		 * DragMode为AVATAR时调用，获取拖动图像
		 * @return 返回null时，放弃拖动操作
		 *
		 */
		function getDragImage():BitmapData;

		/**
		 * DragMode为INTERNAL时调用，由控件内部自行实现拖放操作
		 * @param x 全局坐标
		 * @param y 全局坐标
		 *
		 */
		function setDragPos(x:int, y:int):void;

	}
}
