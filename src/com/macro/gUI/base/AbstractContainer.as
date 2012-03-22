package com.macro.gUI.base
{

	import avmplus.getQualifiedClassName;
	
	import com.macro.gUI.skin.ISkin;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	/**
	 * 抽象容器，不允许实例化，几乎所有容器都继承于它。
	 * 如果不需要完整的容器功能，可以直接实现IContainer接口
	 * @author Macro776@gmail.com
	 *
	 */
	public class AbstractContainer extends AbstractControl implements IContainer
	{

		/**
		 * 顶层皮肤<br/><br/>
		 * 未直接曝露，支持此属性的子类自行提供访问器
		 */
		protected var _skinCover:ISkin;


		/**
		 * 抽象容器
		 * @param width 容器宽度
		 * @param height 容器高度
		 *
		 */
		public function AbstractContainer(width:int, height:int)
		{
			super(width, height);

			if (getQualifiedClassName(this) == "com.macro.gUI.base::AbstractContainer")
			{
				throw new Error("Abstract class can not be constructed!");
			}

			_children = new Vector.<IControl>();
		}

		
		protected var _bitmapDataCover:BitmapData;

		public function get bitmapDataCover():BitmapData
		{
			return _bitmapDataCover;
		}
		
		
		protected var _margin:Rectangle;
		
		public function get margin():Rectangle
		{
			return _margin;
		}
		
		
		protected var _children:Vector.<IControl>;
		
		public function get children():Vector.<IControl>
		{
			return _children;
		}
		
		

		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_skinCover && width < _skinCover.minWidth)
			{
				width = _skinCover.minWidth;
			}

			if (_skinCover && height < _skinCover.minHeight)
			{
				height = _skinCover.minHeight;
			}

			super.resize(width, height);
		}


		protected override function paint(rebuild:Boolean = false):void
		{
			super.paint(rebuild);

			if (rebuild || !_bitmapDataCover)
			{
				if (_bitmapDataCover)
				{
					_bitmapDataCover.dispose();
				}

				_bitmapDataCover = new BitmapData(_rect.width, _rect.height, _transparent, 0);
			}
			else
			{
				_bitmapDataCover.fillRect(_bitmapDataCover.rect, 0);
			}

			if (_skinCover && _skinCover.bitmapData)
			{
				if (_skinCover.gridRight > _skinCover.gridLeft)
				{
					if (_skinCover.gridBottom > _skinCover.gridTop)
					{
						drawFull(_bitmapDataCover, _rect, _skinCover);
					}
					else
					{
						drawHorizontal(_bitmapDataCover, _rect, _skinCover);
					}
				}
				else
				{
					if (_skinCover.gridBottom > _skinCover.gridTop)
					{
						drawVertical(_bitmapDataCover, _rect, _skinCover);
					}
					else
					{
						drawFixed(_bitmapDataCover, _rect, _skinCover.align, _skinCover.bitmapData);
					}
				}
			}
		}



		public function addChild(child:IControl):void
		{
			_children.push(child);

			if (child.parent)
			{
				child.parent.removeChild(child);
			}
			(child as AbstractControl).setParent(this);
		}

		public function addChildAt(child:IControl, index:int):void
		{
			if (index < 1)
			{
				_children.unshift(child);
			}
			else if (index >= _children.length)
			{
				_children.push(child);
			}
			else
			{
				_children.splice(index, 0, child);
			}

			if (child.parent)
			{
				child.parent.removeChild(child);
			}
			(child as AbstractControl).setParent(this);
		}

		public function removeChild(child:IControl):void
		{
			var p:int = _children.indexOf(child);
			if (p != -1)
			{
				_children.splice(p, 1);
			}

			if (child is AbstractControl)
			{
				(child as AbstractControl).setParent(null);
			}
		}

		public function removeChildAt(index:int):IControl
		{
			var child:IControl;
			if (index >= 0 && index < _children.length)
			{
				child = _children.splice(index, 1)[0];

				if (child is AbstractControl)
				{
					(child as AbstractControl).setParent(null);
				}
			}

			return child;
		}
		
		/**
		 * 移除指定范围的所有子控件
		 * @param beginIndex 首个子控件的深度
		 * @param endIndex 最后一个子控件的深度，如果是-1，则指向结尾
		 * 
		 */
		public function removeChildren(beginIndex:int = 0, endIndex:int = -1):void
		{
			if (endIndex == -1)
			{
				endIndex = _children.length;
			}
			
			if (endIndex < beginIndex)
			{
				endIndex = beginIndex;
			}
			
			var child:IControl;
			for (var i:int = beginIndex; i < endIndex; i++)
			{
				child = _children[i];
				if (child is AbstractControl)
				{
					(child as AbstractControl).setParent(null);
				}
			}
			_children.splice(beginIndex, endIndex - beginIndex);
		}
		
		/**
		 * 获取指定深度的控件
		 * @param index
		 * @return 
		 * 
		 */
		public function getChildAt(index:int):IControl
		{
			if (index >= 0 && index < _children.length)
			{
				return _children[index];
			}
			return null;
		}
		
		/**
		 * 获取指定控件的深度
		 * @param child
		 * @return 
		 * 
		 */
		public function getChildIndex(child:IControl):int
		{
			return _children.indexOf(child);
		}

		// TODO 待实现setChildIndex, swapChildren, swapChildrenAt
	}
}
