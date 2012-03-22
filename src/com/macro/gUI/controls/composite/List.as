package com.macro.gUI.controls.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.base.AbstractComposite;
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
		
		private var _items:Vector.<Cell>;
		
		private var _selectItem:Cell;
		
		private var _scroller:VScrollBar;
		
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
			_bg = new Slice(width, height, bgSkin);
			
			_items = new Vector.<Cell>();
			_padding = new Rectangle(2, 2);
			
			_cellSkin = GameUI.skinManager.getSkin(SkinDef.CELL_BG);
			_cellSelectedSkin = GameUI.skinManager.getSkin(SkinDef.CELL_SELECTED_BG);
			
			_children.push(_bg);
			
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
			_children.splice(0, _children.length);
			_children.push(_bg);
			_items.splice(0, _items.length);
			
			var cell:Cell;
			for each(var s:String in value)
			{
				cell = new Cell(s, _cellSkin);
				_children.push(cell);
				_items.push(cell);
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
			
			if (_items.length == 0)
			{
				return;
			}
			
			var left:int = _padding.left;
			var top:int = _padding.top;
			var itemH:int = _items[0].height;
			var itemW:int = _rect.width - _padding.left - _padding.right;
			
			if ((itemH * _items.length + _padding.top + _padding.bottom) > _rect.height)
			{
				
			}
			
			var length:int = _items.length;
			var cell:Cell;
			for (var i:int; i < length; i++)
			{
				cell = _items[i];
				cell.x = left;
				cell.y = top + i * itemH;
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
			_children.push(cell);
			
			if (index < 0)
			{
				_items.push(cell);
			}
			else
			{
				_items.splice(index, 0, cell);
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
			if (index < 0 || index >= _items.length)
			{
				return;
			}
			
			var cell:Cell = _items.splice(index, 1)[0];
			var i:int = _children.indexOf(cell);
			if (i != -1)
			{
				_children.splice(i, 1);
			}
			
			layout();
		}
		
		/**
		 * 移除所有列表项
		 * 
		 */
		public function clearItems():void
		{
			_children.splice(0, _children.length);
			_children.push(_bg);
			_items.splice(0, _items.length);
			
			layout();
		}
		
		private function resetSkin():void
		{
			for each (var cell:Cell in _items)
			{
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