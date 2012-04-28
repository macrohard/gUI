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


	/**
	 * 分层渲染器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class LayeredRenderEngine implements IRenderEngine
	{

		private var _root:IContainer;

		private var _twoWayList:TwoWayList;

		private var _displayObjectContainer:DisplayObjectContainer;


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
			_twoWayList = new TwoWayList();

			var b:Bitmap = new Bitmap(_root.bitmapData);
			_twoWayList.add(_root, b);
			_displayObjectContainer.addChild(b);
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


		public function addChild(container:IContainer, child:IControl):void
		{
			if (container.stage == null)
			{
				return;
			}

			// 获取子控件的索引位置
			var index:int = getIndex(container, child);
			// 为子控件创建Bitmap列表
			var childBitmapList:Vector.<Bitmap> = new Vector.<Bitmap>();
			createBitmapList(child, childBitmapList);
			// 将子控件的Bitmap列表加入显示列表
			addToDisplayList(childBitmapList, index);
		}
		
		/**
		 * 获取子控件的正确插入位置
		 * @param container
		 * @param child
		 * @return 
		 * 
		 */
		private function getIndex(container:IContainer, child:IControl):int
		{
			var index:int = container.getChildIndex(child);
			var control:IControl = container.getChildAt(index + 1);
			if (control != null)
			{
				var b:Bitmap = _twoWayList.getBitmap(control)
				return _displayObjectContainer.getChildIndex(b);
			}
			else if (container.parent != null)
			{
				return getIndex(container.parent, container);
			}
			else
			{
				return _displayObjectContainer.numChildren;
			}
		}
		
		/**
		 * 创建控件对应的Bitmap列表，并添加到双向表中
		 * @param control
		 * @param childBitmapList
		 * 
		 */
		private function createBitmapList(control:IControl, childBitmapList:Vector.<Bitmap>):void
		{
			var b:Bitmap = _twoWayList.getBitmap(control);
			if (b == null)
			{
				b = new Bitmap(control.bitmapData);
				_twoWayList.add(control, b);
			}
			
			childBitmapList.push(b);
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
				{
					createBitmapList(ic, childBitmapList);
				}
			}
		}
		

		public function removeChild(container:IContainer, child:IControl):void
		{
			if (container.stage == null)
			{
				return;
			}
			
			// 获取子控件对应的Bitmap列表
			var childBitmapList:Vector.<Bitmap> = new Vector.<Bitmap>();
			getBitmapList(child, childBitmapList);
			// 将子控件相关的Bitmap从显示列表移除
			removeFromDisplayList(childBitmapList);
		}
		
		public function removeChildren(container:IContainer, childList:Vector.<IControl>):void
		{
			if (container.stage == null)
			{
				return;
			}
			
			// 获取子控件对应的Bitmap列表
			var childBitmapList:Vector.<Bitmap> = new Vector.<Bitmap>();
			for each (var child:IControl in childList)
			{
				getBitmapList(child, childBitmapList);
			}
			// 将子控件相关的Bitmap从显示列表移除
			removeFromDisplayList(childBitmapList);
		}
		
		/**
		 * 获取控件的Bitmap列表
		 * @param control
		 * @param childBitmapList
		 * @param isRemove 是否从双向表中移除
		 * 
		 */
		private function getBitmapList(control:IControl, childBitmapList:Vector.<Bitmap>, isRemove:Boolean = true):void
		{
			var b:Bitmap;
			if (isRemove)
			{
				b = _twoWayList.removeByControl(control);
			}
			else
			{
				b = _twoWayList.getBitmap(control);
			}
			childBitmapList.push(b);
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container)
				{
					getBitmapList(ic, childBitmapList, isRemove);
				}
			}
		}
		

		public function updateChildIndex(container:IContainer, child:IControl):void
		{
			if (container.stage == null)
			{
				return;
			}
			
			// 获取子控件对应的Bitmap列表
			var childBitmapList:Vector.<Bitmap> = new Vector.<Bitmap>();
			getBitmapList(child, childBitmapList, false);
			// 将子控件相关的Bitmap从显示列表移除
			removeFromDisplayList(childBitmapList);
			// 获取子控件的索引位置
			var index:int = getIndex(container, child);
			// 将子控件的Bitmap列表加入显示列表
			addToDisplayList(childBitmapList, index);
		}
		
		
		
		/**
		 * 添加到显示列表
		 * @param bmpList
		 * @param index
		 * 
		 */
		private function addToDisplayList(bmpList:Vector.<Bitmap>, index:int):void
		{
			for (var i:int = bmpList.length - 1; i >= 0; i--)
			{
				_displayObjectContainer.addChildAt(bmpList[i], index);
			}
		}
		
		/**
		 * 从显示列表移除
		 * @param bmpList
		 * 
		 */
		private function removeFromDisplayList(bmpList:Vector.<Bitmap>):void
		{
			for each (var b:Bitmap in bmpList)
			{
				_displayObjectContainer.removeChild(b);
			}
		}
	}
}
