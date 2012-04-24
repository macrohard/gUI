package com.macro.gUI.core
{
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;


	/**
	 * 拖拽管理器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class DragManager
	{

		/**
		 * 是否正在拖拽
		 */
		public var isDragging:Boolean;

		/**
		 * 最上层窗口容器控件
		 */
		private var _top:IContainer;

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
		 * 拖拽替身图像
		 */
		private var _dragAvatar:BitmapData;


		/**
		 * 拖拽管理器
		 *
		 */
		public function DragManager(top:IContainer)
		{
			_top = top;
		}


		/**
		 * 开始拖拽
		 * @param control 要开始拖拽的控件
		 * @param target 拖拽的实际目标
		 *
		 */
		public function startDrag(control:IDrag, target:IControl):void
		{
			_dragControl = control;
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

			// 确认开始拖拽
			if (_dragControl != null)
			{
				Mouse.cursor = MouseCursor.BUTTON;
				isDragging = true;
			}
		}


		/**
		 * 停止拖拽
		 * @param control 要停止拖拽的控件
		 * @param target 要停止拖拽的目标控件
		 * @return 不是当前正在拖拽的控件时返回false
		 * 
		 */
		public function stopDrag(control:IControl, target:IControl):Boolean
		{
			var b:Boolean = true;
			// 要停止拖拽的控件是当前正在拖拽的控件时
			if (_dragControl == control && _dragTarget == target)
			{
				if (_dragControl is IButton)
				{
					(_dragControl as IButton).mouseUp(_dragTarget);
				}
			}
			else // 要停止拖拽的控件不是当前正在拖拽的控件时
			{
				Mouse.cursor = MouseCursor.AUTO;
				if (_dragControl is IButton)
				{
					(_dragControl as IButton).mouseOut(_dragTarget);
				}
				
				b = false;
			}

			_dragControl = null;
			_dragTarget = null;
			_dragAvatar = null;
			isDragging = false;
			
			return b;
		}


		/**
		 * 设置拖拽坐标
		 * @param mouseX
		 * @param mouseY
		 *
		 */
		public function setDragCoord(mouseX:int, mouseY:int):void
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
