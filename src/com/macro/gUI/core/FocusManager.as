package com.macro.gUI.core
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.controls.TextInput;
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.core.feature.IFocus;
	import com.macro.gUI.core.feature.IKeyboard;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	/**
	 * 焦点管理器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class FocusManager
	{

		/**
		 * 焦点控件
		 */
		protected var _focusControl:IFocus;

		

		/**
		 * 显示容器
		 */
		private var _container:DisplayObjectContainer;
		
		/**
		 * 最上层窗口容器
		 */
		private var _top:IContainer;
		
		

		/**
		 * 可编辑控件
		 */
		private var _editControl:IEdit;

		/**
		 * 输入框
		 */
		private var _editBox:TextField;



		/**
		 * 焦点管理器
		 * @param container 显示容器，用于处理临时TextField
		 *
		 */
		public function FocusManager(container:DisplayObjectContainer, top:IContainer)
		{
			_top = top;
			_container = container;
			_container.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_container.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}


		/**
		 * 聚焦控件
		 * @param control
		 * @return
		 *
		 */
		public function focus(control:IControl):void
		{
			if (control is IFocus && control.enabled)
			{
				setFocus(control as IFocus);
			}
			else
			{
				setFocus(null);
			}

			// 处理编辑框
			if (_editControl != null)
			{
				if (_editControl == control)
				{
					focusEditBox();
					return;
				}
				else
				{
					endEdit();
				}
			}
			if (control is IEdit)
			{
				_editControl = control as IEdit;
				beginEdit();
			}
		}


		protected function keyDownHandler(e:KeyboardEvent):void
		{
			// 处理编辑框
			if (_editControl != null && _editBox != null)
			{
				if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.ESCAPE)
				{
					endEdit();
				}
			}


			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyDown(e);
			}

			if (_focusControl != null)
			{
				// 按下Tab键时焦点移到下一个tabIndex控件
				var parent:IContainer = (_focusControl as IControl).parent;
				if (parent != null && e.keyCode == Keyboard.TAB)
				{
					var temp:Vector.<IFocus> = new Vector.<IFocus>();
					for each (var control:IControl in parent.children)
					{
						if (control is IFocus && control.enabled && control != _focusControl)
						{
							temp.push(control as IFocus);
						}
					}

					var length:int = temp.length;
					if (length > 0)
					{
						if (_editControl != null)
						{
							endEdit();
						}

						var index:int = 0;
						if (length > 1)
						{
							temp.sort(compareTabIndex);

							var tabIndex:int = _focusControl.tabIndex;
							for (var i:int; i < length; i++)
							{
								if (temp[i].tabIndex > tabIndex)
								{
									index = i;
									break;
								}
							}
						}
						setFocus(temp[index]);

						if (_focusControl is IEdit)
						{
							_editControl = _focusControl as IEdit;
							beginEdit();
							return;
						}
					}
				}
			}
		}

		protected function keyUpHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.TAB)
			{
				return;
			}

			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyUp(e);
			}
		}


		private function compareTabIndex(a:IFocus, b:IFocus):Number
		{
			if (a.tabIndex > b.tabIndex)
			{
				return 1;
			}
			else if (a.tabIndex < b.tabIndex)
			{
				return -1;
			}
			return 0;
		}


		/**
		 * 设置焦点控件，并处理焦点框
		 * @param control
		 *
		 */
		private function setFocus(control:IFocus):void
		{
			_focusControl = control;

			if (_focusControl == null)
			{
				// TODO 清除焦点框
			}
			else
			{
				// TODO 绘制焦点框，注意添加焦点框皮肤
			}
		}




		/**
		 * 开始编辑
		 *
		 */
		private function beginEdit():void
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

				_editBox.addEventListener(Event.CHANGE, relocateEditBox, false, 0, true);
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
		private function endEdit():void
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
		private function focusEditBox():void
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