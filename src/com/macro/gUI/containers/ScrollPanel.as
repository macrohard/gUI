package com.macro.gUI.containers
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.composite.HScrollBar;
	import com.macro.gUI.composite.VScrollBar;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.AbstractContainer;
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 带滚动条的面板容器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ScrollPanel extends AbstractComposite implements IContainer, IDrag, IButton
	{
		/**
		 * 显示容器
		 */
		protected var _displayContainer:Container;

		/**
		 * 内容容器
		 */
		protected var _contentContainer:Container;

		/**
		 * 水平滚动条
		 */
		protected var _hScrollBar:HScrollBar;

		/**
		 * 垂直滚动条
		 */
		protected var _vScrollBar:VScrollBar;


		/**
		 * 带滚动条的面板容器
		 * @param width
		 * @param height
		 *
		 */
		public function ScrollPanel(width:int = 100, height:int = 100)
		{
			super(width, height);

			_vScrollBar = new VScrollBar();
			_hScrollBar = new HScrollBar();

			_displayContainer = new Container();
			_contentContainer = new Container();
			_displayContainer.addChild(_contentContainer);

			_container = new Panel(width, height);
			(_container as Panel).bgSkin = skinMgr.getSkin(SkinDef.SCROLLPANEL_BG);
			_container.addChild(_displayContainer);

			_width = _container.width;
			_height = _container.height;
			layout();
		}


		public function get margin():Margin
		{
			return _container.margin;
		}

		public function set margin(value:Margin):void
		{
			_container.margin = value;
		}


		public function get children():Vector.<IControl>
		{
			return _contentContainer.children;
		}

		public function get numChildren():int
		{
			return _contentContainer.numChildren;
		}


		/**
		 * 设置背景皮肤
		 * @param bgSkin
		 *
		 */
		public function setBgSkin(bgSkin:ISkin):void
		{
			(_container as Panel).bgSkin = bgSkin;
		}



		override public function hitTest(x:int, y:int):IControl
		{
			var target:IControl;

			if (_vScrollBar.holder != null)
			{
				target = _vScrollBar.hitTest(x, y);
				if (target != null)
				{
					return target;
				}
			}

			if (_hScrollBar.holder != null)
			{
				target = _hScrollBar.hitTest(x, y);
				if (target != null)
				{
					return target;
				}
			}

			// 检测是否在控件范围内
			var p:Point = _container.globalToLocal(new Point(x, y));
			if (p.x < 0 || p.y < 0 || p.x > _width || p.y > _height)
			{
				return null;
			}

			if (_displayContainer.rect.containsPoint(p))
			{
				return AbstractContainer.CHILD_REGION;
			}

			return _container;
		}


		override protected function layout():void
		{
			if (_contentContainer.numChildren == 0)
			{
				return;
			}

			var maxW:int = _container.contentWidth;
			var maxH:int = _container.contentHeight;
			var minW:int = maxW - _vScrollBar.width;
			var minH:int = maxH - _hScrollBar.height;

			// 取得所有控件的完整大小
			var length:int = _contentContainer.numChildren;
			var rect:Rectangle = _contentContainer.getChildAt(0).rect;
			for (var i:int = 1; i < length; i++)
			{
				rect = rect.union(_contentContainer.getChildAt(i).rect);
			}

			_contentContainer.resize(rect.right, rect.bottom);

			// 0表示没有滚动条，1表示出现水平滚动条，2表示出现垂直滚动条，3表示同时出现两者
			var scrollVisible:int;

			if (_contentContainer.width > maxW)
			{
				scrollVisible |= 1;
				if (_contentContainer.height > minH)
				{
					scrollVisible |= 2;
				}
			}

			if (_contentContainer.height > maxH)
			{
				scrollVisible |= 2;
				if (_contentContainer.width > minW)
				{
					scrollVisible |= 1;
				}
			}

			if (scrollVisible == 0)
			{
				_container.removeChild(_vScrollBar);
				_container.removeChild(_hScrollBar);
				_displayContainer.resize(maxW, maxH);
				_contentContainer.x = _contentContainer.y = 0;
			}
			else if (scrollVisible == 1)
			{
				_container.removeChild(_vScrollBar);
				_container.addChild(_hScrollBar);
				_displayContainer.resize(maxW, minH);
				_hScrollBar.y = minH;
				_hScrollBar.width = maxW;
				_hScrollBar.viewport = new Viewport(_displayContainer.rect, _contentContainer);
				_contentContainer.y = 0;
			}
			else if (scrollVisible == 2)
			{
				_container.removeChild(_hScrollBar);
				_container.addChild(_vScrollBar);
				_displayContainer.resize(minW, maxH);
				_vScrollBar.x = minW;
				_vScrollBar.height = maxH;
				_vScrollBar.viewport = new Viewport(_displayContainer.rect, _contentContainer);
				_contentContainer.x = 0;
			}
			else
			{
				_container.addChild(_hScrollBar);
				_container.addChild(_vScrollBar);
				_displayContainer.resize(minW, minH);
				_hScrollBar.y = minH;
				_hScrollBar.width = minW;
				_vScrollBar.x = minW;
				_vScrollBar.height = minH;

				_hScrollBar.viewport = new Viewport(_displayContainer.rect, _contentContainer);
				_vScrollBar.viewport = _hScrollBar.viewport;
			}
		}



		public function mouseDown(target:IControl):void
		{
			if (target.holder == _vScrollBar.container)
			{
				_vScrollBar.mouseDown(target);
			}
			else if (target.holder == _hScrollBar.container)
			{
				_hScrollBar.mouseDown(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			if (target.holder == _vScrollBar.container)
			{
				_vScrollBar.mouseOut(target);
			}
			else if (target.holder == _hScrollBar.container)
			{
				_hScrollBar.mouseOut(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target.holder == _vScrollBar.container)
			{
				_vScrollBar.mouseOver(target);
			}
			else if (target.holder == _hScrollBar.container)
			{
				_hScrollBar.mouseOver(target);
			}
		}

		public function mouseUp(target:IControl):void
		{
			if (target.holder == _vScrollBar.container)
			{
				_vScrollBar.mouseUp(target);
			}
			else if (target.holder == _hScrollBar.container)
			{
				_hScrollBar.mouseUp(target);
			}
		}

		public function getDraggable(target:IControl):Boolean
		{
			if (target.holder == _vScrollBar.container)
			{
				return _vScrollBar.getDraggable(target);
			}
			else if (target.holder == _hScrollBar.container)
			{
				return _hScrollBar.getDraggable(target);
			}
			return false;
		}

		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			if (target.holder == _vScrollBar.container)
			{
				return _vScrollBar.setDragCoord(target, x, y);
			}
			else if (target.holder == _hScrollBar.container)
			{
				return _hScrollBar.setDragCoord(target, x, y);
			}
		}



		public function addChild(child:IControl):void
		{
			_contentContainer.addChild(child);
			setChildParent(child as AbstractControl);
			layout();
		}

		public function addChildAt(child:IControl, index:int):void
		{
			_contentContainer.addChildAt(child, index);
			setChildParent(child as AbstractControl);
			layout();
		}

		public function removeChild(child:IControl):void
		{
			_contentContainer.removeChild(child);
			layout();
		}

		public function removeChildAt(index:int):IControl
		{
			var c:IControl = _contentContainer.removeChildAt(index);
			layout();
			return c;
		}

		public function removeChildren(beginIndex:int = 0, endIndex:int = -1):void
		{
			_contentContainer.removeChildren(beginIndex, endIndex);
			layout();
		}

		public function getChildAt(index:int):IControl
		{
			return _contentContainer.getChildAt(index);
		}
		
		public function getChildByName(name:String):IControl
		{
			return _contentContainer.getChildByName(name);
		}

		public function getChildIndex(child:IControl):int
		{
			return _contentContainer.getChildIndex(child);
		}

		public function setChildIndex(child:IControl, index:int):void
		{
			_contentContainer.setChildIndex(child, index);
		}

		public function swapChildren(child1:IControl, child2:IControl):void
		{
			_contentContainer.swapChildren(child1, child2);
		}

		public function swapChildrenAt(index1:int, index2:int):void
		{
			_contentContainer.swapChildrenAt(index1, index2);
		}
	}
}
