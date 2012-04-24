package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;


	/**
	 * 分层渲染器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class LayeredRenderEngine implements IRenderEngine
	{

		private var _displayObjectContainer:DisplayObjectContainer;

		private var _root:IContainer;

		/**
		 * 分层渲染器
		 * @param root 根容器控件
		 * @param displayObjectContainer 显示对象容器
		 *
		 */
		public function LayeredRenderEngine(root:IContainer, displayObjectContainer:DisplayObjectContainer)
		{
			_root = root;
			_displayObjectContainer = displayObjectContainer;
		}

		public function updateChildren(container:IContainer):void
		{
			// TODO Auto Generated method stub

		}

		public function updateCoord(control:IControl, x:int, y:int):void
		{
			// TODO Auto Generated method stub

		}

		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
			// TODO Auto Generated method stub

		}

	}
}
