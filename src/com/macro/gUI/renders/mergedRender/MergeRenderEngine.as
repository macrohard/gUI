package com.macro.gUI.renders.mergedRender
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.InteractionManager;
	import com.macro.gUI.renders.IRenderEngine;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 合并渲染器，由于每帧强制重绘，无须关心BitmapData的重建或重绘问题
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class MergeRenderEngine implements IRenderEngine
	{
		
		/**
		 * 画布
		 */
		private var _canvas:BitmapData;

		/**
		 * 根容器
		 */
		private var _root:IContainer;


		public function MergeRenderEngine(root:IContainer, container:DisplayObjectContainer, width:int, height:int)
		{
			_root = root;
			_canvas = new BitmapData(width, height, true, 0);
			
			container.addChild(new Bitmap(_canvas));
			container.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		protected function enterFrameHandler(e:Event):void
		{
			_canvas.lock();
			_canvas.fillRect(_canvas.rect, 0);
			drawControl(_root, _canvas.rect);
			_canvas.unlock();
		}
		
		
		/**
		 * 合并渲染
		 * @param control
		 * @param stageRect
		 *
		 */
		private function drawControl(control:IControl, viewRect:Rectangle):void
		{
			var controlRect:Rectangle = control.rect;
			var p:Point = control.localToGlobal();
			controlRect.x = p.x;
			controlRect.y = p.y;
			
			viewRect = viewRect.intersection(controlRect);
			
			var drawR:Rectangle = viewRect.clone();
			drawR.offset(-p.x, -p.y);
			
			if (control.bitmapData != null)
			{
				_canvas.copyPixels(control.bitmapData, drawR, viewRect.topLeft, null, null, true);
			}
			
			if (control is IComposite)
			{
				drawControl((control as IComposite).container, viewRect);
			}
			else if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				
				var m:Margin = container.margin;
				viewRect.left += m.left;
				viewRect.top += m.top;
				viewRect.right -= m.right;
				viewRect.bottom -= m.bottom;
				
				for each (var ic:IControl in container.children)
				{
					if (ic is IComposite)
					{
						drawControl((ic as IComposite).container, viewRect);
					}
					else
					{
						drawControl(ic, viewRect);
					}
				}
				
			}
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
