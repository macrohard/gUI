package com.macro.gUI.assist
{
	import flash.geom.Rectangle;
	
	public class Margin extends Rectangle
	{
		public function Margin(left:int = 0, top:int = 0, right:int = 0, bottom:int = 0)
		{
			super(left, top, right - left, bottom - top);
		}
	}
}