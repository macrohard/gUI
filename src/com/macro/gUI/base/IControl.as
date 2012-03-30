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
		 * Alpha的控制将通过渲染过程实现，控件实现类无须关心
		 * @return
		 *
		 */
		function get alpha():Number;

		/**
		 * 控件是否可见
		 * 可见性的控制将通过渲染过程实现，控件实现类无须关心
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
		 * 测试坐标是否在控件范围内。如果返回的是null，则在控件范围外（交互管理器将继续搜索）；
		 * 如果返回的是一个控件实例，则坐标在控件范围内，如果测试控件本身是IButton实现类时， 还将执行控件的对应鼠标方法。
		 * @param x 全局坐标
		 * @param y 全局坐标
		 * @return 返回点击位置所在的控件。
		 *
		 */
		function hitTest(x:int, y:int):IControl;

	}
}
