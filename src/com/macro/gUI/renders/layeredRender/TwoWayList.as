package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.core.IControl;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	/**
	 * 双向表
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class TwoWayList
	{
		private var _controlToBitmap:Dictionary;
		
		private var _bitmapToControl:Dictionary;
		
		public function TwoWayList()
		{
			_controlToBitmap = new Dictionary(true);
			_bitmapToControl = new Dictionary(true);
		}
		
		public function add(control:IControl, bitmap:Bitmap):void
		{
			_controlToBitmap[control] = bitmap;
			_bitmapToControl[bitmap] = control;
		}
		
		public function removeByBitmap(bitmap:Bitmap):IControl
		{
			var control:IControl = _bitmapToControl[bitmap];
			_controlToBitmap[control] = null;
			delete _controlToBitmap[control];
			
			_bitmapToControl[bitmap] = null;
			delete _bitmapToControl[bitmap];
			
			return control;
		}
		
		public function removeByControl(control:IControl):Bitmap
		{
			var bitmap:Bitmap = _controlToBitmap[control];
			removeByBitmap(bitmap);
			return bitmap;
		}
		
		public function getControl(bitmap:Bitmap):IControl
		{
			return _bitmapToControl[bitmap];
		}
		
		public function getBitmap(control:IControl):Bitmap
		{
			return _controlToBitmap[control];
		}
	}
}