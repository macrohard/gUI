package com.macro.gUI.core
{
	
	import com.macro.gUI.assist.CHILD_REGION;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.controls.TextInput;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.core.feature.IFocus;
	import com.macro.gUI.core.feature.IKeyboard;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;


	/**
	 * 交互管理器，通过协同UIManager工作，监听RootSprite的键盘、鼠标操作，
	 * 然后定位到正确的IControl，设置其相应的状态，并通过它派发事件<br/>
	 * 首先根据控件的rect定义递归搜索直到具体的IControl，再通过hitTest测试找到真正的IControl
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class InteractionManager
	{

		/**
		 * 显示容器
		 */
		private var _container:DisplayObjectContainer;

		/**
		 * 根容器
		 */
		private var _root:IContainer;
		
		/**
		 * 最上层窗口容器
		 */
		private var _top:IContainer;
		
		
		
		/**
		 * 鼠标点击的外层控件，基本控件或复合控件
		 */
		private var _mouseControl:IControl;
		
		/**
		 * 鼠标点击的实际目标控件，如复合控件内的控件
		 */
		private var _mouseTarget:IControl;
		
		/**
		 * 拖拽的外层控件
		 */
		private var _dragControl:IDrag;
		
		/**
		 * 拖拽的目标控件
		 */
		private var _dragTarget:IControl;
		
		/**
		 * 拖拽模式
		 */
		private var _dragMode:int;
		
		/**
		 * 拖拽替身
		 */
		private var _dragAvatar:BitmapData;
		
		/**
		 * 焦点控件
		 */
		private var _focusControl:IControl;
		
		/**
		 * 可编辑控件
		 */
		private var _editControl:IEdit;
		
		/**
		 * 输入框
		 */
		private var _editBox:TextField;
		
		
		

		/**
		 * 交互管理器
		 * @param root
		 * @param top
		 * @param container
		 * 
		 */
		public function InteractionManager(root:IContainer, top:IContainer, container:DisplayObjectContainer)
		{
			_root = root;
			_top = top;
			_container = container;
			
			container.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			container.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			container.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			container.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		
		protected function mouseDownHandler(e:MouseEvent):void
		{
			findTargetControl(_root);
			
			// 处理焦点
			if (_mouseControl is IFocus && _mouseControl.enabled)
			{
				_focusControl = _mouseControl;
			}
			else
			{
				_focusControl = null;
			}
			
			// 处理编辑框
			if (_editControl != null)
			{
				if (_editControl == _mouseControl)
				{
					focusEditBox();
					return;
				}
				else
				{
					endEdit();
				}
			}
			if (_mouseControl is IEdit)
			{
				_editControl = _mouseControl as IEdit;
				beginEdit();
				return;
			}
			
			if (_mouseTarget != null && _mouseControl.enabled && _mouseTarget.enabled)
			{
				// 处理鼠标按下
				if (_mouseControl is IButton)
				{
					(_mouseControl as IButton).mouseDown(_mouseTarget);
				}
				
				// 处理拖拽
				if (_mouseControl is IDrag)
				{
					_dragControl = _mouseControl as IDrag;
					_dragTarget = _mouseTarget;
					_dragMode = _dragControl.getDragMode(_dragTarget);
					
					if (_dragMode == DragMode.NONE)
					{
						_dragControl = null;
						_dragTarget = null;
					}
					else if (_dragMode == DragMode.AVATAR)
					{
						_dragAvatar = _dragControl.getDragImage();
						if (_dragAvatar == null)
						{
							_dragControl = null;
							_dragTarget = null;
						}
					}
					
					if (_dragControl != null)
					{
						Mouse.cursor = MouseCursor.BUTTON;
					}
				}
			}
		}
		
		protected function mouseUpHandler(e:MouseEvent):void
		{
			if (_dragControl == null)
			{
				// 处理鼠标松开
				if (_mouseControl != null && _mouseControl.enabled && _mouseTarget.enabled)
				{
					if (_mouseControl is IButton)
					{
						(_mouseControl as IButton).mouseUp(_mouseTarget);
					}
				}
			}
			else
			{
				// 结束拖拽
				findTargetControl(_root);
				
				if (_dragControl == _mouseControl)
				{
					if (_dragControl is IButton)
					{
						(_dragControl as IButton).mouseUp(_dragTarget);
					}
				}
				else
				{
					Mouse.cursor = MouseCursor.AUTO;
					if (_dragControl is IButton)
					{
						(_dragControl as IButton).mouseOut(_dragTarget);
					}
				}
				
				_dragControl = null;
				_dragTarget = null;
				_dragAvatar = null;
			}
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (_dragControl == null)
			{
				var tempC:IControl = _mouseControl;
				var tempT:IControl = _mouseTarget;
				findTargetControl(_root);
				
				// 在同一个控件范围内移动时不作处理
				if (tempT == _mouseTarget)
				{
					return;
				}
				
				// 处理鼠标离开
				if (tempC is IButton && tempC.enabled && tempT.enabled)
				{
					(tempC as IButton).mouseOut(tempT);
					Mouse.cursor = MouseCursor.AUTO;
				}
				
				// 处理鼠标进入
				if (_mouseControl != null && _mouseControl.enabled && _mouseTarget.enabled)
				{
					if (_mouseControl is IButton)
					{
						(_mouseControl as IButton).mouseOver(_mouseTarget);
						
						if (_mouseTarget is IButton)
						{
							Mouse.cursor = MouseCursor.BUTTON;
						}
					}
				}
				
			}
			else
			{
				// 拖拽中
				if (_dragMode == DragMode.DIRECT)
				{
					_dragControl.setDragCoord(_dragTarget, _container.mouseX, _container.mouseY);
				}
				else
				{
					// TODO 实现拖拽替身
				}
			}
		}
		
		/**
		 * 遍历查找鼠标所在的控件
		 * @param control
		 * @return
		 *
		 */
		protected function findTargetControl(control:IControl):Boolean
		{
			var target:IControl = control.hitTest(_container.mouseX, _container.mouseY);
			if (target != null)
			{
				if (control is IContainer && target is CHILD_REGION)
				{
					var container:IContainer = control as IContainer;
					for (var i:int = container.numChildren - 1; i >= 0; i--)
					{
						if (findTargetControl(container.children[i]))
						{
							return true;
						}
					}
					
					if (control.bitmapData == null)
					{
						_mouseTarget = null;
						_mouseControl = null;
						return false;
					}
				}
				
				_mouseTarget = target;
				_mouseControl = control;
				return true;
			}
			else
			{
				_mouseTarget = null;
				_mouseControl = null;
				return false;
			}
			
		}
		
		
		
		protected function keyDownHandler(e:KeyboardEvent):void
		{
			// TODO 按下Tab键时焦点移到下一个tabIndex控件，如果没有，则不处理
			
			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyDown(e);
			}
			
			// 处理编辑框
			if (_editControl != null && _editBox != null)
			{
				if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.ESCAPE)
				{
					endEdit();
				}
			}
		}
		
		
		protected function keyUpHandler(e:KeyboardEvent):void
		{
			if (_focusControl is IKeyboard)
			{
				(_focusControl as IKeyboard).keyUp(e);
			}
		}
		
		
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
				
				var p:Point = textInput.globalCoord();
				
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
