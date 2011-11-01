package com.macro.gUI.render
{
	import com.macro.gUI.base.IControl;
	
	import flash.display.Bitmap;

	public class R_Control
	{
		protected var _canvas:Bitmap;
		
		protected var _control:IControl;
		
		public function R_Control(control:IControl)
		{
			_control = control;
			_canvas = new Bitmap(control.bitmapData);
			updateLocation();
			updateAlpha();
			updateVisible();
		}
		
		public function get canvas():Bitmap
		{
			return _canvas;
		}

		public function updateLocation():void
		{
			_canvas.x = _control.rect.x;
			_canvas.y = _control.rect.y;
		}
		
		public function updateSource():void
		{
			_canvas.bitmapData = _control.bitmapData;
		}
		
		public function updateAlpha():void
		{
			_canvas.alpha = _control.alpha;
		}
		
		public function updateVisible():void
		{
			_canvas.visible = _control.visible;
		}
		
		public function dispose():void
		{
			_canvas.bitmapData = null;
			_canvas = null;
			_control = null;
		}
	}
}