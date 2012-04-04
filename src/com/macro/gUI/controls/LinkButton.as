package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IKeyboard;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;


	/**
	 * 文本链接按钮
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class LinkButton extends Label implements IButton, IKeyboard
	{

		protected var _styles:Dictionary;

		/**
		 * 文本链接按钮，支持四态样式定义，
		 * @param text 作为文本的字符串
		 * @param align 文本对齐方式，默认左上角对齐
		 *
		 */
		public function LinkButton(text:String = null, align:int = 0x11)
		{
			if (_styles == null)
			{
				_styles = new Dictionary();
				_styles[CtrlState.NORMAL] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_NORMAL);
				_styles[CtrlState.OVER] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_OVER);
				_styles[CtrlState.DOWN] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_DOWN);
				_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_DISABLE);
			}
			
			_style = _style ? _style : _styles[CtrlState.NORMAL];
			
			super(text, true, align);
		}


		protected var _tabIndex:int;

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
					_style = _styles[CtrlState.NORMAL];
				}
				else
				{
					_style = _styles[CtrlState.DISABLE];
				}

				autoResize();
			}
		}


		public override function get style():TextStyle
		{
			return _styles[CtrlState.NORMAL];
		}

		public override function set style(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.NORMAL])
			{
				_style = value;
				autoResize();
			}

			_styles[CtrlState.NORMAL] = value;
		}

		public function get overStyle():TextStyle
		{
			return _styles[CtrlState.OVER];
		}

		public function set overStyle(value:TextStyle):void
		{
			_styles[CtrlState.OVER] = value;
		}

		public function get downStyle():TextStyle
		{
			return _styles[CtrlState.DOWN];
		}

		public function set downStyle(value:TextStyle):void
		{
			_styles[CtrlState.DOWN] = value;
		}

		public function get disableStyle():TextStyle
		{
			return _styles[CtrlState.DISABLE];
		}

		public function set disableStyle(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.DISABLE])
			{
				_style = value;
				autoResize();
			}

			_styles[CtrlState.DISABLE] = value;
		}



		public function mouseDown():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_style != _styles[CtrlState.DOWN])
			{
				_style = _styles[CtrlState.DOWN];
				autoResize();
			}
		}

		public function mouseUp():void
		{
			mouseOver();
		}

		public function mouseOver():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_style != _styles[CtrlState.OVER])
			{
				_style = _styles[CtrlState.OVER];
				autoResize();
			}
		}

		public function mouseOut():void
		{
			if (!_enabled)
			{
				return;
			}

			if (_style != _styles[CtrlState.NORMAL])
			{
				_style = _styles[CtrlState.NORMAL];
				autoResize();
			}
		}


		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				mouseDown();
			}
		}

		public function keyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				mouseUp();
			}
		}
	}
}
