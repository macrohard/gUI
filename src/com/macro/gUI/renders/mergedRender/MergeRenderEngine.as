package com.macro.gUI.renders.mergedRender
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
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

		/**
		 * 重绘标记
		 */
		private var _needRedraw:Boolean;


		/**
		 * 合并渲染器
		 * @param root 根容器控件
		 * @param displayObjectContainer 显示对象容器
		 *
		 */
		public function MergeRenderEngine(root:IContainer, displayObjectContainer:DisplayObjectContainer)
		{
			_root = root;
			_canvas = new BitmapData(_root.rect.width, _root.rect.height, true, 0);

			displayObjectContainer.addChild(new Bitmap(_canvas));
			displayObjectContainer.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}


		protected function enterFrameHandler(e:Event):void
		{
			if (_needRedraw)
			{
				_canvas.lock();
				_canvas.fillRect(_root.rect, 0);
				render(_root, _root.rect, 0, 0);
				_canvas.unlock();

				_needRedraw = false;
			}
		}


		/**
		 * 合并渲染
		 * @param control
		 * @param viewRect 控件的全局可视范围
		 * @param globalX 父控件的全局横坐标
		 * @param globalY 父控件的全局纵坐标
		 * 
		 */
		private function render(control:IControl, viewRect:Rectangle, globalX:int, globalY:int):void
		{
			if (control is IComposite)
			{
				render((control as IComposite).container, viewRect, globalX, globalY);
				return;
			}

			// 当前控件的全局区域
			var controlRect:Rectangle = control.rect;
			controlRect.x += globalX;
			controlRect.y += globalY;

			// 父控件全局可视区域与当前控件全局区域的交集
			viewRect = viewRect.intersection(controlRect);
			if (viewRect.width == 0 || viewRect.height == 0)
			{
				return;
			}

			if (control.bitmapData != null)
			{
				_canvas.copyPixels(control.bitmapData, new Rectangle(viewRect.x - controlRect.x, viewRect.y - controlRect.y, viewRect.width, viewRect.height),
								   viewRect.topLeft, null, null, true);
			}

			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;

				// 处理容器类控件的边距
				var m:Margin = container.margin;
				viewRect.left += m.left;
				viewRect.top += m.top;
				viewRect.right -= m.right;
				viewRect.bottom -= m.bottom;
				
				globalX = controlRect.x + m.left;
				globalY = controlRect.y + m.top;

				for each (var ic:IControl in container.children)
				{
					render(ic, viewRect, globalX, globalY);
				}

			}
		}

		public function updateCoord(control:IControl, x:int, y:int):void
		{
			if (control.stage != null)
			{
				_needRedraw = true;
			}
		}

		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
			if (control.stage != null)
			{
				_needRedraw = true;
			}
		}
		
		public function addChild(container:IContainer, child:IControl):void
		{
			if (container.stage != null)
			{
				_needRedraw = true;
			}
		}
		
		public function removeChild(container:IContainer, child:IControl):void
		{
			if (container.stage != null)
			{
				_needRedraw = true;
			}
		}
		
		public function removeChildren(container:IContainer, childList:Vector.<IControl>):void
		{
			if (container.stage != null)
			{
				_needRedraw = true;
			}
		}
		
		public function updateChildIndex(container:IContainer, child:IControl):void
		{
			if (container.stage != null)
			{
				_needRedraw = true;
			}
		}
	}
}
