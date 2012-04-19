package com.macro.gUI.composite
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Canvas;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 水平进度条
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ProgressBar extends AbstractComposite
	{

		protected var _canvas:Canvas;

		protected var _bg:Slice;


		/**
		 * 是否使用遮罩
		 */
		private var _mask:Boolean;

		private var _fillingSkin:ISkin;


		/**
		 * 水平进度条控件。根据填充物的九切片定义来确定是平铺填充，还是缩放填充。<br/>
		 * 缩放填充时可以使用遮罩，使用遮罩时，将首先用填充物填满，然后使用遮罩来显示进度。<br/>
		 * 默认自动设置尺寸
		 * @param width 宽度
		 * @param align 布局对齐方式
		 * @param maskMode 使用遮罩
		 *
		 */
		public function ProgressBar(width:int = 200, align:int = 0x20, mask:Boolean = false)
		{
			//复选框控件默认是自动设置尺寸的，稍后resize时会重设为标准大小
			super(width, 1, align);

			_autoSize = true;
			_mask = mask;

			var skin:ISkin = skinManager.getSkin(SkinDef.PROGRESSBAR_BG);
			_bg = new Slice(skin, width, skin.bitmapData.height);

			_fillingSkin = skinManager.getSkin(SkinDef.PROGRESSBAR_FILLING);
			_canvas = new Canvas(width - skin.gridLeft - skin.gridRight, _fillingSkin.bitmapData.height);

			_container = new Container();
			_container.addChild(_bg);
			_container.addChild(_canvas);

			resize(_rect.width);
		}



		private var _autoSize:Boolean;

		/**
		 * 自动设置高度
		 * @return
		 *
		 */
		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			if (_autoSize != value)
			{
				_autoSize = value;
				if (_autoSize)
				{
					resize(_rect.width);
				}
			}
		}


		private var _percent:int;

		/**
		 * 进度百分比，最小值为0，最大值为100
		 * @return
		 *
		 */
		public function get percent():int
		{
			return _percent;
		}

		public function set percent(value:int):void
		{
			if (_percent != value)
			{
				_percent = value > 100 ? 100 : (value < 0 ? 0 : value);
				drawPercentImage();
			}
		}



		/**
		 * 设置皮肤
		 * @param bgSkin 背景皮肤。注意将使用此皮肤的gridLeft和gridTop来定位填充物左上角坐标
		 * @param fillingSkin 填充物皮肤
		 *
		 */
		public function setSkins(bgSkin:ISkin, fillingSkin:ISkin):void
		{
			_bg.skin = bgSkin;
			_bg.height = bgSkin.bitmapData.height;
			_fillingSkin = fillingSkin;
			_canvas.height = fillingSkin.bitmapData.height;
			if (_autoSize)
			{
				resize(_rect.width);
			}
			else
			{
				layout();
			}
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				if (_fillingSkin.gridRight <= _fillingSkin.gridLeft)
				{
					var w:int = width - _bg.skin.minWidth;
					w = Math.round(w / _fillingSkin.bitmapData.width) * _fillingSkin.bitmapData.width;
					width = _bg.skin.minWidth + w;
				}
				else
				{
					width = width < _bg.skin.minWidth ? _bg.skin.minWidth : width;
				}

				height = _bg.height;
			}

			super.resize(width, height);
		}

		public override function setDefaultSize():void
		{
			resize(_rect.width, _bg.height);
		}



		protected override function layout():void
		{
			var oy:int;
			if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy += _rect.height - _bg.height >> 1;
			}
			else if ((_align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy += _rect.height - _bg.height;
			}

			_bg.y = oy;
			_bg.width = _rect.width;

			_canvas.x = _bg.x + _bg.skin.gridLeft;
			_canvas.y = _bg.y + _bg.skin.gridTop;
			_canvas.width = _rect.width - _bg.skin.minWidth;
			drawPercentImage();
		}

		private function drawPercentImage():void
		{
			if (_percent == 0)
			{
				return;
			}

			var bmd:BitmapData = _canvas.bitmapData;
			bmd.lock();
			bmd.fillRect(bmd.rect, 0);

			if (_fillingSkin.gridRight > _fillingSkin.gridLeft)
			{
				if (_mask)
				{
					var m:BitmapData = new BitmapData(bmd.width, bmd.height, true, 0);
					drawHorizontal(m, m.rect, _fillingSkin);
					bmd.copyPixels(m, new Rectangle(0, 0, m.width * _percent / 100, m.height), new Point(), null, null, true);
					m.dispose();
				}
				else
				{
					drawHorizontal(bmd, new Rectangle(0, 0, bmd.width * _percent / 100, bmd.height), _fillingSkin);
				}
			}
			else
			{
				var i:int;
				var w:int = bmd.width * _percent / 100;
				while (true)
				{
					bmd.copyPixels(_fillingSkin.bitmapData, _fillingSkin.bitmapData.rect, new Point(i), null, null, true);
					i += _fillingSkin.bitmapData.width;
					if (i > w)
					{
						break;
					}
				}
			}

			bmd.unlock();
		}
	}
}
