package com.macro.utils
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontWeight;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	
	/**
	 * 基于FTE的文本行创建工具
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class TextUtil
	{
		
		public static const GLOW_FILTER:Array = [new GlowFilter(0x000000, 1, 2, 2, 16)];
		
		/**
		 * 创建单行文本
		 * @param text
		 * @param color
		 * @param size
		 * @param bold
		 * @param filters
		 * @return 
		 * 
		 */
		public static function getTextLine(text:String, color:int = 0, size:int = 12, bold:Boolean = true, filters:Array = null):TextLine
		{
			var fontdesc:FontDescription = new FontDescription()
			if (bold)
			{
				fontdesc.fontWeight = FontWeight.BOLD;
			}
			
			var format:ElementFormat = new ElementFormat();
			format.fontDescription = fontdesc;
			format.fontSize = size;
			format.color = color;
			
			var element:TextElement = new TextElement();
			element.elementFormat = format;
			element.text = text;
			
			var block:TextBlock = new TextBlock();
			block.baselineZero = TextBaseline.ASCENT;
			block.content = element;
			
			var textLine:TextLine = block.createTextLine();
			textLine.filters = filters;
			return textLine;
		}
		
		/**
		 * 创建多行文本
		 * @param texts 文本片段对象
		 * @param width 文本区域宽度
		 * @param lineHeight 行高
		 * @param spacing 文本片段间距
		 * @return 
		 * 
		 */
		public static function getMultiLineTextLine(texts:Vector.<TextSegment>, width:int, lineHeight:int = 18, spacing:int = 5):Sprite
		{
			var sprite:Sprite = new Sprite();
			
			var seg:TextSegment;
			var fontdesc:FontDescription;
			var format:ElementFormat;
			var element:TextElement;
			var block:TextBlock;
			var textLine:TextLine;
			var previousTextLine:TextLine;
			
			var caret:int;
			var linePos:int = lineHeight;
			
			var i:int;
			var length:int = texts.length;
			for ( i = 0; i < length; i++)
			{
				seg = texts[i];
				
				fontdesc = new FontDescription()
				if (seg.bold)
				{
					fontdesc.fontWeight = FontWeight.BOLD;
				}
				
				format = new ElementFormat();
				format.fontDescription = fontdesc;
				format.fontSize = seg.size;
				format.color = seg.color;
				
				element = new TextElement();
				element.elementFormat = format;
				element.text = seg.text;
				
				block = new TextBlock();
				block.content = element;
				
				previousTextLine = null;
				
				while (true)
				{
					if (previousTextLine == null)
					{
						textLine = block.createTextLine(previousTextLine, width >= caret ? width - caret : 0);
					}
					else
					{
						textLine = block.createTextLine(previousTextLine, width);
					}
					
					if (textLine == null)
					{
						if (previousTextLine == null)
						{
							caret = 0;
							linePos += lineHeight;
							continue;
						}
						else
						{
							caret = previousTextLine.x + previousTextLine.textWidth + spacing;
							break;							
						}
					}
					
					if (previousTextLine == null)
					{
						textLine.x = caret;
						textLine.y = linePos;
					}
					else
					{
						linePos += lineHeight;
						textLine.y = linePos;
					}
					
					textLine.filters = seg.filters;
					sprite.addChild(textLine);
					previousTextLine = textLine;
				}
				
			}
			
			return sprite;
		}
	}
}