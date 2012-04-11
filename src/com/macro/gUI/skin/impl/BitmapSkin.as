package com.macro.gUI.skin.impl
{
	import com.macro.gUI.skin.ISkin;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;


	/**
	 * 位图皮肤
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class BitmapSkin implements ISkin
	{
		private var _bitmapData:BitmapData;

		private var _align:int;

		private var _gridLeft:int;

		private var _gridTop:int;

		private var _gridRight:int;

		private var _gridBottom:int;

		private var _paddingRight:int;

		private var _paddingBottom:int;

		private var _minWidth:int;

		private var _minHeight:int;

		/**
		 * 位图皮肤。九切片默认参数均为0，表示不支持九切片缩放
		 * @param bitmapData 图源
		 * @param grid 九切片中心区域矩形。注意，缩放将使用此矩形的left, top, right, bottom值，而不是width, height。
		 * 当right大于left时，皮肤可以水平缩放，当bottom大于top时皮肤可以垂直缩放
		 * @param align 皮肤对齐方式，仅在使用非完全缩放的皮肤时有效。
		 * 请使用LayoutAlign枚举，可按此方式设置左上角对齐：LayoutAlign.LEFT | LayoutAlign.TOP
		 *
		 */
		public function BitmapSkin(bitmapData:BitmapData, grid:Rectangle,
								   align:int)
		{
			if (bitmapData == null)
			{
				throw new Error("Invalid BitmapData!");
			}

			_bitmapData = bitmapData;
			_align = align;

			_gridLeft = grid.left;
			_gridRight = grid.right > bitmapData.width ? bitmapData.width : grid.right;
			_gridTop = grid.top;
			_gridBottom = grid.bottom > bitmapData.height ? bitmapData.height : grid.bottom;

			_paddingRight = bitmapData.width - grid.right;
			_paddingBottom = bitmapData.height - grid.bottom;

			_minWidth = _gridLeft + _paddingRight;
			_minHeight = _gridTop + _paddingBottom;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function get align():int
		{
			return _align;
		}

		public function get gridBottom():int
		{
			return _gridBottom;
		}

		public function get gridLeft():int
		{
			return _gridLeft;
		}

		public function get gridRight():int
		{
			return _gridRight;
		}

		public function get gridTop():int
		{
			return _gridTop;
		}

		public function get paddingBottom():int
		{
			return _paddingBottom;
		}

		public function get paddingRight():int
		{
			return _paddingRight;
		}

		public function get minHeight():int
		{
			return _minHeight;
		}

		public function get minWidth():int
		{
			return _minWidth;
		}
	}
}
