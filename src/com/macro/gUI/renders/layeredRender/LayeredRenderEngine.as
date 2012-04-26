package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.assist.Margin;
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
		}
		
		
		/**
		 * 分层渲染
		 * @param control
		 * @param viewRect 控件的可视范围
		 * @param x
		 * @param y
		 * 
		 */
		private function render(control:IControl, viewRect:Rectangle, globalX:int, globalY:int):void
		{
			if (control is IComposite)
			{
				render((control as IComposite).container, viewRect, globalX, globalY);
				return;
			}
			
			var controlRect:Rectangle = control.rect;
			controlRect.x += globalX;
			controlRect.y += globalY;
			
			viewRect = viewRect.intersection(controlRect);
			
			var b:Bitmap = _controls[control];
			if (b == null)
			{
				b = new Bitmap(control.bitmapData);
				_controls[control] = b;
			}
			else
			{
				b.bitmapData = control.bitmapData;
			}
			b.x = controlRect.x;
			b.y = controlRect.y;
			_displayObjectContainer.addChild(b);
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				
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
		
		private function removeAllChild():void
		{
			for each (var b:Bitmap in _controls)
			{
				if (_displayObjectContainer.contains(b))
				{
					_displayObjectContainer.removeChild(b);
				}
			}
		}
		

		public function updateChildren(container:IContainer):void
		{
			if (container.stage == null)
			{
				return;
			}
			
			removeAllChild();
			render(_root, _root.rect, 0, 0);
		}

		public function updateCoord(control:IControl, x:int, y:int):void
		{
			if (control.stage == null)
			{
				return;
			}
			
			removeAllChild();
			render(_root, _root.rect, 0, 0);
		}
		
		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
			if (control.stage == null)
			{
				return;
			}
			
			var b:Bitmap = _controls[control];
			if (b != null && isRebuild)
			{
				b.bitmapData = control.bitmapData;
			}
		}

	}
}
