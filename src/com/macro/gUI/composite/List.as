package com.macro.gUI.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Cell;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.geom.Rectangle;
	
	/**
	 * 列表框控件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class List extends AbstractComposite
	{
		
		private var _bg:Slice;
		
		private var _selectItem:Cell;
		
		
		private var _itemContainer:Container;
		
		private var _scrollBar:VScrollBar;
		
		
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
			_bg = new Slice(bgSkin, width, height);
			
			_itemContainer = new Container();
			_scrollBar = new VScrollBar();
			
			_container = new Container();
			_container.addChild(_bg);
			_container.addChild(_itemContainer);
			
			_padding = new Rectangle(2, 2);
			
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
		
		
		private var _padding:Rectangle;
		/**
		 * 滑槽与四周的边距
		 * @return
		 *
		 */
		public function get padding():Rectangle
		{
			return _padding;
		}
		
		public function set padding(value:Rectangle):void
		{
			if (!_padding || !_padding.equals(value))
			{
				_padding = value;
				layout();
			}
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
			for each(var s:String in value)
			{
				cell = new Cell(s, _cellSkin);
				_itemContainer.addChild(cell);
			}
			
			layout();
		}
		
		
		public override function set align(value:int):void
		{
			throw new Error("Unsupport Property!");
		}
		
		
		
		protected override function layout():void
		{
			_bg.resize(_rect.width, _rect.height);
			
			if (_itemContainer.numChildren == 0)
			{
				return;
			}
			
			var itemH:int = (_itemContainer.getChildAt(0) as Cell).height;
			var itemW:int = _rect.width - _padding.left - _padding.right;
			
			if ((itemH * _itemContainer.numChildren + _padding.top + _padding.bottom) > _rect.height)
			{
				itemW -= _scrollBar.width;
				_container.addChild(_scrollBar);
				_scrollBar.x = _padding.left + itemW;
				_scrollBar.y = _padding.top;
				_scrollBar.height = _rect.height - _padding.top - _padding.bottom;
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
				cell.x = _padding.left;
				cell.y = _padding.top + i * itemH;
				cell.width = itemW;
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
	}
}