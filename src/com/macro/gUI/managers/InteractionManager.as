package com.macro.gUI.managers
{
	import com.macro.gUI.base.IControl;
	
	import flash.display.Sprite;

	/**
	 * 交互管理器，通过协同UIManager工作，监听RootSprite的键盘、鼠标操作，
	 * 然后定位到正确的IControl，设置其相应的状态，并通过它派发事件<br/>
	 * 首先根据控件的rect定义递归搜索直到具体的IControl，再通过hitTest测试找到真正的IControl
	 * @author Macro776@gmail.com
	 * 
	 */
	public class InteractionManager
	{
		private var _focusManager:FocusManager;
		
		private var _uimanager:UIManager;
		
		private var _rootSprite:Sprite;
		
		
		public function InteractionManager(uimanager:UIManager)
		{
			_uimanager = uimanager;
		}
		
		public function init():void
		{
			if (_rootSprite)
			{
				removeListener();
			}
			
			_rootSprite = _uimanager.rootSprite;
			addListener();
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