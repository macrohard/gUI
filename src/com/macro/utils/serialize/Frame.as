package com.macro.utils.serialize
{
	import flash.display.BitmapData;
	import flash.geom.Point;


	/**
	 * MovieClip转换后的帧，包含对应的BitmapData及OffsetPoint偏移量
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class Frame extends BitmapData
	{
		/**
		 * 偏移量
		 */
		public var offsetPoint:Point;

		public function Frame(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0)
		{
			super(width, height, transparent, fillColor);
		}
	}
}
