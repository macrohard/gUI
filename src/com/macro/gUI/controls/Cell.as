package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	import flash.geom.Rectangle;


	/**
	 * 单元格控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Cell extends Label
	{

		/**
		 * 单元格控件，有文本及背景皮肤。
		 * 它即可以作为List, ComboBox, Grid等控件的单元格使用，也可以作为TitleBar来使用
		 * @param text 作为文本的字符串
		 * @param align 文本对齐方式，默认居中对齐
		 *
		 */
		public function Cell(text:String = null, align:int = 0x22)
		{
			super(text, true, align);
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
				paint();
			}
		}


		protected override function init():void
		{
			_style = GameUI.skinManager.getStyle(StyleDef.CELL);

			_skin = GameUI.skinManager.getSkin(SkinDef.CELL_BG);

			_padding = new Rectangle();
		}
	}
}
