package com.macro.gUI.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IDrag;
	import com.macro.gUI.base.feature.IFocus;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.containers.Panel;
	import com.macro.gUI.controls.Cell;
	import com.macro.gUI.controls.Slice;
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
	public class List extends AbstractComposite implements IDrag, IButton, IFocus
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
		 * 鼠标点击的对象
		 */
		private var _mouseObj:IControl;

		/**
		 * 选中的列表项
		 */
		private var _selectItem:Cell;


		/**
		 * 列表框控件，始终完全缩放，不支持布局对齐
		 * @param bgSkin 背景皮肤
		 * @param width 宽度，默认100
		 * @param height 高度，默认100
		 *
		 */
		public function List(bgSkin:ISkin = null, width:int = 100, height:int = 100)
		{
			super(width, height, 0x11);

			bgSkin = bgSkin ? bgSkin : GameUI.skinManager.getSkin(SkinDef.LIST_BG);

			_itemContainer = new Container();
			_scrollBar = new VScrollBar();

			_container = new Panel(width, height, bgSkin);
			_container.addChild(_itemContainer);

			_cellSkin = GameUI.skinManager.getSkin(SkinDef.CELL_BG);
			_cellSelectedSkin = GameUI.skinManager.getSkin(SkinDef.CELL_SELECTED_BG);

			resize(_rect.width, _rect.height);
		}



		private var _cellSkin:ISkin;

		/**
		 * 列表项背景皮肤
		 * @return
		 *
		 */
		public function get cellSkin():ISkin
		{
			return _cellSkin;
		}

		public function set cellSkin(value:ISkin):void
		{
			_cellSkin = value;
			resetSkin();
		}


		private var _cellSelectedSkin:ISkin;

		/**
		 *列表项选中时的背景皮肤
		 * @return
		 *
		 */
		public function get cellSelectedSkin():ISkin
		{
			return _cellSelectedSkin;
		}

		public function set cellSelectedSkin(value:ISkin):void
		{
			_cellSelectedSkin = value;
			resetSkin();
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



		private var _tabIndex:int;

		public function get tabIndex():int
		{
			return _tabIndex;
		}

		public function set tabIndex(value:int):void
		{
			_tabIndex = value;
		}



		public function get dragMode():int
		{
			return _scrollBar.dragMode;
		}



		public override function hitTest(x:int, y:int):IControl
		{
			_mouseObj == null;

			if (_scrollBar.parent != null)
			{
				_mouseObj = _scrollBar.hitTest(x, y);
			}

			// 检测是否在控件范围内
			if (_mouseObj == null)
			{
				var p:Point = _container.globalCoord();
				x -= p.x;
				y -= p.y;

				if (x >= 0 && x <= _rect.width && y >= 0 && y <= _rect.height)
				{
					_mouseObj = this;

					// 检测是否在列表项范围
					x -= _container.margin.x;
					y -= _container.margin.y;
					
					if (x >= 0 && x <= _container.contentWidth && y >= 0 && y <= _container.contentHeight)
					{
						for each (var cell:Cell in _itemContainer.children)
						{
							if (cell.rect.contains(x, y))
							{
								_mouseObj = cell;
							}
						}
					}
				}
			}

			return _mouseObj;
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


		/**
		 * 添加列表项
		 * @param text
		 * @param index 默认值-1表示添加到末尾
		 *
		 */
		public function addItem(text:String, index:int = -1):void
		{
			var cell:Cell = new Cell(text, _cellSkin);

			if (index < 0)
			{
				_itemContainer.addChild(cell);
			}
			else
			{
				_itemContainer.addChildAt(cell, index);
			}

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



		public function mouseDown():void
		{
			if (_mouseObj == this)
			{
				return;
			}
			else if (_mouseObj is Cell)
			{
				if (_selectItem != null)
				{
					_selectItem.skin = _cellSkin;
				}
				_selectItem = _mouseObj as Cell;
				_selectItem.skin = _cellSelectedSkin;
			}
			else
			{
				_scrollBar.mouseDown();
			}
		}

		public function mouseUp():void
		{
			if (_mouseObj != this && !(_mouseObj is Cell))
			{
				_scrollBar.mouseUp();
			}
		}

		public function mouseOut():void
		{
			if (_mouseObj != this && !(_mouseObj is Cell))
			{
				_scrollBar.mouseOut();
			}
		}

		public function mouseOver():void
		{
			if (_mouseObj != this && !(_mouseObj is Cell))
			{
				_scrollBar.mouseOver();
			}
		}


		public function setDragPos(x:int, y:int):void
		{
			if (_mouseObj != this && !(_mouseObj is Cell))
			{
				_scrollBar.setDragPos(x, y);
			}
		}

		public function getDragImage():BitmapData
		{
			return null;
		}
	}
}
