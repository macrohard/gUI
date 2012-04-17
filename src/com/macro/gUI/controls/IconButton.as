package com.macro.gUI.controls
{
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	import flash.display.BitmapData;
	import flash.utils.Dictionary;


	/**
	 * 图标按钮
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class IconButton extends Button
	{
		/**
		 * 图标按钮。默认自动设置尺寸
		 * @param text 作为文本的字符串
		 * @param alignText 文本对齐方式，默认右下角对齐
		 * @param alignIcon 图标对齐方式，默认居中对齐
		 *
		 */
		public function IconButton(text:String = null, alignText:int = 0x44, alignIcon:int = 0x22)
		{
			if (_styles == null)
			{
				_styles = new Dictionary();
				_styles[CtrlState.NORMAL] = skinManager.getStyle(StyleDef.ICONBUTTON);
				_styles[CtrlState.OVER] = _styles[CtrlState.DOWN] = _styles[CtrlState.NORMAL];
				_styles[CtrlState.DISABLE] = skinManager.getStyle(StyleDef.ICONBUTTON_DISABLE);
			}

			if (_skins == null)
			{
				_skins = new Dictionary();
				_skins[CtrlState.NORMAL] = skinManager.getSkin(SkinDef.ICONBUTTON_NORMAL);
				_skins[CtrlState.OVER] = skinManager.getSkin(SkinDef.ICONBUTTON_OVER);
				_skins[CtrlState.DOWN] = skinManager.getSkin(SkinDef.ICONBUTTON_DOWN);
				_skins[CtrlState.DISABLE] = skinManager.getSkin(SkinDef.ICONBUTTON_DISABLE);
			}

			_skin = _skin ? _skin : _skins[CtrlState.NORMAL];
			_style = _style ? _style : _styles[CtrlState.NORMAL];

			_padding = _padding ? _padding : new Margin(3, 3, 3, 3);
			_alignIcon = alignIcon;

			super(text, alignText);
		}


		private var _alignIcon:int;

		/**
		 * 图标对齐方式
		 * @return
		 *
		 */
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
				{
					resize();
				}
			}
		}


		private var _icon:BitmapData;

		/**
		 * 图标
		 * @return
		 *
		 */
		public function get icon():BitmapData
		{
			return _icon;
		}

		public function set icon(value:BitmapData):void
		{
			_icon = value;
			resize();
		}



		protected override function prePaint():void
		{
			if (_icon)
			{
				drawFixed(_bitmapData, _rect, _alignIcon, _icon);
			}
		}
	}
}
