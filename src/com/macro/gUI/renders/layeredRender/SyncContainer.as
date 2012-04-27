package com.macro.gUI.renders.layeredRender
{
	import com.macro.gUI.core.IControl;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;

	/**
	 * 同步容器，封装DisplayObjectContainer，以便拿到子对象列表
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class SyncContainer
	{
		private var _displayObjectContainer:DisplayObjectContainer;
		
		internal var bitmapList:Vector.<Bitmap>;
		
		public function SyncContainer(displayObjectContainer:DisplayObjectContainer)
		{
			_displayObjectContainer = displayObjectContainer;
			bitmapList = new Vector.<Bitmap>();
		}
		
		public function addChild(bmp:Bitmap):void
		{
			if (bitmapList.indexOf(bmp) != -1)
			{
				removeChild(bmp);
			}
			
			bitmapList.push(bmp);
			_displayObjectContainer.addChild(bmp);
		}
		
		public function addChildAt(bmp:Bitmap, index:int):void
		{
			if (index < 0 || index >= bitmapList.length)
			{
				throw new Error("Invalid index!");
			}
			
			var index2:int = bitmapList.indexOf(bmp);
			if (index2 == index)
			{
				return;
			}
			
			if (index2 != -1)
			{
				removeChild(bmp);
				if (index2 < index)
				{
					index--;
				}
			}
			
			bitmapList.splice(index, 0, bmp);
			_displayObjectContainer.addChildAt(bmp, index);
		}
		
		public function removeChild(bmp:Bitmap):void
		{
			var index:int = bitmapList.indexOf(bmp);
			if (index == -1)
			{
				throw new Error("Bitmap is not exist!");
			}
			
			if (_displayObjectContainer.getChildAt(index) != bmp)
			{
				throw new Error("Child list is not SYNC!");
			}
			
			bitmapList.splice(index, 1);
			_displayObjectContainer.removeChildAt(index);
		}
		
		public function removeChildAt(index:int):void
		{
			if (index < 0 || index >= bitmapList.length)
			{
				throw new Error("Invalid index!");
			}
			
			if (bitmapList[index] != _displayObjectContainer.getChildAt(index))
			{
				throw new Error("Child list is not SYNC!");
			}
			
			bitmapList.splice(index, 1);
			_displayObjectContainer.removeChildAt(index);
		}
	}
}