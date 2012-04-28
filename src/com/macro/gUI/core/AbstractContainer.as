package com.macro.gUI.core
{

	import avmplus.getQualifiedClassName;
	
	import com.macro.gUI.assist.CHILD_REGION;
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
			var p:Point = globalToLocal(new Point(x, y));
			if (p.x < 0 || p.y < 0 || p.x > _rect.width || p.y > _rect.height)
			{
				return null;
			}

			if (p.x >= _margin.left && p.x <= _rect.width - _margin.right &&
					p.y >= _margin.top &&
					p.y <= _rect.height - _margin.bottom)
			{
				return new CHILD_REGION();
			}

			return this;
		}



		public function addChild(child:IControl):void
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			
			_children.push(child);
			(child as AbstractControl).setParent(this);
			setChildStage(child, stage);

			uiManager.renderer.addChild(this, child);
		}

		public function addChildAt(child:IControl, index:int):void
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
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
			(child as AbstractControl).setParent(this);
			setChildStage(child, stage);

			uiManager.renderer.addChild(this, child);
		}

		public function removeChild(child:IControl):void
		{
			var p:int = _children.indexOf(child);
			if (p != -1)
			{
				_children.splice(p, 1);

				(child as AbstractControl).setParent(null);
				setChildStage(child, null);

				uiManager.renderer.removeChild(this, child);
			}
		}

		public function removeChildAt(index:int):IControl
		{
			var child:IControl;
			if (index >= 0 && index < _children.length)
			{
				child = _children.splice(index, 1)[0];

				(child as AbstractControl).setParent(null);
				setChildStage(child, null);

				uiManager.renderer.removeChild(this, child);
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

			var child:IControl;
			for (var i:int = beginIndex; i < endIndex; i++)
			{
				child = _children[i];
				(child as AbstractControl).setParent(null);
				setChildStage(child, null);
			}
			var removedControl:Vector.<IControl> = _children.splice(beginIndex, endIndex - beginIndex);

			uiManager.renderer.removeChildren(this, removedControl);
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
			if (p == -1 || p == index || index < 0 || index > _children.length)
			{
				return;
			}

			_children.splice(p, 1);
			_children.splice(index, 0, child);

			uiManager.renderer.updateChildIndex(this, child);
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
			if (index1 < 0 || index1 >= length || index2 < 0 ||
					index2 >= length ||
					index1 == index2)
			{
				return;
			}

			var child1:IControl = _children[index1];
			var child2:IControl = _children[index2];

			_children.splice(index2, 1, child1);
			_children.splice(index1, 1, child2);

			uiManager.renderer.updateChildIndex(this, child1);
			uiManager.renderer.updateChildIndex(this, child2);
		}


		private function setChildStage(child:IControl, stage:IContainer):void
		{
			if (child is IComposite)
			{
				setChildStage((child as IComposite).container, stage);
				return;
			}

			(child as AbstractControl).setStage(stage);

			if (child is IContainer)
			{
				var container:IContainer = child as IContainer;
				for each (var control:IControl in container.children)
				{
					setChildStage(control, stage);
				}
			}
		}
	}
}
