package com.macro.gUI.assist
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 空类型，用于辅助交互管理器判定是否下探搜索子控件的交互功能。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class CHILD_REGION extends EventDispatcher implements IControl
	{
		public function CHILD_REGION()
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
			return true;
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
		
		public function get stage():IContainer
		{
			return null;
		}

		public function localToGlobal(point:Point = null):Point
		{
			return null;
		}
		
		public function globalToLocal(point:Point):Point
		{
			return null;
		}

		public function hitTest(x:int, y:int):IControl
		{
			return null;
		}

		public function get scaleX():Number
		{
			return 0;
		}

		public function get scaleY():Number
		{
			return 0;
		}

		public function get pivotX():Number
		{
			return 0;
		}

		public function get pivotY():Number
		{
			return 0;
		}

		public function get rotation():Number
		{
			return 0;
		}

	}
}
