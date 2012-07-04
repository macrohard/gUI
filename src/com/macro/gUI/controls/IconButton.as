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
		public static const ICON_ON_SKIN:int = 0;
		
		public static const ICON_UNDER_SKIN:int = 1;
		
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
				_styles[CtrlState.UP] = skinMgr.getStyle(StyleDef.ICONBUTTON);
				_styles[CtrlState.OVER] = _styles[CtrlState.DOWN] = _styles[CtrlState.UP];
				_styles[CtrlState.DISABLE] = skinMgr.getStyle(StyleDef.ICONBUTTON_DISABLE);
			}

			if (_skins == null)
			{
				_skins = new Dictionary();
				_skins[CtrlState.UP] = skinMgr.getSkin(SkinDef.ICONBUTTON);
				_skins[CtrlState.OVER] = skinMgr.getSkin(SkinDef.ICONBUTTON_OVER);
				_skins[CtrlState.DOWN] = skinMgr.getSkin(SkinDef.ICONBUTTON_DOWN);
				_skins[CtrlState.DISABLE] = skinMgr.getSkin(SkinDef.ICONBUTTON_DISABLE);
			}

			_skin = _skin ? _skin : _skins[CtrlState.UP];
			_style = _style ? _style : _styles[CtrlState.UP];

			_padding = _padding ? _padding : new Margin(3, 3, 3, 3);
			_alignIcon = alignIcon;
			_iconLayer = ICON_ON_SKIN;
			
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
		
		
		private var _iconLayer:int;
		
		/**
		 * 图标层次，ICON_ON_SKIN或ICON_UNDER_SKIN
		 * @return 
		 * 
		 */
		public function get iconLayer():int
		{
			return _iconLayer;
		}
		
		public function set iconLayer(value:int):void
		{
			_iconLayer = value;
			resize();
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



		override protected function prePaint():void
		{
			if (_icon && _iconLayer == ICON_UNDER_SKIN)
			{
				drawFixed(_bitmapData, _width, _height, _alignIcon, _icon, _padding);
			}
		}
		
		override protected function postPaint():void
		{
			if (_icon && _iconLayer == ICON_ON_SKIN)
			{
				drawFixed(_bitmapData, _width, _height, _alignIcon, _icon, _padding);
			}
		}
	}
}
