package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.AbstractControl;
	import com.macro.gUI.base.IControl;
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
		 * 是否重绘文本
		 */
		private var _rebuildTextImg:Boolean;



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

			//默认自动设置尺寸
			_autoSize = autoSize;

			_align = align;

			_style = _style ? _style : GameUI.skinManager.getStyle(StyleDef.NORMAL);

			_text = text;
			
			drawText();
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
					paint();
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
					drawText();
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
			if (value != null && value.length > 0 && _text != value)
			{
				_text = value;
				drawText();
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


		protected var _padding:Rectangle;

		/**
		 * 定义文本与四周的边距。注意，将使用left, top, right, bottom定义。 为赋值简便，可以使用如下语法：<br/>
		 * new Rectangle(5, 8, 12 - 5, 5 - 8)<br/>
		 * 此定义为：左间距为5，上间距为8，右间距为12，下间距为5
		 * @param rebuild
		 *
		 */
		public function get padding():Rectangle
		{
			return _padding;
		}

		public function set padding(value:Rectangle):void
		{
			_padding = value;
			if (_autoSize)
			{
				resize();
			}
			else
			{
				paint();
			}
		}


		protected var _style:TextStyle;

		/**
		 * 设置文本样式
		 * @return
		 *
		 */
		public function get normalStyle():TextStyle
		{
			return _style;
		}

		public function set normalStyle(value:TextStyle):void
		{
			_style = value;
			drawText();
		}



		public override function hitTest(x:int, y:int):IControl
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


		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize && _textImg)
			{
				width = _textImg.width + (_padding ? _padding.left + _padding.right : 0);
				height = _textImg.height + (_padding ? _padding.top + _padding.bottom : 0);
			}
			else if (_style.wordWrap)
			{
				_rebuildTextImg = true;
			}

			super.resize(width, height);
		}


		public override function setDefaultSize():void
		{
			if (_textImg)
			{
				resize(_textImg.width, _textImg.height);
				return;
			}
			super.setDefaultSize();
		}


		protected override function postPaint():void
		{
			if (!_autoSize && _rebuildTextImg)
			{
				_textImg = createTextImage(_text, _style, getTextWidth(), _autoSize, _displayAsPassword);
			}
			_rebuildTextImg = false;

			if (_textImg)
			{
				_textDrawRect = drawFixed(_bitmapData, _rect, _align, _textImg, _padding);
			}
		}


		/**
		 * 绘制文本
		 *
		 */
		protected function drawText():void
		{
			if (_autoSize)
			{
				_textImg = createTextImage(_text, _style, getTextWidth(), _autoSize, _displayAsPassword);
				resize();
			}
			else
			{
				_rebuildTextImg = true;
				paint();
			}
		}


		private function getTextWidth():int
		{
			if (_padding)
			{
				return _rect.width - _padding.left - _padding.right;
			}
			return _rect.width;
		}



		/**
		 * 创建文本图形
		 * @param text 作为图形的文本
		 * @param style 文本样式
		 * @param width 文本框宽度
		 * @param autoSize 根据文本自动设置尺寸
		 * @return
		 *
		 */
		protected static function createTextImage(text:String, style:TextStyle, width:int,
												  autoSize:Boolean, displayAsPassword:Boolean):BitmapData
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

			if (!autoSize && tf.width > width)
			{
				tf.wordWrap = style.wordWrap;
				tf.width = width;
			}

			var img:BitmapData = new BitmapData(tf.width, tf.height, true, 0);
			img.draw(tf, null, null, null, null, smoothing);
			return img;
		}
	}
}
