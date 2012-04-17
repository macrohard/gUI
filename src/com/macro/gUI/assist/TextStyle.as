package com.macro.gUI.assist
{
	import flash.text.TextFormat;


	/**
	 * 文本样式，派生自TextFormat，一次性设置有利于优化文本类控件的重绘次数
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TextStyle extends TextFormat
	{

		/**
		 * 多行文本
		 */
		public var multiline:Boolean;

		/**
		 * 自动转行
		 */
		public var wordWrap:Boolean;

		/**
		 * 最大字符数，仅限定用户可以输入多少文本，直接赋值时不受此限制
		 */
		public var maxChars:int;

		/**
		 * 滤镜数组
		 */
		public var filters:Array;


		/**
		 * 文本样式，派生自TextFormat。禁用了bullet, url, target, tabStops等属性
		 * @param font
		 * @param size
		 * @param color
		 * @param bold
		 * @param italic
		 * @param underline
		 * @param align
		 * @param leftMargin
		 * @param rightMargin
		 * @param indent
		 * @param leading
		 *
		 */
		public function TextStyle(font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null,
								  underline:Object = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null,
								  indent:Object = null, blockIndent:Object = null, leading:Object = null)
		{
			super(font, size, color, bold, italic, underline, null, null, align, leftMargin, rightMargin, indent, leading);

			this.blockIndent = blockIndent;
		}

		public function clone():TextStyle
		{
			var style:TextStyle = new TextStyle();
			style.font = this.font;
			style.size = this.size;
			style.color = this.color;
			style.bold = this.bold;
			style.italic = this.italic;
			style.underline = this.underline;
			style.align = this.align;
			style.leftMargin = this.leftMargin;
			style.rightMargin = this.rightMargin;
			style.indent = this.indent;
			style.blockIndent = this.blockIndent;
			style.leading = this.leading;
			style.kerning = this.kerning;
			style.letterSpacing = this.letterSpacing;

			style.multiline = this.multiline;
			style.wordWrap = this.wordWrap;
			style.maxChars = this.maxChars;
			style.filters = this.filters;

			return style;
		}


		// 以下属性不予支持

		public override function set bullet(value:Object):void
		{
			throw new Error("Unsupport text style!");
		}

		public override function set display(value:String):void
		{
			throw new Error("Unsupport text style!");
		}

		public override function set tabStops(value:Array):void
		{
			throw new Error("Unsupport text style!");
		}

		public override function set target(value:String):void
		{
			throw new Error("Unsupport text style!");
		}

		public override function set url(value:String):void
		{
			throw new Error("Unsupport text style!");
		}

	}
}
