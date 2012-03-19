package com.macro.gUI.controls.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.controls.Canvas;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 进度条
	 * @author Macro776@gmail.com
	 *
	 */
	public class ProgressBar extends AbstractComposite
	{
		private var _autoSize:Boolean;

		private var _mask:Boolean;

		private var _bg:Slice;

		private var _canvas:Canvas;

		private var _percent:int;

		private var _infillSkin:ISkin;


		/**
		 * 水平进度条控件。根据填充物的九切片定义来确定是平铺填充，还是缩放填充。<br/>
		 * 缩放填充时可以使用遮罩，使用遮罩时，将首先用填充物填满，然后使用遮罩来显示进度。
		 * @param maskMode 使用遮罩
		 * @param width 宽度
		 * @param align 布局对齐方式
		 * @param bgSkin 背景皮肤。注意将使用此皮肤的gridLeft和gridTop来定位填充物左上角坐标
		 * @param infillSkin 填充物
		 *
		 */
		public function ProgressBar(mask:Boolean = false, width:int = 200, align:int = 0x20, bgSkin:ISkin = null,
									infillSkin:ISkin = null)
		{
			super(width, 20, align);

			_autoSize = true;

			_mask = mask;

			bgSkin = bgSkin ? bgSkin : GameUI.skinManager.getSkin(SkinDef.PROGRESSBAR_BG);
			_bg = new Slice(width, bgSkin.bitmapData.height, bgSkin);

			_infillSkin = infillSkin ? infillSkin : GameUI.skinManager.getSkin(SkinDef.PROGRESSBAR_INFILL);
			_canvas = new Canvas(width - bgSkin.gridLeft - bgSkin.gridRight, _infillSkin.bitmapData.height);

			_children.push(_bg);
			_children.push(_canvas);

			resize(_rect.width);
		}

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



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				if (_infillSkin.gridRight <= _infillSkin.gridLeft)
				{
					var w:int = width - _bg.skin.minWidth;
					w = Math.round(w / _infillSkin.bitmapData.width) * _infillSkin.bitmapData.width;
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
				oy += (_rect.height - _bg.height) >> 1;
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

			if (_infillSkin.gridRight > _infillSkin.gridLeft)
			{
				if (_mask)
				{
					var m:BitmapData = new BitmapData(bmd.width, bmd.height, true, 0);
					drawHorizontal(m, m.rect, _infillSkin);
					bmd.copyPixels(m, new Rectangle(0, 0, m.width * _percent / 100, m.height), new Point(), null, null,
								   true);
					m.dispose();
				}
				else
				{
					drawHorizontal(bmd, new Rectangle(0, 0, bmd.width * _percent / 100, bmd.height), _infillSkin);
				}
			}
			else
			{
				var i:int;
				var w:int = bmd.width * _percent / 100;
				while (true)
				{
					bmd.copyPixels(_infillSkin.bitmapData, _infillSkin.bitmapData.rect, new Point(i), null, null, true);
					i += _infillSkin.bitmapData.width;
					if (i > w)
					{
						break;
					}
				}
			}

			bmd.unlock();
		}



		//==============================================================
		// 样式定义

		public function get bgSkin():ISkin
		{
			return _bg.skin;
		}

		public function set bgSkin(value:ISkin):void
		{
			_bg.skin = value;
			_bg.height = value.bitmapData.height;
			layout();
		}

		public function get infillSkin():ISkin
		{
			return _infillSkin;
		}

		public function set infillSkin(value:ISkin):void
		{
			_infillSkin = value;
			_canvas.height = value.bitmapData.height;
			layout();
		}

	}
}
