package com.macro.gUI.containers
{
	import com.macro.gUI.core.AbstractContainer;
	import com.macro.gUI.events.UIEvent;
	
	import flash.geom.Rectangle;


	/**
	 * 空容器，无皮肤定义
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Container extends AbstractContainer
	{

		public function Container(width:int = 100, height:int = 100)
		{
			super(width, height);
		}

		public override function resize(width:int=0, height:int=0):void
		{
			if (_bitmapData == null)
			{
				_rect.width = width <= 0 ? _rect.width : width;
				_rect.height = height <= 0 ? _rect.height : height;
				uiManager.renderer.updatePaint(this, true);
				dispatchEvent(new UIEvent(UIEvent.RESIZE));
			}
			else
			{
				super.resize(width, height);
			}
		}
	}
}
