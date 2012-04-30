package com.macro.gUI.core
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IControl extends IEventDispatcher
	{
		/**
		 * 画布
		 * @return
		 *
		 */
		function get bitmapData():BitmapData;

		/**
		 * 控件区域
		 * 返回的是一个Clone对象，因此直接对rect的修改并不会影响控件
		 * @return
		 *
		 */
		function get rect():Rectangle;
		
		/**
		 * 横坐标
		 * @return 
		 * 
		 */
		function get x():int;
		
		/**
		 * 纵坐标
		 * @return 
		 * 
		 */
		function get y():int;
		
		/**
		 * 宽度
		 * @return 
		 * 
		 */
		function get width():int;
		
		/**
		 * 高度
		 * @return 
		 * 
		 */
		function get height():int;

		/**
		 * 是否启用
		 * @return
		 *
		 */
		function get enabled():Boolean;

		/**
		 * 获取父容器
		 * @return
		 *
		 */
		function get parent():IContainer;
		
		/**
		 * 获取舞台容器。可根据此值是否为null来判定控件是否添加到舞台
		 * @return 
		 * 
		 */
		function get stage():IContainer;

		/**
		 * 控件的本地坐标转换为全局坐标
		 * @param point 基于控件本地坐标系的点
		 * @return
		 *
		 */
		function localToGlobal(point:Point = null):Point;

		/**
		 * 将全局坐标转换为控件的本地坐标
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		function globalToLocal(point:Point):Point;

		/**
		 * 测试坐标是否在控件范围内。如果返回的是null，则在控件范围外；
		 * 如果返回的是一个控件实例，则坐标在控件范围内。此时按以下原则处理：<ul>
		 * <li>如果测试控件是IContainer，且返回的控件不是CHILD_REGION，表示坐标是在控件范围内但不是子控件区域，交互管理器不用向下搜索</li>
		 * <li>如果测试控件是IContainer，且返回的控件是CHILD_REGION，交互管理器将下探搜索子控件的交互功能</li>
		 * <li>如果测试控件是IButton实现类时， 对测试控件执行对应鼠标方法。</li>
		 * <li>如果测试控件是IDrag实现类时，调用相应的getDragMode接口，执行拖拽操作</li></ul>
		 * @param x 全局坐标
		 * @param y 全局坐标
		 * @return 返回点击位置所在的控件。
		 *
		 */
		function hitTest(x:int, y:int):IControl;




		/**
		 * // TODO 透明度。有效值为 0（完全透明）到 1（完全不透明），默认值为 1。
		 * 通过渲染过程实现，控件实现类不要处理它
		 * @return
		 *
		 */
		function get alpha():Number;

		/**
		 * // TODO 控件是否可见。
		 * 通过渲染过程实现，控件实现类不要处理它
		 * @return
		 *
		 */
		function get visible():Boolean;

		/**
		 * // TODO 水平缩放比，1.0是100%。
		 * 通过渲染过程实现，控件实现类不要处理它
		 * @return
		 *
		 */
		function get scaleX():Number;

		/**
		 * // TODO 垂直缩放比，1.0是100%。
		 * 通过渲染过程实现，控件实现类不要处理它
		 * @return
		 *
		 */
		function get scaleY():Number;

		/**
		 * // TODO 注册点横坐标
		 * @return
		 *
		 */
		function get pivotX():Number;

		/**
		 * // TODO 注册点纵坐标
		 * @return
		 *
		 */
		function get pivotY():Number;

		/**
		 * // TODO 以注册点为原点旋转，弧度单位
		 * @param value
		 *
		 */
		function get rotation():Number;
	}
}
