package com.macro.gUI.core
{

	import avmplus.getQualifiedClassName;

	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.events.UIEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinManager;

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 抽象基础控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class AbstractControl extends EventDispatcher implements IControl
	{

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


			// 默认透明度
			_alpha = 1;

			// 默认可见
			_visible = true;

			// 默认无色，0x00000000
			_bgColor = 0;

			// 默认透明
			_transparent = true;

			// 默认控件可用
			_enabled = true;

			// 默认尺寸
			_width = width;
			_height = height;
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


		public function get rect():Rectangle
		{
			return new Rectangle(_x - _pivotX, _y - _pivotY, _width, _height);
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


		protected var _x:int;

		/**
		 * 横坐标
		 * @return
		 *
		 */
		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			uiManager.renderer.updateCoord(this);
		}


		protected var _y:int;

		/**
		 * 纵坐标
		 * @return
		 *
		 */
		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			uiManager.renderer.updateCoord(this);
		}


		protected var _width:int;

		/**
		 * 控件宽度，最小宽度是1
		 * @return
		 *
		 */
		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			if (_width != value && value > 0)
			{
				resize(value, _height);
			}
		}


		protected var _height:int;

		/**
		 * 控件高度，最小高度是1
		 * @return
		 *
		 */
		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			if (_height != value && value > 0)
			{
				resize(_width, value);
			}
		}





		private var _alpha:Number;

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			value = value < 0 ? 0 : (value > 1 ? 1 : value);
			if (_alpha != value)
			{
				_alpha = value;
				uiManager.renderer.updateAlpha(this);
			}
		}


		private var _visible:Boolean;

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			if (_visible != value)
			{
				_visible = value;
				uiManager.renderer.updateVisible(this);
			}
		}


		private var _scaleX:Number;

		public function get scaleX():Number
		{
			return _scaleX;
		}

		public function set scaleX(value:Number):void
		{
			_scaleX = value;
		}


		private var _scaleY:Number;

		public function get scaleY():Number
		{
			return _scaleY;
		}

		public function set scaleY(value:Number):void
		{
			_scaleY = value;
		}


		private var _pivotX:int;

		public function get pivotX():int
		{
			return _pivotX;
		}

		public function set pivotX(value:int):void
		{
			if (_pivotX != value)
			{
				_pivotX = value;
				uiManager.renderer.updateCoord(this);
			}
		}


		private var _pivotY:int;

		public function get pivotY():int
		{
			return _pivotY;
		}

		public function set pivotY(value:int):void
		{
			if (_pivotY != value)
			{
				_pivotY = value;
				uiManager.renderer.updateCoord(this);
			}
		}


		private var _rotation:Number;

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_rotation = value;
		}






		private var _parent:IContainer;

		public function get parent():IContainer
		{
			return _parent;
		}


		private var _stage:IContainer;

		public function get stage():IContainer
		{
			return _stage;
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


		/**
		 * 设置根容器，内部行为，外部无法访问
		 * @param stage
		 *
		 */
		internal function setStage(stage:IContainer):void
		{
			_stage = stage;
		}


		public function localToGlobal(point:Point = null):Point
		{
			var p:Point = point;
			if (p == null)
			{
				p = new Point();
			}

			return getTransformMatrix().transformPoint(p);
		}


		/**
		 * 将全局坐标转换为本地坐标
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		public function globalToLocal(point:Point):Point
		{
			var m:Matrix = getTransformMatrix();
			m.invert();
			return m.transformPoint(point);
		}


		/**
		 * 获取变形矩阵
		 * @return
		 *
		 */
		private function getTransformMatrix():Matrix
		{
			var m:Matrix = new Matrix();
			m.translate(_x - _pivotX, _y - _pivotY);

			var container:IContainer = this.parent;
			while (container != null)
			{
				m.translate(container.x + container.margin.left - container.pivotX, container.y + container.margin.top - container.pivotY);
				container = container.parent;
			}

			return m;
		}


		public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));

			if (p.x >= 0 && p.x <= _width && p.y >= 0 && p.y <= _height)
			{
				return this;
			}

			return null;
		}



		/**
		 * 添加侦听器。弱引用参数默认值为true，因为使用类成员作为侦听器的使用环境更为常见。<br/>
		 * <b>注意，gUI的事件不支持冒泡</b>
		 *
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
												  useWeakReference:Boolean = true):void
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
			width = width <= 0 ? _width : width;
			height = height <= 0 ? _height : height;

			if (_skin != null)
			{
				width = width < _skin.minWidth ? _skin.minWidth : width;
				height = height < _skin.minHeight ? _skin.minHeight : height;
			}

			if (_width != width || _height != height)
			{
				_width = width;
				_height = height;
				paint(true);
			}
			else
			{
				paint();
			}

			dispatchEvent(new UIEvent(UIEvent.RESIZE));
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
		 * @param rebuild 是否重建BitmapData
		 *
		 */
		private function paint(rebuild:Boolean = false):void
		{
			if (rebuild || _bitmapData == null)
			{
				if (_bitmapData != null)
				{
					_bitmapData.dispose();
				}

				_bitmapData = new BitmapData(_width, _height, _transparent, _bgColor);
				uiManager.renderer.updatePaint(this, true);
			}
			else
			{
				_bitmapData.fillRect(_bitmapData.rect, _bgColor);
				uiManager.renderer.updatePaint(this, false);
			}

			prePaint();

			if (_skin != null && _skin.bitmapData != null)
			{
				if (_skin.gridRight > _skin.gridLeft)
				{
					if (_skin.gridBottom > _skin.gridTop)
					{
						_skinDrawRect = drawFull(_bitmapData, _width, _height, _skin);
					}
					else
					{
						_skinDrawRect = drawHorizontal(_bitmapData, _width, _height, _skin);
					}
				}
				else
				{
					if (_skin.gridBottom > _skin.gridTop)
					{
						_skinDrawRect = drawVertical(_bitmapData, _width, _height, _skin);
					}
					else
					{
						_skinDrawRect = drawFixed(_bitmapData, _width, _height, _skin.align, _skin.bitmapData);
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


		/**
		 * 平滑绘制
		 */
		protected static var smoothing:Boolean;

		/**
		 * 界面管理器
		 */
		protected static var uiManager:UIManager;

		/**
		 * 皮肤管理器
		 */
		protected static var skinManager:SkinManager;


		/**
		 * 初始化控件基类
		 * @param uiManager
		 * @param skinManager
		 * @param smoothing
		 *
		 */
		internal static function init(uiManager:UIManager, smoothing:Boolean = true):void
		{
			AbstractControl.uiManager = uiManager;
			AbstractControl.skinManager = uiManager.skinManager;
			AbstractControl.smoothing = smoothing;
		}



		/**
		 * 按完全缩放方式绘图制皮肤
		 * @param canvas 画布
		 * @param rect 范围矩形
		 * @param skin 皮肤
		 * @return 绘制区域
		 *
		 */
		public static function drawFull(canvas:BitmapData, width:int, height:int, skin:ISkin):Rectangle
		{
			var scaleW:int = width - skin.minWidth;
			var scaleX:Number = scaleW / (skin.gridRight - skin.gridLeft);

			var scaleH:int = height - skin.minHeight;
			var scaleY:Number = scaleH / (skin.gridBottom - skin.gridTop);


			canvas.lock();

			//绘制四角
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, 0, skin.gridLeft, skin.gridTop), new Point(0, 0), null, null, true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(skin.gridRight, 0, skin.paddingRight, skin.gridTop),
							  new Point(width - skin.paddingRight, 0), null, null, true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, skin.gridBottom, skin.gridLeft, skin.paddingBottom),
							  new Point(0, height - skin.paddingBottom), null, null, true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(skin.gridRight, skin.gridBottom, skin.paddingRight, skin.paddingBottom),
							  new Point(width - skin.paddingRight, height - skin.paddingBottom), null, null, true);

			var matrix:Matrix;
			//绘制上、下两边
			matrix = new Matrix();
			matrix.scale(scaleX, 1);
			matrix.translate(skin.gridLeft * (1 - scaleX), 0);
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(skin.gridLeft, 0, scaleW, skin.gridTop), smoothing);

			matrix.translate(0, height - skin.bitmapData.height);
			canvas.draw(skin.bitmapData, matrix, null, null,
						new Rectangle(skin.gridLeft, height - skin.paddingBottom, scaleW, skin.paddingBottom), smoothing);

			//绘制左、右两边
			matrix = new Matrix();
			matrix.scale(1, scaleY);
			matrix.translate(0, skin.gridTop * (1 - scaleY));
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(0, skin.gridTop, skin.gridLeft, scaleH), smoothing);

			matrix.translate(width - skin.bitmapData.width, 0);
			canvas.draw(skin.bitmapData, matrix, null, null,
						new Rectangle(width - skin.paddingRight, skin.gridTop, skin.paddingRight, scaleH), smoothing);

			//绘制中心
			matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			matrix.translate(skin.gridLeft * (1 - scaleX), skin.gridTop * (1 - scaleY));
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(skin.gridLeft, skin.gridTop, scaleW, scaleH), smoothing);

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
		public static function drawVertical(canvas:BitmapData, width:int, height:int, skin:ISkin):Rectangle
		{
			var ox:int;
			if ((skin.align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox = width - skin.bitmapData.width >> 1;
			}
			else if ((skin.align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox = width - skin.bitmapData.width;
			}

			var scaleH:int = height - skin.minHeight;
			var scaleY:Number = scaleH / (skin.gridBottom - skin.gridTop);

			canvas.lock();

			//绘制上、下端
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, 0, skin.bitmapData.width, skin.gridTop), new Point(ox, 0), null, null, true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, skin.gridBottom, skin.bitmapData.width, skin.paddingBottom),
							  new Point(ox, height - skin.paddingBottom), null, null, true);

			var matrix:Matrix;
			//绘制中心
			matrix = new Matrix();
			matrix.scale(1, scaleY);
			matrix.translate(ox, skin.gridTop * (1 - scaleY));
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(ox, skin.gridTop, skin.bitmapData.width, scaleH), smoothing);

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
		public static function drawHorizontal(canvas:BitmapData, width:int, height:int, skin:ISkin):Rectangle
		{
			var oy:int;
			if ((skin.align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy = height - skin.bitmapData.height >> 1;
			}
			else if ((skin.align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy = height - skin.bitmapData.height;
			}

			var scaleW:int = width - skin.minWidth;
			var scaleX:Number = scaleW / (skin.gridRight - skin.gridLeft);

			canvas.lock();

			//绘制左、右端
			canvas.copyPixels(skin.bitmapData, new Rectangle(0, 0, skin.gridLeft, skin.bitmapData.height), new Point(0, oy), null, null,
							  true);
			canvas.copyPixels(skin.bitmapData, new Rectangle(skin.gridRight, 0, skin.paddingRight, skin.bitmapData.height),
							  new Point(width - skin.paddingRight, oy), null, null, true);


			var matrix:Matrix;
			//绘制中心
			matrix = new Matrix();
			matrix.scale(scaleX, 1);
			matrix.translate(skin.gridLeft * (1 - scaleX), oy);
			canvas.draw(skin.bitmapData, matrix, null, null, new Rectangle(skin.gridLeft, oy, scaleW, skin.bitmapData.height), smoothing);

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
		public static function drawFixed(canvas:BitmapData, width:int, height:int, align:int, bitmapData:BitmapData,
										 padding:Margin = null):Rectangle
		{
			var r:Rectangle = new Rectangle(0, 0, width, height);
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

			canvas.copyPixels(bitmapData, new Rectangle(t.x - ox, t.y - oy, t.width, t.height), new Point(t.x, t.y), null, null, true);

			return t;
		}
	}
}
