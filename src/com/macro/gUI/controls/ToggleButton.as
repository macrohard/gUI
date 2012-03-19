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


	public class ToggleButton extends Button
	{

		protected var _selected:Boolean;


		/**
		 * 切换按钮
		 * @param text 作为文本的字符串
		 * @param style 文本样式，如果为null，则使用StyleDef中的定义
		 * @param align 文本对齐方式，默认居中对齐
		 * @param skin 皮肤，如果为null，则使用SkinDef中的定义
		 *
		 */
		public function ToggleButton(text:String = null, style:TextStyle = null, align:int = 0x22, skin:ISkin = null)
		{
			super(text, style, align, skin);
		}

		protected override function init():void
		{
			_styles = new Dictionary();
			_styles[CtrlState.NORMAL] = _style ? _style : GameUI.skinManager.getStyle(StyleDef.BUTTON_NORMAL);
			_styles[CtrlState.OVER] = GameUI.skinManager.getStyle(StyleDef.BUTTON_OVER);
			_styles[CtrlState.DOWN] = GameUI.skinManager.getStyle(StyleDef.BUTTON_DOWN);
			_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.BUTTON_DISABLE);
			_styles[CtrlState.SELECTED] = GameUI.skinManager.getStyle(StyleDef.TOGGLEBUTTON_SELECTED);
			_styles[CtrlState.SELECTED_OVER] = GameUI.skinManager.getStyle(StyleDef.TOGGLEBUTTON_SELECTED_OVER);
			_styles[CtrlState.SELECTED_DOWN] = GameUI.skinManager.getStyle(StyleDef.TOGGLEBUTTON_SELECTED_DOWN);
			_styles[CtrlState.SELECTED_DISABLE] = GameUI.skinManager.getStyle(StyleDef.TOGGLEBUTTON_SELECTED_DISABLE);

			_skins = new Dictionary();
			_skins[CtrlState.NORMAL] = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_NORMAL);
			_skins[CtrlState.OVER] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_OVER);
			_skins[CtrlState.DOWN] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_DOWN);
			_skins[CtrlState.DISABLE] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_DISABLE);
			_skins[CtrlState.SELECTED] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_SELECTED);
			_skins[CtrlState.SELECTED_OVER] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_SELECTED_OVER);
			_skins[CtrlState.SELECTED_DOWN] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_SELECTED_DOWN);
			_skins[CtrlState.SELECTED_DISABLE] = GameUI.skinManager.getSkin(SkinDef.TOGGLEBUTTON_SELECTED_DISABLE);

			_skin = _skins[CtrlState.NORMAL];
			_style = _styles[CtrlState.NORMAL];

			_margin = new Rectangle(10);
		}


		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				_selected = value;
				mouseOut();
			}
		}


		//========================================================================
		// 样式定义

		public function get selectedStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED];
		}

		public function set selectedStyle(value:TextStyle):void
		{
			if (!value)
			{
				return;
			}

			if (_style == _styles[CtrlState.SELECTED])
			{
				_style = value;
				drawText();
			}

			_styles[CtrlState.SELECTED] = value;
		}

		public function get selectedOverStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED_OVER];
		}

		public function set selectedOverStyle(value:TextStyle):void
		{
			_styles[CtrlState.SELECTED_OVER] = value;
		}

		public function get selectedDownStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED_DOWN];
		}

		public function set selectedDownStyle(value:TextStyle):void
		{
			_styles[CtrlState.SELECTED_DOWN] = value;
		}

		public function get selectedDisableStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED_DISABLE];
		}

		public function set selectedDisableStyle(value:TextStyle):void
		{
			if (!value)
			{
				return;
			}

			if (_style == _styles[CtrlState.SELECTED_DISABLE])
			{
				_style = value;
				drawText();
			}

			_styles[CtrlState.SELECTED_DISABLE] = value;
		}



		public function get selectedSkin():ISkin
		{
			return _skins[CtrlState.SELECTED];
		}

		public function set selectedSkin(value:ISkin):void
		{
			if (_skin == _skins[CtrlState.SELECTED])
			{
				_skin = value;
				paint();
			}

			_skins[CtrlState.SELECTED] = value;
		}

		public function get selectedOverSkin():ISkin
		{
			return _skins[CtrlState.SELECTED_OVER];
		}

		public function set selectedOverSkin(value:ISkin):void
		{
			_skins[CtrlState.SELECTED_OVER] = value;
		}

		public function get selectedDownSkin():ISkin
		{
			return _skins[CtrlState.SELECTED_DOWN];
		}

		public function set selectedDownSkin(value:ISkin):void
		{
			_skins[CtrlState.SELECTED_DOWN] = value;
		}

		public function get selectedDisableSkin():ISkin
		{
			return _skins[CtrlState.SELECTED_DISABLE];
		}

		public function set selectedDisableSkin(value:ISkin):void
		{
			if (_skin == _skins[CtrlState.SELECTED_DISABLE])
			{
				_skin = value;
				paint();
			}

			_skins[CtrlState.SELECTED_DISABLE] = value;
		}





		//=========================================================================
		// 接口实现


		public override function mouseDown():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED_DOWN] && _style == _styles[CtrlState.SELECTED_DOWN])
				{
					return;
				}

				_skin = _skins[CtrlState.SELECTED_DOWN];
				_style = _styles[CtrlState.SELECTED_DOWN];
			}
			else
			{
				if (_skin == _skins[CtrlState.DOWN] && _style == _styles[CtrlState.DOWN])
				{
					return;
				}

				_skin = _skins[CtrlState.DOWN];
				_style = _styles[CtrlState.DOWN];
			}
			drawText();
		}

		public override function mouseOut():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED] && _style == _styles[CtrlState.SELECTED])
				{
					return;
				}

				_skin = _skins[CtrlState.SELECTED];
				_style = _styles[CtrlState.SELECTED];
			}
			else
			{
				if (_skin == _skins[CtrlState.NORMAL] && _style == _styles[CtrlState.NORMAL])
				{
					return;
				}

				_skin = _skins[CtrlState.NORMAL];
				_style = _styles[CtrlState.NORMAL];
			}
			drawText();
		}

		public override function mouseOver():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED_OVER] && _style == _styles[CtrlState.SELECTED_OVER])
				{
					return;
				}

				_skin = _skins[CtrlState.SELECTED_OVER];
				_style = _styles[CtrlState.SELECTED_OVER];
			}
			else
			{
				if (_skin == _skins[CtrlState.OVER] && _style == _styles[CtrlState.OVER])
				{
					return;
				}

				_skin = _skins[CtrlState.OVER];
				_style = _styles[CtrlState.OVER];
			}
			drawText();
		}

		public override function mouseUp():void
		{
			if (!_enabled)
			{
				return;
			}

			_selected = !_selected;
			mouseOver();
		}


		public override function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				if (_enabled)
				{
					if (_selected)
					{
						_skin = _skins[CtrlState.SELECTED];
						_style = _styles[CtrlState.SELECTED];
					}
					else
					{
						_skin = _skins[CtrlState.NORMAL];
						_style = _styles[CtrlState.NORMAL];
					}
				}
				else
				{
					if (_selected)
					{
						_skin = _skins[CtrlState.SELECTED_DISABLE];
						_style = _styles[CtrlState.SELECTED_DISABLE];
					}
					else
					{
						_skin = _skins[CtrlState.DISABLE];
						_style = _styles[CtrlState.DISABLE];
					}
				}
				drawText();
			}
		}



	}
}
