package com.macro.gUI.renders.mergedRender
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.UIManager;
	import com.macro.gUI.renders.IRenderEngine;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 合并渲染器，每帧重绘
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
		 * 合并渲染器
		 * @param root 根容器控件
		 * @param displayObjectContainer 显示对象容器
		 *
		 */
		public function MergeRenderEngine(root:IContainer, displayObjectContainer:DisplayObjectContainer)
		{
			_root = root;
			_canvas = new BitmapData(_root.width, _root.height, true, 0);

			displayObjectContainer.addChild(new Bitmap(_canvas));
			displayObjectContainer.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}

		public function updateCoord(control:IControl):void
		{
		}

		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
		}

		public function updateVisible(control:IControl):void
		{
		}

		public function updateAlpha(control:IControl):void
		{
		}

		public function addChild(container:IContainer, child:IControl):void
		{
		}

		public function removeChild(container:IContainer, child:IControl):void
		{
		}

		public function removeChildren(container:IContainer, childList:Vector.<IControl>):void
		{
		}

		public function updateChildIndex(container:IContainer, child:IControl):void
		{
		}



		protected function enterFrameHandler(e:Event):void
		{
			_canvas.lock();
			_canvas.fillRect(_root.rect, 0);
			render(_root, _root.rect, 0, 0, 1);
			_canvas.unlock();
		}


		/**
		 * 合并渲染
		 * @param control
		 * @param viewRect 控件的全局可视范围
		 * @param globalX 父控件的全局横坐标
		 * @param globalY 父控件的全局纵坐标
		 *
		 */
		private function render(control:IControl, viewRect:Rectangle, globalX:int, globalY:int, alpha:Number):void
		{
			if (control is IComposite)
			{
				render((control as IComposite).container, viewRect, globalX, globalY, alpha);
				return;
			}

			// 控件不可见
			if (control.visible == false)
			{
				return;
			}

			// 当前控件的全局区域
			var controlRect:Rectangle = control.rect;
			controlRect.x += globalX;
			controlRect.y += globalY;
			
			alpha *= control.alpha;

			if (control.bitmapData != null)
			{
				// 全局可视区域与当前控件全局区域的交集
				var drawRect:Rectangle = viewRect.intersection(controlRect);
				if (drawRect.width == 0 || drawRect.height == 0)
				{
					return;
				}
				
				if (alpha == 1)
				{
					var p:Point = drawRect.topLeft;
					drawRect.offset(-controlRect.x, -controlRect.y);
					_canvas.copyPixels(control.bitmapData, drawRect, p, null, null, true);
				}
				else if (alpha > 0)
				{
					// TODO 未完成
					_canvas.draw(control.bitmapData, new Matrix(1, 0, 0, 1, -drawRect.x, -drawRect.y), new ColorTransform(1, 1, 1, alpha),
								 null, drawRect, true);
				}
			}

			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				var m:Margin = container.margin;

				// 处理容器的本地坐标
				globalX = controlRect.x + m.left;
				globalY = controlRect.y + m.top;

				// 处理容器类控件的边距
				controlRect.left += m.left;
				controlRect.top += m.top;
				controlRect.right -= m.right;
				controlRect.bottom -= m.bottom;
				viewRect = viewRect.intersection(controlRect);

				for each (var ic:IControl in container.children)
				{
					render(ic, viewRect, globalX, globalY, alpha);
				}

			}
		}
	}
}
