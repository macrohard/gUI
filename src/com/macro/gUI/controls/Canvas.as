package com.macro.gUI.controls
{
	import com.macro.gUI.core.AbstractControl;
	
	import flash.display.BitmapData;


	/**
	 * 画布
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Canvas extends AbstractControl
	{
		/**
		 * 画布控件，没有皮肤定义，提供bitmapData对象以供绘制。
		 * 可以将画布用于序列帧的播放，遂帧替换bitmapData，然后调用update方法通知渲染器更新。
		 * 注意，resize时，bitmapData将被自动重建
		 * @param width
		 * @param height
		 *
		 */
		public function Canvas(width:int = 100, height:int = 100)
		{
			super(width, height);

			resize();
		}
		
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			uiMgr.renderer.updatePaint(this, true);
		}
		
		
		/**
		 * 绘制后更新
		 * 
		 */
		public function update():void
		{
			uiMgr.renderer.updatePaint(this, false);
		}
	}
}
