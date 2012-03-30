package com.macro.gUI.controls
{
	import com.macro.gUI.base.AbstractControl;
	
	/**
	 * 画布
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class Canvas extends AbstractControl
	{
		/**
		 * 画布控件，没有皮肤定义，提供bitmapData对象以供绘制。
		 * 注意，resize时，bitmapData将被重建
		 * @param width
		 * @param height
		 * 
		 */
		public function Canvas(width:int = 100, height:int = 100)
		{
			super(width, height);
			paint();
		}
	}
}