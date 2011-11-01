package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	import com.macro.gUI.skin.impl.BitmapSkin;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	public class IconButton extends Button
	{

		private var _icon:BitmapData;
		
		private var _alignIcon:int;
		
		

		/**
		 * 图标按钮
		 * @param text 作为文本的字符串
		 * @param style 文本样式，如果为null，则使用StyleDef中的定义
		 * @param alignText 文本对齐方式，默认右下角对齐
		 * @param skin 皮肤，如果为null，则使用SkinDef中的定义
		 * @param alignIcon 图标对齐方式，默认居中对齐
		 * 
		 */
		public function IconButton(text:String = null, style:TextStyle = null, alignText:int = 0x44, skin:ISkin = null, alignIcon:int = 0x22)
		{
			_alignIcon = alignIcon;
			super(text, style, alignText, skin);
		}

		override protected function init():void
		{
			_styles = new Dictionary();
			_styles[CtrlState.NORMAL] = _style ? _style : GameUI.skinManager.getStyle(StyleDef.ICONBUTTON);
			_styles[CtrlState.OVER] = _styles[CtrlState.DOWN] = _styles[CtrlState.NORMAL];
			_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.ICONBUTTON_DISABLE);
			
			_skins = new Dictionary();
			_skins[CtrlState.NORMAL] = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.ICONBUTTON_NORMAL);
			_skins[CtrlState.OVER] = GameUI.skinManager.getSkin(SkinDef.ICONBUTTON_OVER);
			_skins[CtrlState.DOWN] = GameUI.skinManager.getSkin(SkinDef.ICONBUTTON_DOWN);
			_skins[CtrlState.DISABLE] = GameUI.skinManager.getSkin(SkinDef.ICONBUTTON_DISABLE);

			
			_skin = _skins[CtrlState.NORMAL];
			_style = _styles[CtrlState.NORMAL];
			
			_margin = new Rectangle(3, 3);
		}
		
		
		public function get alignIcon():int
		{
			return _alignIcon;
		}
		
		public function set alignIcon(value:int):void
		{
			if (_alignIcon != value)
			{
				_alignIcon = value;
				
				if (!_autoSize)
					paint();
			}
		}

		/**
		 * 图标
		 * @param icon
		 *
		 */
		public function get icon():BitmapData
		{
			return _icon;
		}

		public function set icon(value:BitmapData):void
		{
			_icon = value;
			if (_autoSize)
				resize();
			else
				paint();
		}

		override protected function prePaint():void
		{
			if (_icon)
				drawFixed(_bitmapData, _rect, _alignIcon, _icon);
		}


	}
}
