package com.macro.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;

	public class ImageUtil
	{
		public static function getBitmapData(source:IBitmapDrawable):BitmapData
		{
			if (source == null)
			{
				return null;
			}
			
			if (source is BitmapData)
			{
				return source as BitmapData;
			}
			else if (source is DisplayObject)
			{
				var r:Rectangle = (source as DisplayObject).getBounds(null);
				var bmd:BitmapData = new BitmapData(r.right + 1, r.bottom + 1, true, 0);
				bmd.draw(source);
				return bmd;
			}
			
			throw new Error("Unknow IBitmapDrawable Object!");
		}
	}
}