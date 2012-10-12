package com.macro.gUI.core
{

	import avmplus.getQualifiedClassName;
	
	import com.macro.gUI.assist.ChildRegion;
	import com.macro.gUI.assist.Margin;
	
	import flash.geom.Point;


	/**
	 * 抽象容器控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class AbstractContainer extends AbstractControl implements IContainer
	{

		/**
		 * 用于辅助交互管理器判定是否下探搜索子控件的交互功能
		 */
		public static const CHILD_REGION:ChildRegion = new ChildRegion();


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
			_margin = new Margin();
		}


		protected var _margin:Margin;

		public function get margin():Margin
		{
			return _margin;
		}

		public function set margin(value:Margin):void
		{
			if (value != null)
			{
				_margin = value;
				uiMgr.renderer.updateCoord(this);
			}
		}


		/**
		 * 可视范围宽度
		 * @return
		 *
		 */
		public function get contentWidth():int
		{
			return _width - _margin.left - _margin.right;
		}

		/**
		 * 可视范围高度
		 * @return
		 *
		 */
		public function get contentHeight():int
		{
			return _height - _margin.top - _margin.bottom;
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



		override public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));
			if (p.x < 0 || p.y < 0 || p.x > _width || p.y > _height)
			{
				return null;
			}

			if (p.x >= _margin.left && p.x <= _width - _margin.right && p.y >= _margin.top && p.y <= _height - _margin.bottom)
			{
				return CHILD_REGION;
			}

			return this;
		}



		public function addChild(child:IControl):void
		{
			if (child.holder != null)
			{
				child.holder.removeChild(child);
			}

			_children.push(child);
			(child as AbstractControl).setHolder(this);

			uiMgr.renderer.addChild(this, child);
		}

		public function addChildAt(child:IControl, index:int):void
		{
			if (child.holder != null)
			{
				child.holder.removeChild(child);
			}

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
			(child as AbstractControl).setHolder(this);

			uiMgr.renderer.addChild(this, child);
		}

		public function removeChild(child:IControl):void
		{
			var p:int = _children.indexOf(child);
			if (p != -1)
			{
				_children.splice(p, 1);
				uiMgr.renderer.removeChild(this, child);

				(child as AbstractControl).setHolder(null);
			}
		}

		public function removeChildAt(index:int):IControl
		{
			var child:IControl;
			if (index >= 0 && index < _children.length)
			{
				child = _children.splice(index, 1)[0];
				uiMgr.renderer.removeChild(this, child);

				(child as AbstractControl).setHolder(null);
			}

			return child;
		}

		public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			if (endIndex <= beginIndex)
			{
				return;
			}

			if (beginIndex < 0)
			{
				beginIndex = 0;
			}

			var length:int = _children.length;
			if (endIndex > length)
			{
				endIndex = length;
			}

			var removedControl:Vector.<IControl> = _children.splice(beginIndex, endIndex - beginIndex);
			uiMgr.renderer.removeChildren(this, removedControl);

			for each (var child:IControl in removedControl)
			{
				(child as AbstractControl).setHolder(null);
			}
		}

		public function getChildAt(index:int):IControl
		{
			if (index >= 0 && index < _children.length)
			{
				return _children[index];
			}
			return null;
		}
		
		public function getChildByName(name:String):IControl
		{
			for each (var ic:IControl in _children)
			{
				if (ic.name == name)
				{
					return ic;
				}
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
			if (p == -1 || p == index || index < 0 || index > _children.length)
			{
				return;
			}

			_children.splice(p, 1);
			_children.splice(index, 0, child);

			uiMgr.renderer.updateChildIndex(this, child);
		}

		public function swapChildren(child1:IControl, child2:IControl):void
		{
			var p1:int = _children.indexOf(child1);
			var p2:int = _children.indexOf(child2);
			swapChildrenAt(p1, p2);
		}

		public function swapChildrenAt(index1:int, index2:int):void
		{
			var length:int = _children.length;
			if (index1 < 0 || index1 >= length || index2 < 0 || index2 >= length || index1 == index2)
			{
				return;
			}

			var child1:IControl = _children[index1];
			var child2:IControl = _children[index2];
			_children[index1] = child2;
			_children[index2] = child1;

			uiMgr.renderer.updateChildIndex(this, child1);
			uiMgr.renderer.updateChildIndex(this, child2);
		}

	}
}
