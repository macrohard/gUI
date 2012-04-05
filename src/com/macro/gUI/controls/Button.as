package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	/**
	 * 按钮
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Button extends LinkButton
	{

		protected var _skins:Dictionary;

		/**
		 * 按钮
		 * @param text 作为文本的字符串
		 * @param align 文本对齐方式，默认居中对齐
		 *
		 */
		public function Button(text:String = null, align:int = 0x22)
		{
			if (_styles == null)
			{
				_styles = new Dictionary();
				_styles[CtrlState.NORMAL] = GameUI.skinManager.getStyle(StyleDef.BUTTON_NORMAL);
				_styles[CtrlState.OVER] = GameUI.skinManager.getStyle(StyleDef.BUTTON_OVER);
				_styles[CtrlState.DOWN] = GameUI.skinManager.getStyle(StyleDef.BUTTON_DOWN);
				_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.BUTTON_DISABLE);
			}
			
			if (_skins == null)
			{
				_skins = new Dictionary();
				_skins[CtrlState.NORMAL] = GameUI.skinManager.getSkin(SkinDef.BUTTON_NORMAL);
				_skins[CtrlState.OVER] = GameUI.skinManager.getSkin(SkinDef.BUTTON_OVER);
				_skins[CtrlState.DOWN] = GameUI.skinManager.getSkin(SkinDef.BUTTON_DOWN);
				_skins[CtrlState.DISABLE] = GameUI.skinManager.getSkin(SkinDef.BUTTON_DISABLE);
			}
			
			_skin = _skin ? _skin : _skins[CtrlState.NORMAL];
			_style = _style ? _style : _styles[CtrlState.NORMAL];
			
			_padding = _padding ? _padding : new Rectangle(10);
			
			super(text, align);
		}


		protected var _precise:Boolean;

		/**
		 * 是否精确测试，如果为true，则按像素来判断，否则只考虑范围矩形。默认值是false
		 * @return
		 *
		 */
		public function get precise():Boolean
		{
			return _precise;
		}

		public function set precise(value:Boolean):void
		{
			_precise = value;
		}


		public override function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				if (_enabled)
				{
					_skin = _skins[CtrlState.NORMAL];
					_style = _styles[CtrlState.NORMAL];
				}
				else
				{
					_skin = _skins[CtrlState.DISABLE];
					_skin = _skin ? _skin : _skins[CtrlState.NORMAL];
					_style = _styles[CtrlState.DISABLE];
				}
				
				update(true);
			}
		}


		public function get skin():ISkin
		{
			return _skins[CtrlState.NORMAL];
		}

		public function set skin(value:ISkin):void
		{
			if (_skins[CtrlState.NORMAL] == value)
			{
				return;
			}
			
			if (_skin == _skins[CtrlState.NORMAL])
			{
				_skin = value;
				update(false);
			}

			_skins[CtrlState.NORMAL] = value;
		}

		public function get overSkin():ISkin
		{
			return _skins[CtrlState.OVER];
		}

		public function set overSkin(value:ISkin):void
		{
			_skins[CtrlState.OVER] = value;
		}

		public function get downSkin():ISkin
		{
			return _skins[CtrlState.DOWN];
		}

		public function set downSkin(value:ISkin):void
		{
			_skins[CtrlState.DOWN] = value;
		}

		public function get disableSkin():ISkin
		{
			return _skins[CtrlState.DISABLE];
		}

		public function set disableSkin(value:ISkin):void
		{
			if (_skins[CtrlState.DISABLE] == value)
			{
				return;
			}
			
			if (_skin == _skins[CtrlState.DISABLE])
			{
				_skin = value;
				update(false);
			}

			_skins[CtrlState.DISABLE] = value;
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize && _skin && (text == null || text.length == 0))
			{
				width = _skin.minWidth;
				height = _skin.minHeight;
			}
			super.resize(width, height);
		}


		public override function hitTest(x:int, y:int):IControl
		{
			var p:Point = this.globalCoord();
			x -= p.x;
			y -= p.y;

			if (_precise)
			{
				if (_bitmapData.getPixel32(x, y) != 0)
				{
					return this;
				}
			}
			else
			{
				if (_skinDrawRect && _skinDrawRect.contains(x, y))
				{
					return this;
				}
				
				if (_textDrawRect && _textDrawRect.contains(x, y))
				{
					return this;
				}
			}
			return null;
		}


		public override function mouseDown():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_skin != _skins[CtrlState.DOWN] || _style != _styles[CtrlState.DOWN])
			{
				_skin = _skins[CtrlState.DOWN];
				_skin = _skin ? _skin : _skins[CtrlState.NORMAL];
				_style = _styles[CtrlState.DOWN];
				update(true);
			}
		}

		public override function mouseOut():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_skin != _skins[CtrlState.NORMAL] || _style != _styles[CtrlState.NORMAL])
			{
				_skin = _skins[CtrlState.NORMAL];
				_style = _styles[CtrlState.NORMAL];
				update(true);
			}
		}

		public override function mouseOver():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_skin != _skins[CtrlState.OVER] || _style != _styles[CtrlState.OVER])
			{
				_skin = _skins[CtrlState.OVER];
				_skin = _skin ? _skin : _skins[CtrlState.NORMAL];
				_style = _styles[CtrlState.OVER];
				update(true);
			}
		}
	}
}
