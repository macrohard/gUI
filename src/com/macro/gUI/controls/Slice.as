package com.macro.gUI.controls
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.AbstractControl;
	import com.macro.gUI.skin.ISkin;
	
	/**
	 * 九切片控件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class Slice extends AbstractControl
	{
		/**
		 * 九切片控件，基本显示单元，最简单的皮肤显示控件
		 * @param width
		 * @param height
		 * @param skin
		 * 
		 */
		public function Slice(skin:ISkin, width:int = 100, height:int = 100)
		{
			super(width, height);
			
			_skin = skin;
			
			resize(width, height);
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