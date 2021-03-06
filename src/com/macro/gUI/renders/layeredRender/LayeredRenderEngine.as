package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.IComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
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

			var b:Bitmap = new Bitmap(_root.bitmapData);
			b.scrollRect = _root.rect;
			_controlToBitmap[_root] = b;
			_displayObjectContainer.addChild(b);
		}


		public function updateCoord(control:IControl):void
		{
			if (control.stage == null)
			{
				return;
			}

			// 获取父控件的可视区域及全局坐标
			var container:IContainer = control.holder;
			var m:Margin = container.margin;

			var p:Point = container.localToGlobal();
			var b:Bitmap = _controlToBitmap[container];
			var s:Rectangle = b.scrollRect;
			var r:Rectangle = new Rectangle(p.x + s.x, p.y + s.y, s.width, s.height);

			updateBitmapCoordAndScrollRect(control, r, p.x + m.left, p.y + m.top);
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
				updateCoord(control);
			}
		}
		
		public function updateVisible(control:IControl):void
		{
			if (control.stage == null)
			{
				return;
			}
			
			// 获取父控件的可见性
			var container:IContainer = control.holder;
			var b:Bitmap = _controlToBitmap[container];
			
			updateBitmapVisible(control, b.visible);
		}
		
		public function updateAlpha(control:IControl):void
		{
			if (control.stage == null)
			{
				return;
			}
			
			// 获取父控件的透明度
			var container:IContainer = control.holder;
			var b:Bitmap = _controlToBitmap[container];
			
			updateBitmapAlpha(control, b.alpha);
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
			addToDisplayList(childBitmapList, getBitmapInsertIndex(container, child));
			// 更新子控件坐标
			updateCoord(child);
			// 更新子控件可见性
			updateVisible(child);
			// 更新子控件透明度
			updateAlpha(child);
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
			addToDisplayList(childBitmapList, getBitmapInsertIndex(container, child));
		}



		/**
		 * 更新控件对应的位图显示对象的坐标及滚动区域
		 * @param control
		 * @param viewRect 控件的全局可视范围
		 * @param globalX 父控件的全局横坐标
		 * @param globalY 父控件的全局纵坐标
		 *
		 */
		private function updateBitmapCoordAndScrollRect(control:IControl, viewRect:Rectangle, globalX:int, globalY:int):void
		{
			if (control is IComposite)
			{
				updateBitmapCoordAndScrollRect((control as IComposite).container, viewRect, globalX, globalY);
				return;
			}

			// 当前控件的全局区域
			var controlRect:Rectangle = control.rect;
			controlRect.x += globalX;
			controlRect.y += globalY;

			var b:Bitmap = _controlToBitmap[control];
			var scrollRect:Rectangle = viewRect.intersection(controlRect);

			b.x = scrollRect.x;
			b.y = scrollRect.y;

			scrollRect.offset(-controlRect.x, -controlRect.y);
			b.scrollRect = scrollRect;

			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				var m:Margin = container.margin;

				// 处理容器的本地坐标
				globalX = controlRect.x + m.left;
				globalY = controlRect.y + m.top;

				// 处理容器边距
				controlRect.left += m.left;
				controlRect.top += m.top;
				controlRect.right -= m.right;
				controlRect.bottom -= m.bottom;
				viewRect = viewRect.intersection(controlRect);

				for each (var ic:IControl in container.children)
				{
					updateBitmapCoordAndScrollRect(ic, viewRect, globalX, globalY);
				}
			}
		}
		
		
		/**
		 * 更新控件对应的位图显示对象的透明度
		 * @param control
		 * @param alpha 父控件的Alpha值
		 * 
		 */
		private function updateBitmapAlpha(control:IControl, alpha:Number):void
		{
			if (control is IComposite)
			{
				updateBitmapAlpha((control as IComposite).container, alpha);
				return;
			}
			
			alpha *= control.alpha;
			
			var b:Bitmap = _controlToBitmap[control];
			b.alpha = alpha;
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
				{
					updateBitmapAlpha(ic, alpha);
				}
			}
		}
		
		
		/**
		 * 更新控件对应的位图显示对象的可见性
		 * @param control
		 * @param visible
		 * 
		 */
		private function updateBitmapVisible(control:IControl, visible:Boolean):void
		{
			if (control is IComposite)
			{
				updateBitmapVisible((control as IComposite).container, visible);
				return;
			}
			
			visible = visible ? control.visible : false;
			
			var b:Bitmap = _controlToBitmap[control];
			b.visible = visible;
			
			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
				{
					updateBitmapVisible(ic, visible);
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
		private function getBitmapInsertIndex(container:IContainer, child:IControl):int
		{
			var index:int = container.getChildIndex(child);
			if (index == -1)
			{
				for (var i:int = container.numChildren; i >= 0; i--)
				{
					var ic:IControl = container.getChildAt(i);
					if (ic is IComposite && (ic as IComposite).container == child)
					{
						index = i;
						break;
					}
				}
			}

			var control:IControl = container.getChildAt(index + 1);
			if (control != null)
			{
				var b:Bitmap;
				if (control is IComposite)
				{
					b = _controlToBitmap[(control as IComposite).container]
				}
				else
				{
					b = _controlToBitmap[control];
				}
				return _displayObjectContainer.getChildIndex(b);
			}
			else if (container.holder != null)
			{
				return getBitmapInsertIndex(container.holder, container);
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
			if (control is IComposite)
			{
				createBitmapList((control as IComposite).container, childBitmapList);
				return;
			}

			var b:Bitmap = _controlToBitmap[control];
			if (b == null)
			{
				b = new Bitmap(control.bitmapData);
				_controlToBitmap[control] = b;
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


		/**
		 * 获取控件的Bitmap列表
		 * @param control
		 * @param childBitmapList
		 * @param isRemove 是否移除
		 *
		 */
		private function getBitmapList(control:IControl, childBitmapList:Vector.<Bitmap>, isRemove:Boolean):void
		{
			if (control is IComposite)
			{
				getBitmapList((control as IComposite).container, childBitmapList, isRemove);
				return;
			}

			var b:Bitmap = _controlToBitmap[control];
			if (isRemove)
			{
				_controlToBitmap[control] = null;
				delete _controlToBitmap[control];
			}
			childBitmapList.push(b);

			if (control is IContainer)
			{
				var container:IContainer = control as IContainer;
				for each (var ic:IControl in container.children)
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
		
		
		
		/**
		 * 获取控件对应的位图显示对象。
		 * 注意，未加入舞台的控件没有对应的位图显示对象。
		 * @param control
		 * @return
		 *
		 */
		public function getBitmap(control:IControl):Bitmap
		{
			return _controlToBitmap[control];
		}
	}
}
