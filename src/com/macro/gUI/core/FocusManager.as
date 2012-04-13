package com.macro.gUI.core
{
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.core.feature.IFocus;
	import com.macro.gUI.core.feature.IKeyboard;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class FocusManager
	{
		private var _editManager:EditManager;
		
		
		/**
		 * 焦点控件
		 */
		private var _focusControl:IFocus;
		
		
		public function FocusManager(editManager:EditManager)
		{
			_editManager = editManager;
		}
		
		public function keyDownHandler(e:KeyboardEvent):void
		{
			// 处理编辑框
			if (_editManager._editControl != null && _editManager._editBox != null)
			{
				if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.ESCAPE)
				{
					_editManager.endEdit();
				}
			}
			
			
			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyDown(e);
			}
			
			if (_focusControl != null)
			{
				// 按下Tab键时焦点移到下一个tabIndex控件，如果没有，则不处理
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
						if (_editManager._editControl != null)
						{
							_editManager.endEdit();
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
							_editManager._editControl = _focusControl as IEdit;
							_editManager.beginEdit();
							return;
						}
					}
				}
			}
		}
		
		public function keyUpHandler(e:KeyboardEvent):void
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
		
		public function setFocus(control:IFocus):void
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
	}
}