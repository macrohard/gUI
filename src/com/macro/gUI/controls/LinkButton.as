package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IFocus;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;


	/**
	 * 链接按钮
	 * @author macro776@gmail.com
	 *
	 */
	public class LinkButton extends Label implements IButton, IFocus
	{

		protected var _styles:Dictionary;

		/**
		 * 链接按钮，支持四态样式定义
		 * @param text 作为文本的字符串
		 * @param style 文本样式，如果为null，则使用StyleDef中的定义
		 * @param align 文本对齐方式，默认左上角对齐
		 *
		 */
		public function LinkButton(text:String = null, style:TextStyle = null, align:int = 0x11)
		{
			//默认控件可用
			_enabled = true;

			_style = style;

			super(text, style, align);
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
		
		
		protected var _enabled:Boolean;
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
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
				
				drawText();
			}
		}
		
		
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
		
		public function get overStyle():TextStyle
		{
			return _styles[CtrlState.OVER];
		}
		
		public function set overStyle(value:TextStyle):void
		{
			if (value)
			{
				_styles[CtrlState.OVER] = value;
			}
		}
		
		public function get downStyle():TextStyle
		{
			return _styles[CtrlState.DOWN];
		}
		
		public function set downStyle(value:TextStyle):void
		{
			if (value)
			{
				_styles[CtrlState.DOWN] = value;
			}
		}
		
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
		
		
		

		protected override function init():void
		{
			_styles = new Dictionary();
			_styles[CtrlState.NORMAL] = _style ? _style : GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_NORMAL);
			_styles[CtrlState.OVER] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_OVER);
			_styles[CtrlState.DOWN] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_DOWN);
			_styles[CtrlState.DISABLE] = GameUI.skinManager.getStyle(StyleDef.LINKBUTTON_DISABLE);

			_style = _styles[CtrlState.NORMAL];
		}


		public function hitTest(x:int, y:int):IControl
		{
			var p:Point = this.globalCoord();
			x -= p.x;
			y -= p.y;
			
			if (_textDrawRect && _textDrawRect.contains(x, y))
			{
				return this;
			}
			return null;
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
				drawText();
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
				drawText();
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
				drawText();
			}
		}
	}
}
