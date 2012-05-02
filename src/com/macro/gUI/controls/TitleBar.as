package com.macro.gUI.controls
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	import flash.geom.Point;


	/**
	 * 标题条控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TitleBar extends Label
	{

		/**
		 * 标题条控件，有文本及背景皮肤。
		 * @param text 作为文本的字符串
		 * @param skin 皮肤
		 * @param autosize 自动设置尺寸，默认为false
		 * @param align 文本对齐方式，默认居中对齐
		 *
		 */
		public function TitleBar(text:String = null, skin:ISkin = null, autoSize:Boolean = false, align:int = 0x22)
		{
			_style = _style ? _style : skinManager.getStyle(StyleDef.TITLEBAR);
			_skin = skin ? skin : skinManager.getSkin(SkinDef.TITLEBAR_BG);
			_padding = _padding ? _padding : new Margin(5, 0, 5, 0);

			super(text, autoSize, align);
		}


		/**
		 * 皮肤
		 * @return
		 *
		 */
		public function get bgSkin():ISkin
		{
			return _skin;
		}

		public function set bgSkin(value:ISkin):void
		{
			if (_skin != value)
			{
				_skin = value;
				resize();
			}
		}


		override public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));

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
