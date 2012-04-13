package com.macro.gUI.core
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.controls.TextInput;
	import com.macro.gUI.core.feature.IEdit;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	public class EditManager
	{
		/**
		 * 显示容器
		 */
		private var _container:DisplayObjectContainer;
		
		/**
		 * 可编辑控件
		 */
		internal var _editControl:IEdit;
		
		/**
		 * 输入框
		 */
		internal var _editBox:TextField;
		
		
		public function EditManager(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		/**
		 * 开始编辑
		 *
		 */
		public function beginEdit():void
		{
			if (_editBox == null)
			{
				if (_editControl is TextInput)
				{
					var textInput:TextInput = _editControl as TextInput;
					var ts:TextStyle = textInput.style;
					
					_editBox = new TextField();
					_editBox.autoSize = TextFieldAutoSize.LEFT;
					_editBox.displayAsPassword = textInput.displayAsPassword;
					_editBox.maxChars = ts.maxChars;
					_editBox.filters = ts.filters;
					_editBox.defaultTextFormat = ts;
					if (textInput.text != null)
					{
						_editBox.text = textInput.text;
					}
					if (textInput.editable)
					{
						_editBox.type = TextFieldType.INPUT;
					}
					relocateEditBox(null);
				}
				
				_editBox.addEventListener(Event.CHANGE, relocateEditBox, false,
					0, true);
				_editBox.setSelection(0, _editBox.text.length);
				_container.addChild(_editBox);
				
				focusEditBox();
				_editControl.beginEdit();
			}
		}
		
		
		/**
		 * 结束编辑
		 *
		 */
		public function endEdit():void
		{
			if (_editBox != null)
			{
				if (_editControl is TextInput)
				{
					var textInput:TextInput = _editControl as TextInput;
					textInput.text = _editBox.text;
				}
				
				_container.stage.focus = null;
				_container.removeChild(_editBox);
				_editBox.removeEventListener(Event.CHANGE, relocateEditBox);
				_editBox = null;
				_editControl = null;
			}
		}
		
		
		/**
		 * 聚焦到编辑框
		 *
		 */
		internal function focusEditBox():void
		{
			if (_editBox != null)
			{
				_container.stage.focus = _editBox;
			}
		}
		
		
		/**
		 * 重新定位编辑框
		 *
		 */
		private function relocateEditBox(e:Event):void
		{
			var ox:int;
			var oy:int;
			
			if (_editControl is TextInput)
			{
				var textInput:TextInput = _editControl as TextInput;
				var ts:TextStyle = textInput.style;
				var padding:Margin = textInput.padding;
				
				var txtW:int = _editBox.textWidth + 4 + ts.leftMargin + ts.rightMargin + ts.indent + ts.blockIndent;
				var txtH:int = _editBox.textHeight + 4;
				
				var w:int = padding ? textInput.width - padding.left - padding.right : textInput.width;
				var h:int = padding ? textInput.height - padding.top - padding.bottom : textInput.height;
				
				if (txtW > w)
				{
					_editBox.autoSize = TextFieldAutoSize.NONE;
					_editBox.multiline = ts.multiline;
					_editBox.wordWrap = ts.wordWrap;
					txtW = w;
					_editBox.width = txtW + 2;
					txtH = _editBox.textHeight + 4;
				}
				else
				{
					_editBox.autoSize = TextFieldAutoSize.LEFT;
				}
				
				var p:Point = textInput.localToGlobal();
				
				ox = p.x + (padding ? padding.left : 0);
				if ((textInput.align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
				{
					ox += (w - txtW) >> 1;
				}
				else if ((textInput.align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
				{
					ox += w - txtW;
				}
				
				oy = p.y + (padding ? padding.top : 0);
				if ((textInput.align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
				{
					oy += (h - txtH) >> 1;
				}
				else if ((textInput.align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
				{
					oy += h - txtH;
				}
			}
			
			_editBox.x = ox;
			_editBox.y = oy;
		}
	}
}