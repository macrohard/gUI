package com.macro.gUI.controls
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.AbstractControl;
	import com.macro.gUI.skin.ISkin;
	
	public class Slice extends AbstractControl
	{
		/**
		 * 九切片显示单元，最简单的皮肤显示控件
		 * @param width
		 * @param height
		 * @param skin
		 * 
		 */
		public function Slice(width:int = 100, height:int = 100, skin:ISkin = null)
		{
			super(width, height);
			
			_skin = skin;
			
			paint();
		}
		
		
		/**
		 * 皮肤
		 * @return 
		 * 
		 */
		public function get skin():ISkin
		{
			return _skin;
		}
		
		public function set skin(value:ISkin):void
		{
			_skin = value;
			paint();
		}
	}
}