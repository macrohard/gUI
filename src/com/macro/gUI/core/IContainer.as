package com.macro.gUI.core
{
	import com.macro.gUI.assist.Margin;


	/**
	 * 容器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IContainer extends IControl
	{

		/**
		 * 可视范围边距，它影响子控件的可见性。<br>
		 * 如：容器尺寸定义是(100, 100)，margin定义是[5, 5, 5, 5]，
		 * 则容器可视范围矩形是[5, 5, 95, 95]，注意，margin中四个数值是left, top, right, bottom
		 * @return
		 *
		 */
		function get margin():Margin;
		
		function set margin(value:Margin):void;

		/**
		 * 子控件
		 * @return
		 *
		 */
		function get children():Vector.<IControl>;

		/**
		 * 获取子控件数量
		 * @return
		 *
		 */
		function get numChildren():int;

		/**
		 * 添加子控件
		 * @param child
		 *
		 */
		function addChild(child:IControl):void;

		/**
		 * 在给定深度添加子控件
		 * @param child
		 * @param index
		 *
		 */
		function addChildAt(child:IControl, index:int):void;

		/**
		 * 移除子控件
		 * @param child
		 *
		 */
		function removeChild(child:IControl):void;

		/**
		 * 移除指定深度的控件，并将其返回
		 * @param index
		 * @return
		 *
		 */
		function removeChildAt(index:int):IControl;

		/**
		 * 移除指定范围的所有子控件
		 * @param beginIndex 首个子控件的深度
		 * @param endIndex 最后一个子控件的深度
		 *
		 */
		function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void;

		/**
		 * 获取指定深度的控件
		 * @param index
		 * @return
		 *
		 */
		function getChildAt(index:int):IControl;

		/**
		 * 获取指定控件的深度
		 * @param child
		 * @return
		 *
		 */
		function getChildIndex(child:IControl):int;

		/**
		 * 更改现有子控件的深度
		 * @param child
		 * @param index
		 *
		 */
		function setChildIndex(child:IControl, index:int):void;

		/**
		 * 交换两个子控件的深度
		 * @param child1
		 * @param child2
		 *
		 */
		function swapChildren(child1:IControl, child2:IControl):void;

		/**
		 * 交换指定深度的两个子控件
		 * @param index1
		 * @param index2
		 *
		 */
		function swapChildrenAt(index1:int, index2:int):void;
	}
}
