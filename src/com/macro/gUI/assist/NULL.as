package com.macro.gUI.assist
{
	import com.macro.gUI.base.IContainer;
	import com.macro.gUI.base.IControl;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 空类型，用于辅助交互管理器判定是否下探搜索子控件的交互功能。
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class NULL implements IControl
	{
		public function NULL()
		{
		}
		
		public function get bitmapData():BitmapData
		{
			return null;
		}
		
		public function get rect():Rectangle
		{
			return null;
		}
		
		public function get enabled():Boolean
		{
			return false;
		}
		
		public function get alpha():Number
		{
			return 0;
		}
		
		public function get visible():Boolean
		{
			return false;
		}
		
		public function get parent():IContainer
		{
			return null;
		}
		
		public function globalCoord():Point
		{
			return null;
		}
		
		public function hitTest(x:int, y:int):IControl
		{
			return null;
		}
	}
}