package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	/**
	 * 分层渲染器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class LayeredRenderEngine implements IRenderEngine
	{

		private var _root:IContainer;
		
		private var _twoWayList:TwoWayList;
		
		private var _syncContainer:SyncContainer;
		

		/**
		 * 分层渲染器
		 * @param root 根容器控件
		 * @param displayObjectContainer 显示对象容器
		 *
		 */
		public function LayeredRenderEngine(root:IContainer, displayObjectContainer:DisplayObjectContainer)
		{
			_root = root;
			_twoWayList = new TwoWayList();
			_syncContainer = new SyncContainer(displayObjectContainer);
			
			var b:Bitmap = new Bitmap(_root.bitmapData);
			_twoWayList.add(_root, b);
			_syncContainer.addChild(b);
		}
		
		
		public function updateCoord(control:IControl, x:int, y:int):void
		{
			if (control.stage == null)
			{
				return;
			}
			
		}
		
		/**
		 * 更新坐标及遮罩
		 * @param control
		 * @param viewRect 控件的可视范围
		 * @param x
		 * @param y
		 * 
		 */
		private function updateCoordAndMask(control:IControl, viewRect:Rectangle, globalX:int, globalY:int):void
		{
			if (control is IComposite)
			{
				updateCoordAndMask((control as IComposite).container, viewRect, globalX, globalY);
				return;
			}
			
			var controlRect:Rectangle = control.rect;
			controlRect.x += globalX;
			controlRect.y += globalY;
			
			viewRect = viewRect.intersection(controlRect);
			
			var b:Bitmap = _twoWayList.getBitmap(control);
			b.x = controlRect.x;
			b.y = controlRect.y;
			
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
					updateCoordAndMask(ic, viewRect, globalX, globalY);
				}
			}
		}
		
		
		public function updateChildren(container:IContainer):void
		{
			if (container.stage == null)
			{
				return;
			}
			
			var beginIndex:int;
			var endIndex:int;
			
			if (container.parent == null)
			{
				// container是root
				endIndex = _syncContainer.bitmapList.length - 1;
			}
			else
			{
				// 获取当前控件对应的Bitmap
				var a:Bitmap = _twoWayList.getBitmap(container);
				beginIndex = _syncContainer.bitmapList.indexOf(a);
				
				// 获取当前控件在父级中的索引
				var index:int = container.parent.getChildIndex(container);
				// 获取当前控件同级的下一个控件的对应Bitmap
				var b:Bitmap = _twoWayList.getBitmap(container.parent.getChildAt(index + 1));
				if (b == null)
				{
					endIndex = _syncContainer.bitmapList.length - 1;
				}
				else
				{
					endIndex = _syncContainer.bitmapList.indexOf(b) - 1;
				}
			}
			
			// 获取对应范围内的所有已经在显示列表中的Bitmap
			var subChild:Vector.<Bitmap> = _syncContainer.bitmapList.slice(beginIndex, endIndex);
			// 获取更新控件的当前Bitmap列表
			var newChild:Vector.<Bitmap> = new Vector.<Bitmap>();
			makeSubChild(container, newChild);
			
			// 通过比较找出差异，添加或删除
			
		}
		
		private function makeSubChild(control:IControl, childList:Vector.<Bitmap>):void
		{
			var b:Bitmap = _twoWayList.getBitmap(control);
			if (b == null)
			{
				b = new Bitmap(control.bitmapData);
				_twoWayList.add(control, b);
			}
			
			childList.push(b);
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
				{
					makeSubChild(ic, childList);
				}
			}
		}
		
		
		
		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
			if (control.stage == null)
			{
				return;
			}
			
			var b:Bitmap = _twoWayList.getBitmap(control);
			if (b != null && isRebuild)
			{
				b.bitmapData = control.bitmapData;
			}
		}
	}
}
