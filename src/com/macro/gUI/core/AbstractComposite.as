package com.macro.gUI.core
{
	import avmplus.getQualifiedClassName;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 抽象复合式控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class AbstractComposite extends AbstractControl implements IComposite
	{

		/**
		 * 抽象复合式控件，不允许直接实例化。复合式控件内部封装一个IContainer容器，由一系列基础控件及容器控件组合而成
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


		protected var _container:AbstractContainer;

		public function get container():IContainer
		{
			return _container;
		}



		public override function get backgroundColor():int
		{
			return _container.backgroundColor;
		}

		public override function set backgroundColor(value:int):void
		{
			_container.backgroundColor = value;
		}


		public override function get transparent():Boolean
		{
			return _container.transparent;
		}

		public override function set transparent(value:Boolean):void
		{
			_container.transparent = value;
		}


		/**
		 * 复合控件无位图数据对象，此属性总是返回null
		 * @return
		 *
		 */
		public final override function get bitmapData():BitmapData
		{
			return null;
		}


		public override function get rect():Rectangle
		{
			return _container.rect;
		}


		public override function get enabled():Boolean
		{
			return _container.enabled;
		}

		public override function set enabled(value:Boolean):void
		{
			_container.enabled;
		}


		/**
		 * 横坐标
		 * @return
		 *
		 */
		public override function get x():int
		{
			return _container.x;
		}

		public override function set x(value:int):void
		{
			_rect.x = _container.x = value;
		}


		/**
		 * 纵坐标
		 * @return
		 *
		 */
		public override function get y():int
		{
			return _container.y;
		}

		public override function set y(value:int):void
		{
			_rect.y = _container.y = value;
		}


		/**
		 * 控件宽度，最小宽度是1
		 * @return
		 *
		 */
		public override function get width():int
		{
			return _container.width;
		}

		public override function set width(value:int):void
		{
			_rect.width = _container.width = value;
			layout();
		}


		/**
		 * 控件高度，最小高度是1
		 * @return
		 *
		 */
		public override function get height():int
		{
			return _container.height
		}

		public override function set height(value:int):void
		{
			_rect.height = _container.height = value;
			layout();
		}



		public override function get parent():IContainer
		{
			return _container.parent;
		}


		/**
		 * 设置父容器，内部行为，外部无法访问
		 * @param container
		 *
		 */
		internal override function setParent(container:IContainer):void
		{
			_container.setParent(container);
		}


		public override function localToGlobal(point:Point = null):Point
		{
			return _container.localToGlobal(point);
		}


		public override function hitTest(x:int, y:int):IControl
		{
			return _container.hitTest(x, y);
		}


		public override function resize(width:int = 0, height:int = 0):void
		{
			_container.resize(width, height);
			_rect = _container.rect;
			layout();
		}

		public override function setDefaultSize():void
		{
			_container.setDefaultSize();
			_rect = _container.rect;
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
