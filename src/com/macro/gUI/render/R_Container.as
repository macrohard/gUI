package com.macro.gUI.render
{
	import com.macro.gUI.base.IContainer;
	
	import flash.display.Bitmap;

	public class R_Container extends R_Composite
	{
		protected var _cover:Bitmap;
		
		public function R_Container(control:IContainer)
		{
			_cover = new Bitmap(control.bitmapDataCover);
			
			super(control);
		}
		
		public function get cover():Bitmap
		{
			return _cover;
		}

		override public function updateLocation():void
		{
			super.updateLocation();
			_cover.x = _control.rect.x;
			_cover.y = _control.rect.y;
		}
		
		override public function updateSource():void
		{
			super.updateSource();
			_cover.bitmapData = IContainer(_control).bitmapDataCover;
		}
		
		override public function updateAlpha():void
		{
			super.updateAlpha();
			_cover.alpha = _control.alpha;
		}
		
		override public function updateVisible():void
		{
			super.updateVisible();
			_cover.visible = _control.visible;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_cover.bitmapData = null;
			_cover = null;
		}
		
		
	}
}