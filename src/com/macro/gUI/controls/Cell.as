package com.macro.gUI.controls
{
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.geom.Point;
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
		 * @param text 作为文本的字符串
		 * @param skin 皮肤
		 * @param autosize 自动设置尺寸，默认为false
		 * @param align 文本对齐方式，默认居中对齐
		 *
		 */
		public function Cell(text:String = null, skin:ISkin = null, autoSize:Boolean = false, align:int = 0x22)
		{
			_style = _style ? _style : skinManager.getStyle(StyleDef.CELL);
			_skin = skin ? skin : skinManager.getSkin(SkinDef.CELL_BG);
			_padding = _padding ? _padding : new Rectangle();

			super(text, autoSize, align);
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
				update(false);
			}
		}


		public override function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(x, y);

			if (_skinDrawRect && _skinDrawRect.containsPoint(p))
			{
				return this;
			}

			if (_textDrawRect && _textDrawRect.containsPoint(p))
			{
				return this;
			}

			return null;
		}
	}
}
