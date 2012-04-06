package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IEdit;
	import com.macro.gUI.base.feature.IFocus;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;


	/**
	 * 文本输入框
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TextInput extends Label implements IEdit, IFocus
	{

		protected var _skins:Dictionary;

		protected var _styles:Dictionary;


		private var _editBox:TextField;


		/**
		 * 文本输入框，支持背景皮肤定义，有常态及禁用态<br/>
		 * 默认关闭自动设置尺寸
		 * @param text 默认文本
		 * @param align 文本对齐方式，默认左中对齐
		 *
		 */
		public function TextInput(text:String = null, align:int = 0x21)
		{
			//默认可编辑
			_editable = true;

			if (_style == null)
			{
				_styles = new Dictionary();
				_styles[CtrlState.NORMAL] = GameUI.skinManager.getStyle(StyleDef.TEXTINPUT);
				_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.DISABLE);
			}

			//背景皮肤
			if (_skins == null)
			{
				_skins = new Dictionary();
				_skins[CtrlState.NORMAL] = GameUI.skinManager.getSkin(SkinDef.TEXTINPUT_NORMAL);
				_skins[CtrlState.DISABLE] = GameUI.skinManager.getSkin(SkinDef.TEXTINPUT_DISABLE);
			}

			_style = _style ? _style : _styles[CtrlState.NORMAL];
			_skin = _skin ? _skin : _skins[CtrlState.NORMAL];

			_padding = _padding ? _padding : new Rectangle(10, 0 - 10);

			super(text, false, align);
		}


		private var _editable:Boolean;

		/**
		 * 是否可编辑
		 * @return
		 *
		 */
		public function get editable():Boolean
		{
			return _editable;
		}

		public function set editable(value:Boolean):void
		{
			_editable = value;
		}



		private var _tabIndex:int;

		public function get tabIndex():int
		{
			return _tabIndex;
		}

		public function set tabIndex(value:int):void
		{
			_tabIndex = value;
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



		/**
		 * 设置文本样式
		 * @return
		 *
		 */
		public override function get style():TextStyle
		{
			return _styles[CtrlState.NORMAL];
		}

		public override function set style(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.NORMAL])
			{
				_style = value;
				update(true);
			}

			_styles[CtrlState.NORMAL] = value;
		}

		/**
		 * 设置禁用文本样式
		 * @return
		 *
		 */
		public function get disableStyle():TextStyle
		{
			return _styles[CtrlState.DISABLE];
		}

		public function set disableStyle(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.DISABLE])
			{
				_style = value;
				update(true);
			}

			_styles[CtrlState.DISABLE] = value;
		}

		/**
		 * 设置皮肤样式
		 * @return
		 *
		 */
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

		/**
		 * 设置禁用皮肤样式
		 * @return
		 *
		 */
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



		/**
		 * 开始编辑
		 * @return
		 *
		 */
		public function beginEdit():void
		{
			_text = null;
			_textImg = null;
			paint();
		}
	}
}
