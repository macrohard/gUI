package com.macro.gUI.controls
{
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.skin.ISkin;


	/**
	 * 九切片控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Slice extends AbstractControl
	{
		/**
		 * 九切片控件，基本显示单元，常用于背景皮肤显示
		 * @param width
		 * @param height
		 * @param skin
		 *
		 */
		public function Slice(skin:ISkin, width:int = 100, height:int = 100)
		{
			super(width, height);

			_skin = skin;

			resize();
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
			if (_skin != value)
			{
				_skin = value;
				resize();
			}
		}
	}
}
