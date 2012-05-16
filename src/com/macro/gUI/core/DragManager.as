package com.macro.gUI.core
{
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
		 * 拖拽替身图像
		 */
		private var _dragAvatar:BitmapData;


		/**
		 * 拖拽管理器
		 * // TODO 实现拖拽任意控件
		 *
		 */
		public function DragManager(uiManager:UIManager)
		{
			_top = uiManager._top;
		}


		/**
		 * 开始拖拽
		 * @param control 要开始拖拽的控件
		 * @param target 拖拽的实际目标
		 *
		 */
		public function startDrag(control:IDrag, target:IControl):void
		{
			if (control.getDraggable(target))
			{
				_dragControl = control;
				_dragTarget = target;
				
				Mouse.cursor = MouseCursor.BUTTON;
				isDragging = true;
			}
			else
			{
				_dragControl = null;
				_dragTarget = null;
			}
		}


		/**
		 * 停止拖拽
		 * 
		 */
		public function stopDrag():void
		{
			Mouse.cursor = MouseCursor.AUTO;
			_dragControl = null;
			_dragTarget = null;
			_dragAvatar = null;
			isDragging = false;
		}


		/**
		 * 设置拖拽坐标
		 * @param mouseX
		 * @param mouseY
		 *
		 */
		public function setDragCoord(mouseX:int, mouseY:int):void
		{
			_dragControl.setDragCoord(_dragTarget, mouseX, mouseY);
		}
	}
}
