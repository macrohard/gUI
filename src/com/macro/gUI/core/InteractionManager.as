package com.macro.gUI.core
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;


	/**
	 * 交互管理器，通过协同UIManager工作，监听RootSprite的键盘、鼠标操作，
	 * 然后定位到正确的IControl，设置其相应的状态，并通过它派发事件<br/>
	 * 首先根据控件的rect定义递归搜索直到具体的IControl，再通过hitTest测试找到真正的IControl
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class InteractionManager
	{
		private var _focusManager:FocusManager;

		private var _root:DisplayObjectContainer;

		private var _rootSprite:Sprite;


		public function InteractionManager(root:DisplayObjectContainer)
		{
			_root = root;
			
//			_root.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			_root.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//			_root.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			_root.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			_root.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function addListener():void
		{

		}

		private function removeListener():void
		{

		}

		private function getClickControl():IControl
		{
			return null;
		}
	}
}
