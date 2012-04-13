package com.macro.gUI.core
{
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class DragManager
	{
		
		/**
		 * 拖拽的外层控件
		 */
		internal var _dragControl:IDrag;
		
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
		
		
		public function DragManager()
		{
		}
		
		
		public function startDrag(control:IDrag, target:IControl):void
		{
			_dragControl = control as IDrag;
			_dragTarget = target;
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
		
		public function stopDrag(control:IControl):void
		{
			if (_dragControl == control)
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
		
		public function dragging(mouseX:int, mouseY:int):void
		{
			// 拖拽中
			if (_dragMode == DragMode.DIRECT)
			{
				_dragControl.setDragCoord(_dragTarget, mouseX, mouseY);
			}
			else
			{
				// TODO 实现拖拽替身
			}
		}
	}
}