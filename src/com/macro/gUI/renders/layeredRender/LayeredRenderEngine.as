package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
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

		/**
		 * 根容器控件
		 */
		private var _root:IContainer;

		/**
		 * 控件Bitmap对应表
		 */
		private var _controlToBitmap:Dictionary;

		/**
		 * 容器遮罩对应表
		 */
		private var _containerToMask:Dictionary;

		/**
		 * 显示对象容器
		 */
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
			_controlToBitmap = new Dictionary(true);
			_containerToMask = new Dictionary(true);

			var b:Bitmap = new Bitmap(_root.bitmapData);
			_displayObjectContainer.addChild(b);
			_controlToBitmap[_root] = b;
			
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0, 0, _root.width, _root.height);
			_containerToMask[_root] = mask;
		}


		public function updateCoord(control:IControl):void
		{
			if (control.stage == null)
			{
				return;
			}

			var container:IContainer = control.parent;
			var p:Point = container.localToGlobal();
			var s:Shape = _containerToMask[container];
			var r:Rectangle = s.getRect(null);
			updateCoordAndMask(control, r, p.x, p.y);
		}

		public function updatePaint(control:IControl, isRebuild:Boolean):void
		{
			if (control.stage == null)
			{
				return;
			}

			var b:Bitmap = _controlToBitmap[control];
			if (b != null && isRebuild)
			{
				b.bitmapData = control.bitmapData;

				// 如果是容器，要更新控件的坐标及遮罩
				if (control is IContainer)
				{
					updateCoord(control);
				}
			}
		}

		public function addChild(container:IContainer, child:IControl):void
		{
			if (container.stage == null)
			{
				return;
			}

			// 为子控件创建Bitmap列表
			var childBitmapList:Vector.<Bitmap> = new Vector.<Bitmap>();
			createBitmapList(child, childBitmapList);
			// 将子控件的Bitmap列表加入显示列表
			addToDisplayList(childBitmapList, getIndex(container, child));
			// 更新子控件的坐标及遮罩
			updateCoord(container);
		}

		public function removeChild(container:IContainer, child:IControl):void
		{
			if (container.stage == null)
			{
				return;
			}

			// 获取子控件对应的Bitmap列表
			var childBitmapList:Vector.<Bitmap> = new Vector.<Bitmap>();
			getBitmapList(child, childBitmapList, true);
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
				getBitmapList(child, childBitmapList, true);
			}
			// 将子控件相关的Bitmap从显示列表移除
			removeFromDisplayList(childBitmapList);
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
			// 将子控件的Bitmap列表加入显示列表
			addToDisplayList(childBitmapList, getIndex(container, child));
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
			
			// 当前控件的全局区域
			var controlRect:Rectangle = control.rect;
			controlRect.x += globalX;
			controlRect.y += globalY;

			var b:Bitmap = _controlToBitmap[control];
			b.x = controlRect.x;
			b.y = controlRect.y;
			b.mask = _containerToMask[control.parent];

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
				
				var s:Shape = _containerToMask[container];
				s.graphics.clear();
				s.graphics.beginFill(0);
				s.graphics.drawRect(viewRect.x, viewRect.y, viewRect.width, viewRect.height);

				for each (var ic:IControl in container.children)
				{
					updateCoordAndMask(ic, viewRect, globalX, globalY);
				}
			}
		}


		/**
		 * 获取子控件的正确插入位置。
		 * 通过查找同级下一个控件的索引位置来实现，如果没有同级下一个子控件，则递归查找父级
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
				var b:Bitmap = _controlToBitmap[control];
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
		 * 创建控件对应的Bitmap列表
		 * @param control
		 * @param childBitmapList
		 *
		 */
		private function createBitmapList(control:IControl, childBitmapList:Vector.<Bitmap>):void
		{
			var b:Bitmap = _controlToBitmap[control];
			if (b == null)
			{
				b = new Bitmap(control.bitmapData);
				_controlToBitmap[control] = b;
			}

			childBitmapList.push(b);

			if (control is IContainer)
			{
				_containerToMask[control] = new Shape();
				
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
				{
					createBitmapList(ic, childBitmapList);
				}
			}
		}


		/**
		 * 获取控件的Bitmap列表
		 * @param control
		 * @param childBitmapList
		 * @param isRemove 是否移除
		 *
		 */
		private function getBitmapList(control:IControl, childBitmapList:Vector.<Bitmap>, isRemove:Boolean):void
		{
			var b:Bitmap = _controlToBitmap[control];
			if (isRemove)
			{
				b.mask = null;

				_controlToBitmap[control] = null;
				delete _controlToBitmap[control];
			}
			childBitmapList.push(b);

			if (control is IContainer)
			{
				if (isRemove)
				{
					_containerToMask[control] = null;
					delete _containerToMask[control];
				}
				
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container)
				{
					getBitmapList(ic, childBitmapList, isRemove);
				}
			}
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
