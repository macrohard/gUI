package com.macro.gUI.base
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 抽象复合式控件
	 * @author Macro776@gmail.com
	 *
	 */
	public class AbstractComposite extends EventDispatcher implements IComposite
	{

		/**
		 * 抽象复合式控件，由一系列基础控件及容器控件组合而成，不允许直接实例化
		 * @param width
		 * @param height
		 * @param align 布局对齐方式，默认值为左上角对齐
		 *
		 */
		public function AbstractComposite(width:int, height:int, align:int = 0x11)
		{
			super(width, height);

			if (getQualifiedClassName(this) == "com.macro.gUI.base::AbstractComposite")
			{
				throw new Error("Abstract class can not be constructed!");
			}

			_align = align;
		}


		protected var _align:int;
		/**
		 * 布局对齐方式
		 * @return
		 *
		 */
		public function get align():int
		{
			return _align;
		}

		public function set align(value:int):void
		{
			_align = value;
			layout();
		}
		
		
		protected var _container:IContainer;
		
		public function get container():IContainer
		{
			return _container;
		}
		
		
		public function get bitmapData():BitmapData
		{
			return null;
		}
		
		
		public function get rect():Rectangle
		{
			return _container.rect;
		}
		
		
		/**
		 * 横坐标
		 * @return
		 *
		 */
		public function get x():int
		{
			return _container.rect.x;
		}
		
		public function set x(value:int):void
		{
			_container.rect.x = value;
		}
		
		
		/**
		 * 纵坐标
		 * @return
		 *
		 */
		public function get y():int
		{
			return _container.rect.y;
		}
		
		public function set y(value:int):void
		{
			_container.rect.y = value;
		}
		
		
		/**
		 * 控件宽度，最小宽度是1
		 * @return
		 *
		 */
		public function get width():int
		{
			return _container.rect.width;
		}
		
		public function set width(value:int):void
		{
			if (_container.rect.width != value && value > 0)
			{
				resize(value, _container.rect.height);
			}
		}
		
		
		/**
		 * 控件高度，最小高度是1
		 * @return
		 *
		 */
		public function get height():int
		{
			return _container.rect.height;
		}
		
		public function set height(value:int):void
		{
			if (_container.rect.height != value && value > 0)
			{
				resize(_container.rect.width, value);
			}
		}
		
		
		/**
		 * 透明度，由UI体系使用。有效值为 0（完全透明）到 1（完全不透明）。默认值为 1。
		 * @return
		 *
		 */
		public function get alpha():Number
		{
			return _container.alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_container.alpha = value;
		}
		
		
		/**
		 * 可见性，由UI体系使用
		 * @return
		 *
		 */
		public function get visible():Boolean
		{
			return _container.visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_container.visible = value;
		}
		
		
		public function get parent():IContainer
		{
			return _container.parent;
		}
		
		
		/**
		 * 设置父容器，内部行为，外部无法访问
		 * @param container
		 *
		 */
		internal function setParent(container:IContainer):void
		{
			if (_container is AbstractControl)
			{
				(_container as AbstractControl).setParent(container);
			}
			else
			{
				throw new Error("Unknow Container Type!");
			}
		}
		
		
		/**
		 * 覆盖父类添加侦听器的方法，修改弱引用参数默认值为true，因为使用类成员作为侦听器的使用环境更为常见
		 *
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
												  priority:int = 0, useWeakReference:Boolean = true):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
		public function localToGlobal():Point
		{
			return _container.localToGlobal();
		}
		
		
		public function resize(width:int = 0, height:int = 0):void
		{
			_container.resize(width, height);
			layout();
		}


		/**
		 * 布局
		 *
		 */
		protected function layout():void
		{
		}
	}
}
