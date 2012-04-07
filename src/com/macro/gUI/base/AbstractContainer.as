package com.macro.gUI.base
{

	import avmplus.getQualifiedClassName;

	import com.macro.gUI.assist.NULL;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 抽象容器控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class AbstractContainer extends AbstractControl implements IContainer
	{

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
			_margin = new Rectangle();
		}


		protected var _margin:Rectangle;

		public function get margin():Rectangle
		{
			return _margin;
		}

		public function set margin(value:Rectangle):void
		{
			if (value != null)
			{
				_margin = value;
			}
		}


		/**
		 * 可视范围宽度
		 * @return
		 *
		 */
		public function get contentWidth():int
		{
			return _rect.width - _margin.left - _margin.right;
		}

		/**
		 * 可视范围高度
		 * @return
		 *
		 */
		public function get contentHeight():int
		{
			return _rect.height - _margin.top - _margin.bottom;
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



		public override function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(x, y);

			if (p.x >= _margin.left && p.x <= _rect.width - _margin.right && p.y >= _margin.top &&
					p.y <= _rect.height - _margin.bottom)
			{
				return this;
			}
			if (p.x >= 0 && p.x <= _rect.width && p.y >= 0 && p.y <= _rect.height)
			{
				return new NULL();
			}

			return null;
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
				
				if (child is AbstractControl)
				{
					(child as AbstractControl).setParent(null);
				}
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
