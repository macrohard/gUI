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
	 * // TODO 应调用InteractiveManager的结束编辑接口，通过tab键获取焦点时，自动进入编辑状态
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TextInput extends Label implements IEdit, IFocus
	{

		protected var _skins:Dictionary;

		protected var _styles:Dictionary;


		private var _editBox:TextField;


		/**
		 * 文本输入框，支持背景皮肤定义，有常态及禁用态
		 * @param text 默认文本
		 * @param style 文本样式
		 * @param align 文本对齐方式，默认左中对齐
		 * @param skin 皮肤样式，如果为null，使用SkinDef中的定义
		 *
		 */
		public function TextInput(text:String = null, style:TextStyle = null, align:int = 0x21, skin:ISkin = null)
		{
			//默认可编辑
			_editable = true;

			_skin = skin;

			super(text, style, align);
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
				drawText();
			}
		}



		/**
		 * 设置文本样式
		 * @return
		 *
		 */
		public override function get normalStyle():TextStyle
		{
			return _styles[CtrlState.NORMAL];
		}

		public override function set normalStyle(value:TextStyle):void
		{
			if (!value)
			{
				return;
			}

			if (_style == _styles[CtrlState.NORMAL])
			{
				_style = value;
				drawText();
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
			if (!value)
			{
				return;
			}

			if (_style == _styles[CtrlState.DISABLE])
			{
				_style = value;
				drawText();
			}

			_styles[CtrlState.DISABLE] = value;
		}

		/**
		 * 设置普通皮肤样式
		 * @return
		 *
		 */
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
			if (_skin == _skins[CtrlState.DISABLE])
			{
				_skin = value;
				paint();
			}

			_skins[CtrlState.DISABLE] = value;
		}



		/**
		 * 初始化控件属性，子类可以在此方法中覆盖父类定义
		 *
		 */
		protected override function init():void
		{
			_autoSize = false;

			_styles = new Dictionary();
			_styles[CtrlState.NORMAL] = _style ? _style : GameUI.skinManager.getStyle(StyleDef.TEXTINPUT);
			_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.DISABLE);

			//背景皮肤
			_skins = new Dictionary();
			_skins[CtrlState.NORMAL] = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.TEXTINPUT_NORMAL);
			_skins[CtrlState.DISABLE] = GameUI.skinManager.getSkin(SkinDef.TEXTINPUT_DISABLE);

			_style = _styles[CtrlState.NORMAL];
			_skin = _skins[CtrlState.NORMAL];

			_padding = new Rectangle(10);
		}



		/**
		 * 开始编辑
		 * @return
		 *
		 */
		public function beginEdit():TextField
		{
			if (!_enabled)
			{
				return null;
			}

			if (_editBox)
			{
				return _editBox;
			}

			_textImg = null;
			paint();

			_editBox = new TextField();
			_editBox.autoSize = TextFieldAutoSize.LEFT;
			_editBox.displayAsPassword = _style.displayAsPassword;
			_editBox.maxChars = _style.maxChars;
			_editBox.filters = _style.filters;
			_editBox.defaultTextFormat = _style;
			_editBox.text = _text;

			_editBox.addEventListener(Event.CHANGE, onTextChange);
			relocateEditBox();

			if (_editable)
			{
				_editBox.type = TextFieldType.INPUT;
			}

			return _editBox;
		}

		/**
		 * 结束编辑
		 *
		 */
		public function endEdit():void
		{
			if (_editBox)
			{
				_text = _editBox.text;
				drawText();

				_editBox.removeEventListener(Event.CHANGE, onTextChange);
				_editBox = null;
			}
		}

		private function onTextChange(e:Event):void
		{
			relocateEditBox();
		}

		/**
		 * 重新定位编辑框
		 *
		 */
		private function relocateEditBox():void
		{
			if (!_editBox)
			{
				return;
			}

			var txtW:int = _editBox.textWidth + 4 + _style.leftMargin + _style.rightMargin + _style.indent + _style.blockIndent;
			var txtH:int = _editBox.textHeight + 4;

			var w:int = getTextWidth();
			var h:int = getTextHeight();

			if (txtW > w)
			{
				_editBox.autoSize = TextFieldAutoSize.NONE;
				_editBox.multiline = _style.multiline;
				_editBox.wordWrap = _style.wordWrap;
				txtW = w;
				_editBox.width = txtW + 2;
				txtH = _editBox.textHeight + 4;
			}
			else
			{
				_editBox.autoSize = TextFieldAutoSize.LEFT;
			}

			var p:Point = this.globalCoord();

			var ox:int = p.x + (_padding ? _padding.left : 0);
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox += (w - txtW) >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox += w - txtW;
			}

			var oy:int = p.y + (_padding ? _padding.top : 0);
			if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy += (h - txtH) >> 1;
			}
			else if ((_align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy += h - txtH;
			}

			_editBox.x = ox;
			_editBox.y = oy;
		}
	}
}
