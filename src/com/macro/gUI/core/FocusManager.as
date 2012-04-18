package com.macro.gUI.core
{
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.core.feature.IFocus;
	import com.macro.gUI.core.feature.IKeyboard;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;


	/**
	 * 焦点管理器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class FocusManager
	{

		/**
		 * 显示对象容器
		 */
		private var _displayObjectContainer:DisplayObjectContainer;

		/**
		 * 最上层窗口容器控件
		 */
		private var _top:IContainer;


		/**
		 * 焦点控件
		 */
		protected var _focusControl:IFocus;


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
		 * @param top 最上层窗口容器控件，用于焦点框及拖拽替身图像
		 * @param displayObjectContainer 显示对象容器，用于处理临时TextField
		 *
		 */
		public function FocusManager(top:IContainer, displayObjectContainer:DisplayObjectContainer)
		{
			_top = top;

			_displayObjectContainer = displayObjectContainer;
			_displayObjectContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
			_displayObjectContainer.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
		}


		/**
		 * 聚焦控件
		 * @param control
		 * @return
		 *
		 */
		public function focus(control:IControl):void
		{
			// 已有编辑框时
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
			
			if (control is IFocus && control.enabled)
			{
				_focusControl = control as IFocus;
				drawFocusBox();
			}
			else
			{
				_focusControl = null;
				drawFocusBox();
			}

			if (control is IEdit)
			{
				_editControl = control as IEdit;
				beginEdit();
			}
		}


		protected function keyDownHandler(e:KeyboardEvent):void
		{
			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyDown(e);
			}
		}

		protected function keyUpHandler(e:KeyboardEvent):void
		{
			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyUp(e);
			}
			
			// 处理编辑框
			if (_editControl != null)
			{
				if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.ESCAPE)
				{
					endEdit();
				}
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
						if (control is IFocus && control.enabled &&
							control != _focusControl)
						{
							temp.push(control as IFocus);
						}
					}
					
					var length:int = temp.length;
					if (length > 0)
					{
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
						
						focus(temp[index]);
					}
				}
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
		private function drawFocusBox():void
		{
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
			_editBox = _editControl.beginEdit();
			_editBox.setSelection(0, _editBox.text.length);
			_displayObjectContainer.addChild(_editBox);
			
			focusEditBox();
		}


		/**
		 * 结束编辑
		 *
		 */
		private function endEdit():void
		{
			_editControl.endEdit(_editBox.text);
			_editControl = null;
			
			_displayObjectContainer.removeChild(_editBox);
			_editBox = null;
			
			focusEditBox();
		}


		/**
		 * 聚焦到编辑框
		 *
		 */
		private function focusEditBox():void
		{
			_displayObjectContainer.stage.focus = _editBox;
		}
	}
}
