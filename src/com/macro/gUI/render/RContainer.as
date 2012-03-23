package com.macro.gUI.render
{
	import com.macro.gUI.base.IContainer;
	
	import flash.display.Bitmap;

	public class RContainer extends RControl
	{
		protected var _cover:Bitmap;
		
		public function RContainer(control:IContainer)
		{
			_cover = new Bitmap(control.bitmapDataCover);
			
			super(control);
		}
		
		public function get cover():Bitmap
		{
			return _cover;
		}

		public override function updateLocation():void
		{
			super.updateLocation();
			_cover.x = _control.rect.x;
			_cover.y = _control.rect.y;
		}
		
		public override function updateSource():void
		{
			super.updateSource();
			_cover.bitmapData = IContainer(_control).bitmapDataCover;
		}
		
		public override function updateAlpha():void
		{
			super.updateAlpha();
			_cover.alpha = _control.alpha;
		}
		
		public override function updateVisible():void
		{
			super.updateVisible();
			_cover.visible = _control.visible;
		}
		
		public override function dispose():void
		{
			super.dispose();
			_cover.bitmapData = null;
			_cover = null;
		}
		
		
	}
}