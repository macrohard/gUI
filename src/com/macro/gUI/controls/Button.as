package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	public class Button extends LinkButton
	{

		protected var _skins:Dictionary;

		protected var _precise:Boolean;

		/**
		 * 按钮
		 * @param text 作为文本的字符串
		 * @param style 文本样式，如果为null，则使用StyleDef中的定义
		 * @param align 文本对齐方式，默认居中对齐
		 * @param skin 皮肤，如果为null，则使用SkinDef中的定义
		 *
		 */
		public function Button(text:String = null, style:TextStyle = null, align:int = 0x22, skin:ISkin = null)
		{
			_skin = skin;

			super(text, style, align);

			//如果未设置文本，那么父类Label不会产生进行绘制，
			//因此需要调用一下绘制接口，以便绘制按钮的皮肤
			if (!text || text.length == 0)
			{
				resize();
			}
		}

		override protected function init():void
		{
			_styles = new Dictionary();
			_styles[CtrlState.NORMAL] = _style ? _style : GameUI.skinManager.getStyle(StyleDef.BUTTON_NORMAL);
			_styles[CtrlState.OVER] = GameUI.skinManager.getStyle(StyleDef.BUTTON_OVER);
			_styles[CtrlState.DOWN] = GameUI.skinManager.getStyle(StyleDef.BUTTON_DOWN);
			_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.BUTTON_DISABLE);

			_skins = new Dictionary();
			_skins[CtrlState.NORMAL] = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.BUTTON_NORMAL);
			_skins[CtrlState.OVER] = GameUI.skinManager.getSkin(SkinDef.BUTTON_OVER);
			_skins[CtrlState.DOWN] = GameUI.skinManager.getSkin(SkinDef.BUTTON_DOWN);
			_skins[CtrlState.DISABLE] = GameUI.skinManager.getSkin(SkinDef.BUTTON_DISABLE);

			_skin = _skins[CtrlState.NORMAL];
			_style = _styles[CtrlState.NORMAL];

			_margin = new Rectangle(10);
		}


		/**
		 * 是否精确测试，如果为true，则按像素来判断HitTest，否则只考虑范围矩形。默认值是false
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
		
		override public function resize(width:int=0, height:int=0):void
		{
			if (_autoSize && _skin && (!text || text.length == 0))
			{
				width = _skin.minWidth;
				height = _skin.minHeight;
			}
			super.resize(width, height);
		}
		
		


		//=======================================================================
		// 样式定义


		public function get normalSkin():ISkin
		{
			return _skins[CtrlState.NORMAL];
		}

		public function set normalSkin(value:ISkin):void
		{
			if (_skin == _skins[CtrlState.NORMAL])
			{
				_skin = value;
				paint();
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
			if (_skin == _skins[CtrlState.DISABLE])
			{
				_skin = value;
				paint();
			}

			_skins[CtrlState.DISABLE] = value;
		}



		//====================================================================
		// 接口实现


		override public function hitTest(x:int, y:int):IControl
		{
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
			}
			return null;
		}

		override public function mouseDown():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_skin != _skins[CtrlState.DOWN] || _style != _styles[CtrlState.DOWN])
			{
				_skin = _skins[CtrlState.DOWN];
				_style = _styles[CtrlState.DOWN];
				drawText();
			}
		}

		override public function mouseOut():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_skin != _skins[CtrlState.NORMAL] || _style != _styles[CtrlState.NORMAL])
			{
				_skin = _skins[CtrlState.NORMAL];
				_style = _styles[CtrlState.NORMAL];
				drawText();
			}
		}

		override public function mouseOver():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_skin != _skins[CtrlState.OVER] || _style != _styles[CtrlState.OVER])
			{
				_skin = _skins[CtrlState.OVER];
				_style = _styles[CtrlState.OVER];
				drawText();
			}
		}

		override public function set enabled(value:Boolean):void
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
					_style = _styles[CtrlState.DISABLE];
				}
				drawText();
			}
		}
	}
}
