package com.macro.gUI.containers
{
	import com.macro.gUI.base.AbstractContainer;
	
	import flash.geom.Rectangle;
	
	/**
	 * 空容器，无皮肤定义
	 * @author Macro776@gmail.com
	 * 
	 */
	public class Container extends AbstractContainer
	{
		
		public function Container(width:int = 100, height:int = 100)
		{
			super(width, height);
			_marginRect = new Rectangle();
		}
		
		/**
		 * 空容器本身一般情况下不需要背景，因此在背景完全透明时，可以忽略掉绘制行为
		 * @param rebuild
		 * 
		 */
		protected override function paint(rebuild:Boolean=false):void
		{
			if (_bgColor == 0 && _transparent)
			{
				if (_bitmapData != null)
				{
					_bitmapData.dispose();
					_bitmapData = null;
				}
				return;
			}
			
			super.paint(rebuild);
		}
		
		
	}
}