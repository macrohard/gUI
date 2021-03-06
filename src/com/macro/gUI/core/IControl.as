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
		 * 名称
		 * @return 
		 * 
		 */
		function get name():String;
		
		function set name(value:String):void;
		
		/**
		 * 画布
		 * @return
		 *
		 */
		function get bitmapData():BitmapData;

		/**
		 * 控件区域信息，x、y代表控件的坐标，width、height代表控件的宽高。
		 * 注意，只处理了注册点的平移，未处理缩放、旋转等形变。
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
		
		function set x(value:int):void;
		
		/**
		 * 纵坐标
		 * @return 
		 * 
		 */
		function get y():int;
		
		function set y(value:int):void;
		
		/**
		 * 宽度
		 * @return 
		 * 
		 */
		function get width():int;
		
		function set width(value:int):void;
		
		/**
		 * 高度
		 * @return 
		 * 
		 */
		function get height():int;
		
		function set height(value:int):void;

		/**
		 * 是否启用
		 * @return
		 *
		 */
		function get enabled():Boolean;
		
		function set enabled(value:Boolean):void;
		
		/**
		 * 是否交互
		 * @return 
		 * 
		 */
		function get mouseEnabled():Boolean;
		
		function set mouseEnabled(value:Boolean):void;
		
		/**
		 * 是否启用双击
		 * @return 
		 * 
		 */
		function get doubleClickEnabled():Boolean;
		
		function set doubleClickEnabled(value:Boolean):void;
		

		/**
		 * 直系父级容器，与Parent不同的是，它包含了真实的层级对象，复合控件被解析为内部封装对象
		 * @return 
		 * 
		 */
		function get holder():IContainer;
		
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
		 * 设置尺寸
		 * @param width 宽度值，如果为0，则取原值
		 * @param height 高度值，如果为0，则取原值
		 * 
		 */
		function resize(width:int = 0, height:int = 0):void;
		
		
		
		/**
		 * 注册点横坐标
		 * @return
		 *
		 */
		function get pivotX():int;
		
		function set pivotX(value:int):void;
		
		/**
		 * 注册点纵坐标
		 * @return
		 *
		 */
		function get pivotY():int;
		
		function set pivotY(value:int):void;

		/**
		 * 透明度。有效值为 0（完全透明）到 1（完全不透明），默认值为 1。
		 * @return
		 *
		 */
		function get alpha():Number;
		
		function set alpha(value:Number):void;

		/**
		 * 可见性。
		 * @return
		 *
		 */
		function get visible():Boolean;
		
		function set visible(value:Boolean):void;

		/**
		 * // TODO 水平缩放比，1.0是100%。
		 * @return
		 *
		 */
		function get scaleX():Number;
		
		function set scaleX(value:Number):void;

		/**
		 * // TODO 垂直缩放比，1.0是100%。
		 * @return
		 *
		 */
		function get scaleY():Number;
		
		function set scaleY(value:Number):void;

		/**
		 * // TODO 以注册点为原点旋转，弧度单位
		 * @return 
		 * 
		 */
		function get rotation():Number;
		
		function set rotation(value:Number):void;
	}
}
