package com.macro.gUI.skin.impl
{
	import com.macro.gUI.skin.IAnimationSkin;
	import com.macro.gUI.skin.ISkin;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class MovieClipSkin implements ISkin, IAnimationSkin
	{
		public function MovieClipSkin(mc:MovieClip, framerate:int, grid:Rectangle, align:int)
		{
		}
		
		public function get align():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		
		public function get bitmapData():BitmapData
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function get gridBottom():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get gridLeft():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get gridRight():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get gridTop():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get paddingBottom():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get paddingRight():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get minHeight():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get minWidth():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		
	}
}