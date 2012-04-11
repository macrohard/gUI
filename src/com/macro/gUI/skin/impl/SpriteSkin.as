package com.macro.gUI.skin.impl
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;


	/**
	 * Sprite皮肤
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class SpriteSkin extends BitmapSkin
	{
		/**
		 * Sprite皮肤。九切片默认参数均为0，表示不支持九切片缩放
		 * @param sprite 显示对象
		 * @param grid 九切片中心区域矩形。注意，缩放将使用此矩形的left, top, right, bottom值，而不是width, height。
		 * 当right大于left时，皮肤可以水平缩放，当bottom大于top时皮肤可以垂直缩放
		 * @param align 皮肤对齐方式，仅在使用非完全缩放的皮肤时有效。
		 * 请使用LayoutAlign枚举，可按此方式设置左上角对齐：LayoutAlign.LEFT | LayoutAlign.TOP
		 *
		 */
		public function SpriteSkin(sprite:Sprite, grid:Rectangle, align:int)
		{
			var r:Rectangle = sprite.getBounds(null);
			var bmd:BitmapData = new BitmapData(r.right + 1, r.bottom + 1, true,
												0);
			bmd.draw(sprite);
			super(bmd, grid, align);
		}
	}
}
