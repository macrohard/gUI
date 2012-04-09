package com.macro.gUI.composite
{
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IDrag;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.containers.Panel;
	import com.macro.gUI.controls.Cell;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 列表框控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class List extends AbstractComposite implements IDrag, IButton
	{

		/**
		 * 列表项容器
		 */
		private var _itemContainer:Container;

		/**
		 * 垂直滚动条
		 */
		private var _scrollBar:VScrollBar;

		/**
		 * 选中的列表项
		 */
		private var _selectItem:Cell;


		/**
		 * 列表项背景皮肤
		 */
		private var _cellSkin:ISkin;

		/**
		 * 列表项选中状态时的背景皮肤
		 */
		private var _cellSelectedSkin:ISkin;


		/**
		 * 列表框控件
		 * @param width 宽度，默认100
		 * @param height 高度，默认100
		 *
		 */
		public function List(width:int = 100, height:int = 100)
		{
			super(width, height);

			_itemContainer = new Container();
			_scrollBar = new VScrollBar();

			_container = new Panel(width, height);
			(_container as Panel).skin = skinManager.getSkin(SkinDef.LIST_BG);
			_container.addChild(_itemContainer);

			_cellSkin = skinManager.getSkin(SkinDef.CELL_BG);
			_cellSelectedSkin = skinManager.getSkin(SkinDef.CELL_SELECTED_BG);

			_rect = _container.rect;
			layout();
		}


		/**
		 * 一次性设置所有列表项
		 * @param value
		 *
		 */
		public function set items(value:Vector.<String>):void
		{
			_itemContainer.removeChildren();

			var cell:Cell;
			for each (var s:String in value)
			{
				cell = new Cell(s, _cellSkin);
				_itemContainer.addChild(cell);
			}

			layout();
		}


		/**
		 * 选择项索引
		 * @return
		 *
		 */
		public function get selectedIndex():int
		{
			return _itemContainer.children.indexOf(_selectItem);
		}

		public function set selectedIndex(value:int):void
		{
			_selectItem = _itemContainer.getChildAt(value) as Cell;
			resetSkin();
		}


		/**
		 * 获取选择项文本
		 * @return
		 *
		 */
		public function get selectedText():String
		{
			return _selectItem.text;
		}



		/**
		 * 设置背景皮肤
		 * @param bgSkin
		 *
		 */
		public function setBgSkin(bgSkin:ISkin):void
		{
			(_container as Panel).skin = bgSkin;
		}


		/**
		 * 设置列表项皮肤
		 * @param cellSkin
		 * @param cellSelectedSkin
		 *
		 */
		public function setItemSkin(cellSkin:ISkin, cellSelectedSkin:ISkin):void
		{
			_cellSkin = cellSkin;
			_cellSelectedSkin = cellSelectedSkin;
			resetSkin();
		}
		
		
		
		/**
		 * 添加列表项
		 * @param text
		 * @param index 索引位置，默认值int.MAX_VALUE表示添加到末尾
		 *
		 */
		public function addItem(text:String, index:int = int.MAX_VALUE):void
		{
			_itemContainer.addChildAt(new Cell(text, _cellSkin), index);
			layout();
		}
		
		/**
		 * 移除列表项
		 * @param index
		 *
		 */
		public function removeItem(index:int):void
		{
			_itemContainer.removeChildAt(index);
			
			layout();
		}
		
		/**
		 * 移除所有列表项
		 *
		 */
		public function clearItems():void
		{
			_itemContainer.removeChildren();
			
			layout();
		}
		
		
		private function resetSkin():void
		{
			var cell:Cell;
			for each (var ic:IControl in _itemContainer.children)
			{
				cell = ic as Cell;
				if (cell == _selectItem)
				{
					cell.skin = _cellSelectedSkin;
				}
				else
				{
					cell.skin = _cellSkin;
				}
			}
		}



		public override function hitTest(x:int, y:int):IControl
		{
			var target:IControl;

			if (_scrollBar.parent != null)
			{
				target = _scrollBar.hitTest(x, y);
				if (target != null)
				{
					return target;
				}
			}

			// 检测是否在控件范围内
			var p:Point = _container.globalToLocal(x, y);

			if (p.x >= 0 && p.x <= _rect.width && p.y >= 0 && p.y <= _rect.height)
			{
				target = _container;

				// 检测是否在列表项范围
				p.x -= _container.margin.left;
				p.y -= _container.margin.top;

				if (p.x >= 0 && p.x <= _container.contentWidth && p.y >= 0 && p.y <= _container.contentHeight)
				{
					p.y -= _itemContainer.y;
					for each (var cell:Cell in _itemContainer.children)
					{
						if (cell.rect.containsPoint(p))
						{
							target = cell;
						}
					}
				}
			}

			return target;
		}



		protected override function layout():void
		{
			if (_itemContainer.numChildren == 0)
			{
				return;
			}

			var w:int = _container.contentWidth;
			var h:int = _container.contentHeight;
			var itemH:int = (_itemContainer.getChildAt(0) as Cell).height;
			var totalH:int = itemH * _itemContainer.numChildren;

			_itemContainer.resize(w, totalH);

			if (totalH > h)
			{
				w -= _scrollBar.width;

				_container.addChild(_scrollBar);
				_scrollBar.x = w;
				_scrollBar.height = h;
				_scrollBar.viewport = new Viewport(new Rectangle(0, 0, w, h), _itemContainer);
			}
			else
			{
				_container.removeChild(_scrollBar);
				_itemContainer.y = 0;
			}

			var length:int = _itemContainer.numChildren;
			var cell:Cell;
			for (var i:int; i < length; i++)
			{
				cell = _itemContainer.getChildAt(i) as Cell;
				cell.y = i * itemH;
				cell.width = w;
			}
		}



		public function mouseDown(target:IControl):void
		{
			if (target is Cell)
			{
				if (_selectItem != null)
				{
					_selectItem.skin = _cellSkin;
				}
				_selectItem = target as Cell;
				_selectItem.skin = _cellSelectedSkin;
			}
			else if (target.parent == _scrollBar.container)
			{
				_scrollBar.mouseDown(target);
			}
		}

		public function mouseUp(target:IControl):void
		{
			if (target.parent == _scrollBar.container)
			{
				_scrollBar.mouseUp(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			if (target.parent == _scrollBar.container)
			{
				_scrollBar.mouseOut(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target.parent == _scrollBar.container)
			{
				_scrollBar.mouseOver(target);
			}
		}



		public function getDragMode(target:IControl):int
		{
			if (target.parent == _scrollBar.container)
			{
				return _scrollBar.getDragMode(target);
			}
			return DragMode.NONE;
		}

		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			_scrollBar.setDragCoord(target, x, y);
		}

		public function getDragImage():BitmapData
		{
			return null;
		}
	}
}
