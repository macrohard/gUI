package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	/**
	 * 分层渲染器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class LayeredRenderEngine implements IRenderEngine
	{

		private var _displayObjectContainer:DisplayObjectContainer;

		private var _root:IContainer;
		
		private var _controls:Dictionary;

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
			_controls = new Dictionary(true);
			render(_root);
		}
		
		
		/**
		 * 分层渲染
		 * @param control
		 * @param viewRect 控件的可视范围
		 * 
		 */
		private function render(control:IControl):void
		{
			if (control is IComposite)
			{
				render((control as IComposite).container);
				return;
			}
			
			var p:Point = control.localToGlobal();
			var b:Bitmap = new Bitmap(control.bitmapData);
			b.x = p.x;
			b.y = p.y;
			_displayObjectContainer.addChild(b);
			_controls[control] = b;
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
				{
					render(ic);
				}
			}
		}
		

		public function updateChildren(container:IContainer):void
		{
			render(_root);
		}

		public function updateCoord(control:IControl, x:int, y:int):void
		{
			var b:Bitmap = _controls[control];
			if (b != null)
			{
				var p:Point = control.parent.localToGlobal(new Point(x, y));
				b.x = p.x;
				b.y = p.y;
			}
		}

		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
			var b:Bitmap = _controls[control];
			if (b != null && isRebuild)
			{
				b.bitmapData = control.bitmapData;
			}
		}

	}
}
