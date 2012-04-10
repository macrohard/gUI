package com.macro.gUI.base
{

	import avmplus.getQualifiedClassName;
	
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.managers.PopupManager;
	import com.macro.gUI.managers.SkinManager;
	import com.macro.gUI.managers.UIManager;
	import com.macro.gUI.skin.ISkin;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	/**
	 * 抽象基础控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class AbstractControl extends EventDispatcher implements IControl
	{

		/**
		 * 平滑绘制
		 */
		public static var smoothing:Boolean = true;
		
		
		/**
		 * 皮肤。<br/><br/>
		 * 未直接曝露，支持此属性的子类自行提供访问器
		 */
		protected var _skin:ISkin;

		/**
		 * 皮肤绘制范围
		 */
		protected var _skinDrawRect:Rectangle;




		/**
		 * 抽象控件，不允许直接实例化
		 * @param width 控件宽度
		 * @param height 控件高度
		 *
		 */
		public function AbstractControl(width:int, height:int)
		{
			if (getQualifiedClassName(this) == "com.macro.gUI.base::AbstractControl")
			{
				throw new Error("Abstract class can not be constructed!");
			}
			
			
			//默认透明度
			_alpha = 1;

			//默认无色，0x00000000
			_bgColor = 0;

			//默认透明
			_transparent = true;

			//默认控件可用
			_enabled = true;

			//默认尺寸
			_rect = new Rectangle(0, 0, width, height);
		}
		
		
		
		protected function get uiManager():UIManager
		{
			return GameUI.uiManager;
		}
		
		protected function get skinManager():SkinManager
		{
			return GameUI.skinManager;
		}
		


		private var _bgColor:int;

		/**
		 * 背景色，ARGB格式
		 */
		public function get backgroundColor():int
		{
			return _bgColor;
		}

		public function set backgroundColor(value:int):void
		{
			if (_bgColor != value)
			{
				_bgColor = value;
				paint();
			}
		}


		private var _transparent:Boolean;

		/**
		 * 是否背景透明
		 */
		public function get transparent():Boolean
		{
			return _transparent;
		}

		public function set transparent(value:Boolean):void
		{
			if (_transparent != value)
			{
				_transparent = value;
				paint(true);
			}
		}


		protected var _bitmapData:BitmapData;

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}


		protected var _rect:Rectangle;

		public function get rect():Rectangle
		{
			return _rect.clone();
		}


		protected var _enabled:Boolean;

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}


		/**
		 * 横坐标
		 * @return
		 *
		 */
		public function get x():int
		{
			return _rect.x;
		}

		public function set x(value:int):void
		{
			_rect.x = value;
		}


		/**
		 * 纵坐标
		 * @return
		 *
		 */
		public function get y():int
		{
			return _rect.y;
		}

		public function set y(value:int):void
		{
			_rect.y = value;
		}


		/**
		 * 控件宽度，最小宽度是1
		 * @return
		 *
		 */
		public function get width():int
		{
			return _rect.width;
		}

		public function set width(value:int):void
		{
			if (_rect.width != value && value > 0)
			{
				resize(value, _rect.height);
			}
		}


		/**
		 * 控件高度，最小高度是1
		 * @return
		 *
		 */
		public function get height():int
		{
			return _rect.height;
		}

		public function set height(value:int):void
		{
			if (_rect.height != value && value > 0)
			{
				resize(_rect.width, value);
			}
		}


		private var _alpha:Number;

		public final function get alpha():Number
		{
			return _alpha;
		}

		public final function set alpha(value:Number):void
		{
			_alpha = value < 0 ? 0 : (value > 1 ? 1 : value);
		}


		private var _visible:Boolean;

		public final function get visible():Boolean
		{
			return _visible;
		}

		public final function set visible(value:Boolean):void
		{
			_visible = value;
		}



		private var _parent:IContainer;

		public function get parent():IContainer
		{
			return _parent;
		}


		/**
		 * 设置父容器，内部行为，外部无法访问
		 * @param container
		 *
		 */
		internal function setParent(container:IContainer):void
		{
			_parent = container;
		}


		public function globalCoord():Point
		{
			var p:Point = _rect.topLeft;
			var container:IContainer = this.parent;
			while (container != null)
			{
				p.offset(container.rect.x + container.margin.left, container.rect.y + container.margin.top);
				container = container.parent;
			}
			return p;
		}


		/**
		 * 将全局坐标转换为本地坐标
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function globalToLocal(x:int, y:int):Point
		{
			var p:Point = globalCoord();
			p.x = x - p.x;
			p.y = y - p.y;
			return p;
		}


		public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(x, y);

			if (p.x >= 0 && p.x <= _rect.width && p.y >= 0 && p.y <= _rect.height)
			{
				return this;
			}

			return null;
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



		/**
		 * 重设尺寸
		 * @param width
		 * @param height
		 *
		 */
		public function resize(width:int = 0, height:int = 0):void
		{
			if (width == 0)
			{
				width = _rect.width;
			}

			if (height == 0)
			{
				height = _rect.height;
			}

			if (_skin != null)
			{
				if (width < _skin.minWidth)
				{
					width = _skin.minWidth;
				}

				if (height < _skin.minHeight)
				{
					height = _skin.minHeight;
				}
			}

			if (_rect.width != width || _rect.height != height)
			{
				_rect.width = width;
				_rect.height = height;
				paint(true);
			}
			else
			{
				paint();
			}
		}

		/**
		 * 设置为皮肤的默认尺寸
		 *
		 */
		public function setDefaultSize():void
		{
			if (_skin != null)
			{
				resize(_skin.bitmapData.width, _skin.bitmapData.height);
			}
		}


		/**
		 * 将当前皮肤绘制到画布上
		 *
		 */
		protected function paint(rebuild:Boolean = false):void
		{
			if (rebuild || _bitmapData == null)
			{
				if (_bitmapData != null)
				{
					_bitmapData.dispose();
				}

				_bitmapData = new BitmapData(_rect.width, _rect.height, _transparent, _bgColor);
			}
			else
			{
				_bitmapData.fillRect(_bitmapData.rect, _bgColor);
			}

			prePaint();

			if (_skin != null && _skin.bitmapData != null)
			{
				if (_skin.gridRight > _skin.gridLeft)
				{
					if (_skin.gridBottom > _skin.gridTop)
					{
						_skinDrawRect = drawFull(_bitmapData, _rect, _skin);
					}
					else
					{
						_skinDrawRect = drawHorizontal(_bitmapData, _rect, _skin);
					}
				}
				else
				{
					if (_skin.gridBottom > _skin.gridTop)
					{
						_skinDrawRect = drawVertical(_bitmapData, _rect, _skin);
					}
					else
					{
						_skinDrawRect = drawFixed(_bitmapData, _rect, _skin.align, _skin.bitmapData);
					}
				}
			}

			postPaint();
		}

		/**
		 * 画布重建之后，皮肤绘制之前
		 *
		 */
		protected function prePaint():void
		{
		}


		/**
		 * 绘制之后
		 *
		 */
		protected function postPaint():void
		{
		}



		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
		// 静态绘图方法，由子类使用

		/**
		 * 按完全缩放方式绘图制皮肤
		 * @param canvas 画布
		 * @param rect 范围矩形
		 * @param skin 皮肤
		 * @return 绘制区域
		 *
		 */
		protected static function drawFull(canvas:BitmapData, rect:Rectangle, skin:ISkin):Rectangle
		{
			var scaleW:int = rect.width - skin.minWidth;
			var scaleX:Number = scaleW / (skin.gridRight - skin.gridLeft);

			var scaleH:int = rect.height - skin.minHeight;
			var scaleY:Number = scaleH / (skin.gridBottom - skin.gridTop);


			canvas.lock();

			//绘制四角
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, 0, skin.gridLeft, skin.gridTop), new Point(0, 0), null,
							  null, true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(skin.gridRight, 0, skin.paddingRight, skin.gridTop),
							  new Point(rect.width - skin.paddingRight, 0), null, null, true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, skin.gridBottom, skin.gridLeft, skin.paddingBottom),
							  new Point(0, rect.height - skin.paddingBottom), null, null, true);
			canvas.copyPixels(skin.bitmapData,
							  new Rectangle(skin.gridRight, skin.gridBottom, skin.paddingRight, skin.paddingBottom),
							  new Point(rect.width - skin.paddingRight, rect.height - skin.paddingBottom), null, null,
							  true);

			var matrix:Matrix;
			//绘制上、下两边
			matrix = new Matrix();
			matrix.scale(scaleX, 1);
			matrix.translate(skin.gridLeft * (1 - scaleX), 0);
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(skin.gridLeft, 0, scaleW, skin.gridTop),
						smoothing);

			matrix.translate(0, rect.height - skin.bitmapData.height);
			canvas.draw(skin.bitmapData, matrix, null, null,
						new Rectangle(skin.gridLeft, rect.height - skin.paddingBottom, scaleW, skin.paddingBottom),
						smoothing);

			//绘制左、右两边
			matrix = new Matrix();
			matrix.scale(1, scaleY);
			matrix.translate(0, skin.gridTop * (1 - scaleY));
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(0, skin.gridTop, skin.gridLeft, scaleH),
						smoothing);

			matrix.translate(rect.width - skin.bitmapData.width, 0);
			canvas.draw(skin.bitmapData, matrix, null, null,
						new Rectangle(rect.width - skin.paddingRight, skin.gridTop, skin.paddingRight, scaleH),
						smoothing);

			//绘制中心
			matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			matrix.translate(skin.gridLeft * (1 - scaleX), skin.gridTop * (1 - scaleY));
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(skin.gridLeft, skin.gridTop, scaleW, scaleH),
						smoothing);

			canvas.unlock();

			return new Rectangle(0, 0, canvas.width, canvas.height);
		}

		/**
		 * 按垂直缩放方式绘制皮肤
		 * @param canvas 画布
		 * @param rect 范围矩形
		 * @param skin 皮肤
		 * @return 绘制区域
		 *
		 */
		protected static function drawVertical(canvas:BitmapData, rect:Rectangle, skin:ISkin):Rectangle
		{
			var ox:int;
			if ((skin.align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox = rect.width - skin.bitmapData.width >> 1;
			}
			else if ((skin.align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox = rect.width - skin.bitmapData.width;
			}

			var scaleH:int = rect.height - skin.minHeight;
			var scaleY:Number = scaleH / (skin.gridBottom - skin.gridTop);

			canvas.lock();

			//绘制上、下端
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, 0, skin.bitmapData.width, skin.gridTop),
							  new Point(ox, 0), null, null, true);
			canvas.copyPixels(skin.bitmapData,
							  new Rectangle(0, skin.gridBottom, skin.bitmapData.width, skin.paddingBottom),
							  new Point(ox, rect.height - skin.paddingBottom), null, null, true);

			var matrix:Matrix;
			//绘制中心
			matrix = new Matrix();
			matrix.scale(1, scaleY);
			matrix.translate(ox, skin.gridTop * (1 - scaleY));
			canvas.draw(skin.bitmapData, matrix, null, null,
						new Rectangle(ox, skin.gridTop, skin.bitmapData.width, scaleH), smoothing);

			canvas.unlock();

			return new Rectangle(ox, 0, skin.bitmapData.width, canvas.height);
		}

		/**
		 * 按水平缩放方式绘制皮肤
		 * @param canvas 画布
		 * @param rect 范围矩形
		 * @param skin 皮肤
		 * @return 绘制区域
		 *
		 */
		protected static function drawHorizontal(canvas:BitmapData, rect:Rectangle, skin:ISkin):Rectangle
		{
			var oy:int;
			if ((skin.align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy = rect.height - skin.bitmapData.height >> 1;
			}
			else if ((skin.align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy = rect.height - skin.bitmapData.height;
			}

			var scaleW:int = rect.width - skin.minWidth;
			var scaleX:Number = scaleW / (skin.gridRight - skin.gridLeft);

			canvas.lock();

			//绘制左、右端
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, 0, skin.gridLeft, skin.bitmapData.height),
							  new Point(0, oy), null, null, true);
			canvas.copyPixels(skin.bitmapData,
							  new Rectangle(skin.gridRight, 0, skin.paddingRight, skin.bitmapData.height),
							  new Point(rect.width - skin.paddingRight, oy), null, null, true);


			var matrix:Matrix;
			//绘制中心
			matrix = new Matrix();
			matrix.scale(scaleX, 1);
			matrix.translate(skin.gridLeft * (1 - scaleX), oy);
			canvas.draw(skin.bitmapData, matrix, null, null,
						new Rectangle(skin.gridLeft, oy, scaleW, skin.bitmapData.height), smoothing);

			canvas.unlock();

			return new Rectangle(0, oy, canvas.width, skin.bitmapData.height);
		}

		/**
		 * 按固定大小绘制图源
		 * @param canvas 画布
		 * @param rect 范围矩形
		 * @param align 对齐方式
		 * @param bitmapData 图源
		 * @param padding 边距
		 * @return 绘制区域
		 *
		 */
		protected static function drawFixed(canvas:BitmapData, rect:Rectangle, align:int, bitmapData:BitmapData,
											padding:Margin = null):Rectangle
		{
			var r:Rectangle = new Rectangle(0, 0, rect.width, rect.height);
			if (padding)
			{
				r.left = padding.left;
				r.top = padding.top;
				r.width -= padding.right;
				r.height -= padding.bottom;
			}

			var ox:int = r.left;
			if ((align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox += r.width - bitmapData.width >> 1;
			}
			else if ((align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox += r.width - bitmapData.width;
			}

			var oy:int = r.top;
			if ((align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy += r.height - bitmapData.height >> 1;
			}
			else if ((align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy += r.height - bitmapData.height;
			}

			var t:Rectangle = new Rectangle(ox, oy, bitmapData.width, bitmapData.height);
			t = r.intersection(t);

			canvas.copyPixels(bitmapData, new Rectangle(t.x - ox, t.y - oy, t.width, t.height), new Point(t.x, t.y),
							  null, null, true);

			return t;
		}
	}
}
