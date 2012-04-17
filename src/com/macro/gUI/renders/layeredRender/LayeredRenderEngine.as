package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;


	/**
	 * 分层渲染器，需要关注
	 * <ul><li>控件的坐标变化</li>
	 * <li>Paint事件中的BitmapData重建，不需要处理BitmapData的重绘</li>
	 * <li>子控件的添加、删除、层级变化</li></ul>
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
