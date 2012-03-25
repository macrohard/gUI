package com.macro.gUI.base
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 抽象复合式控件
	 * @author Macro776@gmail.com
	 *
	 */
	public class AbstractComposite extends AbstractControl implements IComposite
	{

		/**
		 * 抽象复合式控件，不允许直接实例化。复合式控件由一系列基础控件及容器控件组合而成，
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
		
		
		protected var _container:AbstractControl;
		
		public function get container():IContainer
		{
			if (_container is IContainer)
			{
				return _container as IContainer;
			}
			throw new Error("Unsupport Container Type!");
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
		
		
		public override function get rect():Rectangle
		{
			return _container.rect;
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
			_container.x = value;
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
			_container.y = value;
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
			_container.width = value;
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
			_container.height = value;
			layout();
		}
		
		
		/**
		 * 透明度，由UI体系使用。有效值为 0（完全透明）到 1（完全不透明）。默认值为 1。
		 * @return
		 *
		 */
		public override function get alpha():Number
		{
			return _container.alpha;
		}
		
		public override function set alpha(value:Number):void
		{
			_container.alpha = value;
		}
		
		
		/**
		 * 可见性，由UI体系使用
		 * @return
		 *
		 */
		public override function get visible():Boolean
		{
			return _container.visible;
		}
		
		public override function set visible(value:Boolean):void
		{
			_container.visible = value;
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
		
		
		public override function localToGlobal():Point
		{
			return _container.localToGlobal();
		}
		
		
		public override function resize(width:int = 0, height:int = 0):void
		{
			_container.resize(width, height);
			layout();
		}

		public override function setDefaultSize():void
		{
			_container.setDefaultSize();
			layout();
		}
		
		protected final override function paint(rebuild:Boolean=false):void
		{
		}
		
		protected final override function prePaint():void
		{
		}
		
		protected final override function postPaint():void
		{
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
