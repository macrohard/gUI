package com.macro.gUI.controls
{
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.events.TextInputEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;


	/**
	 * 文本输入框
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TextInput extends Label implements IEdit
	{

		/**
		 * 两态皮肤
		 */
		protected var _skins:Dictionary;

		/**
		 * 两态样式
		 */
		protected var _styles:Dictionary;


		/**
		 * 输入框
		 */
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
				_styles[CtrlState.UP] = skinManager.getStyle(StyleDef.TEXTINPUT);
				_styles[CtrlState.DISABLE] = skinManager.getStyle(StyleDef.TEXTINPUT_DISABLE);
			}

			//背景皮肤
			if (_skins == null)
			{
				_skins = new Dictionary();
				_skins[CtrlState.UP] = skinManager.getSkin(SkinDef.TEXTINPUT_BG);
				_skins[CtrlState.DISABLE] = skinManager.getSkin(SkinDef.TEXTINPUT_BG_DISABLE);
			}

			_style = _style ? _style : _styles[CtrlState.UP];
			_skin = _skin ? _skin : _skins[CtrlState.UP];

			_padding = _padding ? _padding : new Margin(10, 0, 5, 0);

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


		override public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				if (_enabled)
				{
					_skin = _skins[CtrlState.UP];
					_style = _styles[CtrlState.UP];
				}
				else
				{
					_skin = _skins[CtrlState.DISABLE];
					_skin = _skin ? _skin : _skins[CtrlState.UP];
					_style = _styles[CtrlState.DISABLE];
				}
				resize();
			}
		}



		/**
		 * 设置文本样式
		 * @return
		 *
		 */
		override public function get style():TextStyle
		{
			return _styles[CtrlState.UP];
		}

		override public function set style(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.UP])
			{
				_style = value;
				resize();
			}

			_styles[CtrlState.UP] = value;
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
				resize();
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
			return _skins[CtrlState.UP];
		}

		public function set skin(value:ISkin):void
		{
			if (_skins[CtrlState.UP] == value)
			{
				return;
			}

			if (_skin == _skins[CtrlState.UP])
			{
				_skin = value;
				resize();
			}

			_skins[CtrlState.UP] = value;
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
				resize();
			}

			_skins[CtrlState.DISABLE] = value;
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



		public function beginEdit():TextField
		{
			dispatchEvent(new TextInputEvent(TextInputEvent.EDIT_BEGIN));
			
			_editBox = new TextField();
			_editBox.autoSize = TextFieldAutoSize.LEFT;
			_editBox.displayAsPassword = _displayAsPassword;
			_editBox.maxChars = _style.maxChars;
			_editBox.filters = _style.filters;
			_editBox.defaultTextFormat = _style;
			if (_text != null)
			{
				_editBox.text = _text;
			}
			if (_editable)
			{
				_editBox.type = TextFieldType.INPUT;
			}
			relocateEditBox(null);
			
			_editBox.addEventListener(Event.CHANGE, relocateEditBox, false, 0, true);
			
			// 清除现有文本
			_text = null;
			_textImg = null;
			resize();
			
			return _editBox;
		}
		
		
		public function endEdit(value:String):void
		{
			_editBox.removeEventListener(Event.CHANGE, relocateEditBox);
			_editBox = null;
			
			_text = value;
			resize();
			
			dispatchEvent(new TextInputEvent(TextInputEvent.EDIT_FINISH));
		}
		
		
		/**
		 * 重新定位编辑框
		 *
		 */
		private function relocateEditBox(e:Event):void
		{
			var txtW:int = _editBox.textWidth + 4 + _style.leftMargin + _style.rightMargin + _style.indent + _style.blockIndent;
			var txtH:int = _editBox.textHeight + 4;
			
			var w:int = _padding ? _width - _padding.left - _padding.right : _width;
			var h:int = _padding ? _height - _padding.top - _padding.bottom : _height;
			
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
			
			var p:Point = localToGlobal();
			
			var ox:int = p.x + (_padding ? _padding.left : 0);
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox += w - txtW >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox += w - txtW;
			}
			
			var oy:int = p.y + (_padding ? _padding.top : 0);
			if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy += h - txtH >> 1;
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
