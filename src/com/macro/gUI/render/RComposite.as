package com.macro.gUI.render
{
	import com.macro.gUI.base.IComposite;
	import com.macro.gUI.base.IControl;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class RComposite extends RControl
	{
		
		protected var _container:Sprite;
		
		protected var _mask:Shape;
		
		
		public function RComposite(control:IComposite)
		{
			_container = new Sprite();
			_mask = new Shape();
			_container.mask = _mask;
			
			super(control);
		}
		
		public function get container():Sprite
		{
			return _container;
		}

		public function get mask():Shape
		{
			return _mask;
		}

		override public function updateLocation():void
		{
			super.updateLocation();
			_mask.x = _container.x = _control.rect.x;
			_mask.y = _container.y = _control.rect.y;
		}
		
		override public function updateSource():void
		{
			super.updateSource();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, _control.rect.width, _control.rect.height);
			_mask.graphics.endFill();
		}
		
		override public function updateAlpha():void
		{
			super.updateAlpha();
			_container.alpha = _control.alpha;
		}
		
		override public function updateVisible():void
		{
			super.updateVisible();
			_container.visible = _control.visible;
		}
		
		override public function dispose():void
		{
			super.dispose();
			while(_container.numChildren > 0)
			{
				_container.removeChildAt(0);
			}
			_container = null;
			_mask = null;
		}
		
		
	}
}