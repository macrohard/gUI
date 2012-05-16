package com.macro.gUI.controls
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.skin.StyleDef;
	import com.macro.utils.StrUtil;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * 文本标签控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Label extends AbstractControl
	{

		/**
		 * 文本图像
		 */
		protected var _textImg:BitmapData;

		/**
		 * 文本图像区域
		 */
		protected var _textDrawRect:Rectangle;


		/**
		 * 文本标签控件，无皮肤定义
		 * @param text 用以显示的文本字符串
		 * @param autosize 自动设置尺寸，默认为true
		 * @param align 文本对齐方式，默认左上角对齐
		 *
		 */
		public function Label(text:String = null, autoSize:Boolean = true, align:int = 0x11)
		{
			//默认大小
			super(100, 20);

			_autoSize = autoSize;

			_align = align;

			_style = _style ? _style : skinMgr.getStyle(StyleDef.LABEL);

			_text = text;

			resize();
		}


		protected var _align:int;

		/**
		 * 文本对齐方式<br/>
		 * 请使用LayoutAlign枚举，可按如下方式设置左上角对齐：<br/>
		 * alignText = LayoutAlign.LEFT | LayoutAlign.TOP
		 */
		public function get align():int
		{
			return _align;
		}

		public function set align(value:int):void
		{
			if (_align != value)
			{
				_align = value;

				if (!_autoSize)
				{
					resize();
				}
			}
		}


		protected var _autoSize:Boolean;

		/**
		 * 自动根据文字内容设置控件宽高，如果是多行文本，则根据现有宽度来自动设置高度
		 * @return
		 *
		 */
		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			if (_autoSize != value)
			{
				_autoSize = value;
				if (_autoSize)
				{
					resize();
				}
			}
		}


		protected var _text:String;

		/**
		 * 作为当前文本的字符串
		 * @return
		 *
		 */
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if (_text != value)
			{
				_text = value;
				resize();
			}
		}


		protected var _displayAsPassword:Boolean;

		/**
		 * 显示为密码
		 * @return
		 *
		 */
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = value;
		}


		protected var _padding:Margin;

		/**
		 * 定义文本与四周的边距。
		 *
		 */
		public function get padding():Margin
		{
			return _padding;
		}

		public function set padding(value:Margin):void
		{
			_padding = value;
			resize();
		}


		protected var _style:TextStyle;

		/**
		 * 设置文本样式
		 * @return
		 *
		 */
		public function get style():TextStyle
		{
			return _style;
		}

		public function set style(value:TextStyle):void
		{
			_style = value;
			resize();
		}



		override public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));

			if (_textDrawRect && _textDrawRect.containsPoint(p))
			{
				return this;
			}
			return null;
		}


		/**
		 * 重设尺寸，且重建文本
		 * @param width
		 * @param height
		 *
		 */
		override public function resize(width:int = 0, height:int = 0):void
		{
			if (width == 0)
			{
				width = _width;
			}

			if (height == 0)
			{
				height = _height;
			}

			drawText(width);
			if (_autoSize && _textImg != null)
			{
				width = _padding ? _textImg.width + _padding.left + _padding.right : _textImg.width;
				height = _padding ? _textImg.height + _padding.top + _padding.bottom : _textImg.height;
			}

			super.resize(width, height);
		}


		override public function setDefaultSize():void
		{
			if (_textImg)
			{
				resize(_textImg.width, _textImg.height);
				return;
			}
			super.setDefaultSize();
		}


		override protected function postPaint():void
		{
			if (_textImg)
			{
				_textDrawRect = drawFixed(_bitmapData, _width, _height, _align, _textImg, _padding);
			}
		}



		private function drawText(w:int):void
		{
			var textWidth:int = _padding ? w - _padding.left - _padding.right : w;
			if (textWidth > 0)
			{
				_textImg = createTextImage(_text, _style, textWidth, _displayAsPassword);
			}
		}



		/**
		 * 创建文本图形
		 * @param text 作为图形的文本
		 * @param style 文本样式
		 * @param width 文本框宽度
		 * @param displayAsPassword 是否显示为密码
		 * @return
		 *
		 */
		protected static function createTextImage(text:String, style:TextStyle, width:int, displayAsPassword:Boolean):BitmapData
		{
			if (!text || text.length == 0 || !style)
			{
				return null;
			}

			if (!style.multiline)
			{
				text = StrUtil.trimLines(text);
			}

			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.displayAsPassword = displayAsPassword;
			tf.maxChars = style.maxChars;
			tf.filters = style.filters;
			tf.defaultTextFormat = style;
			tf.text = text;

			if (style.wordWrap && tf.width > width)
			{
				tf.wordWrap = true;
				tf.width = width;
			}

			var img:BitmapData = new BitmapData(tf.width, tf.height, true, 0);
			img.draw(tf, null, null, null, null, true);
			return img;
		}
	}
}
