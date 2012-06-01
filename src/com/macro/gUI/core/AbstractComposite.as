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
		
		
		
		override public function get name():String
		{
			return _container.name;
		}
		
		override public function set name(value:String):void
		{
			_container.name = value;
		}
		

		override public function get backgroundColor():int
		{
			return _container.backgroundColor;
		}

		override public function set backgroundColor(value:int):void
		{
			_container.backgroundColor = value;
		}


		override public function get transparent():Boolean
		{
			return _container.transparent;
		}

		override public function set transparent(value:Boolean):void
		{
			_container.transparent = value;
		}


		override public function get bitmapData():BitmapData
		{
			return _container.bitmapData;
		}


		override public function get rect():Rectangle
		{
			return _container.rect;
		}


		override public function get enabled():Boolean
		{
			return _container.enabled;
		}

		override public function set enabled(value:Boolean):void
		{
			_container.enabled;
		}


		/**
		 * 横坐标
		 * @return
		 *
		 */
		override public function get x():int
		{
			return _container.x;
		}

		override public function set x(value:int):void
		{
			_x = _container.x = value;
		}


		/**
		 * 纵坐标
		 * @return
		 *
		 */
		override public function get y():int
		{
			return _container.y;
		}

		override public function set y(value:int):void
		{
			_y = _container.y = value;
		}


		/**
		 * 控件宽度，最小宽度是1
		 * @return
		 *
		 */
		override public function get width():int
		{
			return _container.width;
		}

		override public function set width(value:int):void
		{
			_width = _container.width = value;
			resize(value, _height);
		}


		/**
		 * 控件高度，最小高度是1
		 * @return
		 *
		 */
		override public function get height():int
		{
			return _container.height
		}

		override public function set height(value:int):void
		{
			_height = _container.height = value;
			resize(_width, value);
		}
		
		
		
		override public function get alpha():Number
		{
			return _container.alpha;
		}
		
		override public function set alpha(value:Number):void
		{
			_container.alpha = value;
		}
		
		
		override public function get pivotX():int
		{
			return _container.pivotX;
		}
		
		override public function set pivotX(value:int):void
		{
			_container.pivotX = value;
		}
		
		
		override public function get pivotY():int
		{
			return _container.pivotY;
		}
		
		override public function set pivotY(value:int):void
		{
			_container.pivotY = value;
		}
		
		
		override public function get rotation():Number
		{
			return _container.rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			_container.rotation = value;
		}
		
		
		override public function get scaleX():Number
		{
			return _container.scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			_container.scaleX = value;
		}
		
		
		override public function get scaleY():Number
		{
			return _container.scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			_container.scaleY = value;
		}
		
		
		override public function get visible():Boolean
		{
			return _container.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			_container.visible = value;
		}
		


		override public function get holder():IContainer
		{
			return _container.holder;
		}
		
		override public function get parent():IContainer
		{
			return _container.parent;
		}
		
		override public function get stage():IContainer
		{
			return _container.stage;
		}


		override internal function setHolder(container:IContainer):void
		{
			_container.setHolder(container);
		}
		
		override internal function setParent(container:IContainer):void
		{
			_container.setParent(container);
		}
		
		override internal function setStage(stage:IContainer):void
		{
			_container.setStage(stage);
		}


		override public function localToGlobal(point:Point = null):Point
		{
			return _container.localToGlobal(point);
		}
		
		override public function globalToLocal(point:Point):Point
		{
			return _container.globalToLocal(point);
		}


		override public function hitTest(x:int, y:int):IControl
		{
			return _container.hitTest(x, y);
		}


		override public function resize(width:int = 0, height:int = 0):void
		{
			width = width <= 0 ? _width : width;
			height = height <= 0 ? _height : height;
			
			_container.resize(width, height);
			_width = _container.width;
			_height = _container.height;
			layout();
		}

		override public function setDefaultSize():void
		{
			_container.setDefaultSize();
			_width = _container.width;
			_height = _container.height;
			layout();
		}



		/**
		 * 布局
		 *
		 */
		protected function layout():void
		{
		}
		
		
		/**
		 * 复合式容器控件应在添加了子控件后调用此方法设置子控件的Parent属性
		 * @param child
		 * 
		 */
		protected function setChildParent(child:AbstractControl):void
		{
			if (this is IContainer)
			{
				child.setParent(this as IContainer);
			}
			else
			{
				throw new Error("Only composite containers, can call this method");
			}
		}
	}
}
