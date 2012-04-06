package com.macro.gUI.base
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IControl
	{
		/**
		 * 画布
		 * @return
		 *
		 */
		function get bitmapData():BitmapData;

		/**
		 * 控件坐标及大小
		 * @return
		 *
		 */
		function get rect():Rectangle;

		/**
		 * 是否启用
		 * @return
		 *
		 */
		function get enabled():Boolean;

		/**
		 * 透明度。有效值为 0（完全透明）到 1（完全不透明），默认值为 1。
		 * Alpha的控制将通过渲染过程实现，控件实现类不要处理它
		 * @return
		 *
		 */
		function get alpha():Number;

		/**
		 * 控件是否可见
		 * 可见性的控制将通过渲染过程实现，控件实现类不要处理它
		 * @return
		 *
		 */
		function get visible():Boolean;

		/**
		 * 获取父级容器
		 * @return
		 *
		 */
		function get parent():IContainer;

		/**
		 * 获取控件的全局坐标
		 * @return
		 *
		 */
		function globalCoord():Point;

		/**
		 * 测试坐标是否在控件范围内。如果返回的是null，则在控件范围外；
		 * 如果返回的是一个控件实例，则坐标在控件范围内。此时按以下原则处理：<ul>
		 * <li>如果测试控件是IContainer，且返回的控件是NULL，表示坐标是在控件范围内但不是交互区域，交互管理器不用继续处理</li>
		 * <li>如果测试控件是IContainer，且返回的控件不是NULL，交互管理器将下探搜索子控件的交互功能</li>
		 * <li>如果测试控件是IButton实现类时， 对测试控件执行对应鼠标方法。</li>
		 * <li>如果测试控件是IDrag实现类时，调用相应的getDragMode接口，执行拖拽操作</li></ul>
		 * @param x 全局坐标
		 * @param y 全局坐标
		 * @return 返回点击位置所在的控件。
		 *
		 */
		function hitTest(x:int, y:int):IControl;

	}
}
