package com.macro.gUI.base
{

	import avmplus.getQualifiedClassName;

	import com.macro.gUI.skin.ISkin;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;


	/**
	 * 抽象容器控件
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
		 * 抽象容器，不允许直接实例化
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


		private var _children:Vector.<IControl>;

		public function get children():Vector.<IControl>
		{
			return _children;
		}


		public function get numChildren():int
		{
			return _children.length;
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_skinCover != null)
			{
				if (width < _skinCover.minWidth)
				{
					width = _skinCover.minWidth;
				}
				
				if (height < _skinCover.minHeight)
				{
					height = _skinCover.minHeight;
				}
			}
			
			super.resize(width, height);
		}


		protected override function paint(rebuild:Boolean = false):void
		{
			super.paint(rebuild);

			if (_skinCover != null && _skinCover.bitmapData != null)
			{
				if (rebuild || _bitmapDataCover == null)
				{
					if (_bitmapDataCover != null)
					{
						_bitmapDataCover.dispose();
					}

					_bitmapDataCover = new BitmapData(_rect.width, _rect.height, true, 0);
				}
				else
				{
					_bitmapDataCover.fillRect(_bitmapDataCover.rect, 0);
				}


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

			if (child.parent != null)
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

			if (child.parent != null)
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

		public function removeChildren(beginIndex:int = 0, endIndex:int = -1):void
		{
			if (endIndex == -1)
			{
				endIndex = _children.length;
			}

			if (endIndex <= beginIndex)
			{
				return;
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

		public function getChildAt(index:int):IControl
		{
			if (index >= 0 && index < _children.length)
			{
				return _children[index];
			}
			return null;
		}

		public function getChildIndex(child:IControl):int
		{
			return _children.indexOf(child);
		}

		public function setChildIndex(child:IControl, index:int):void
		{
			var p:int = _children.indexOf(child);
			if (p == -1 || p == index)
			{
				return;
			}

			_children.splice(p, 1);
			// 如果插入位置比当前位置大，由于删除该子控件后，其后所有控件会自动前移，因此需要将插入位置－１
			if (index > p)
			{
				index--;
			}
			_children.splice(index, 0, child);
		}

		public function swapChildren(child1:IControl, child2:IControl):void
		{
			var p1:int = _children.indexOf(child1);
			var p2:int = _children.indexOf(child2);
			swapChildrenAt(p1, p2);
		}

		public function swapChildrenAt(index1:int, index2:int):void
		{
			if (index1 < 0 || index1 >= _children.length || index2 < 0 || index2 >= _children.length ||
					index1 == index2)
			{
				return;
			}

			// 确保index2大于index1
			if (index1 > index2)
			{
				var temp:int = index1;
				index1 = index2;
				index2 = temp;
			}

			var child1:IControl = _children[index1];
			var child2:IControl = _children[index2];

			_children.splice(index2, 1, child1);
			_children.splice(index1, 1, child2);
		}

	}
}
