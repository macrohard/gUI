package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.geom.Rectangle;
	
	public class TitleBar extends Label
	{
		
		/**
		 * 标题控件，有背景皮肤定义
		 * @param text 作为文本的字符串
		 * @param style 文本样式
		 * @param align 文本对齐方式
		 * @param skin 背景皮肤
		 * 
		 */
		public function TitleBar(text:String=null, style:TextStyle=null, align:int=0x22, skin:ISkin = null)
		{
			_skin = skin;
			
			super(text, style, align);
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
			resize(_rect.width, _rect.height);
		}
		
		
		protected override function init():void
		{
			_style = _style ? _style : GameUI.skinManager.getStyle(StyleDef.TITLE);
			
			_skin = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.TITLE_BG);
			
			_margin = new Rectangle(20);
		}
	}
}