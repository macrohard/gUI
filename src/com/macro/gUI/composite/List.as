package com.macro.gUI.composite
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.containers.Panel;
	import com.macro.gUI.controls.ToggleButton;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.events.UIEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

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
		protected var _itemContainer:Container;

		/**
		 * 垂直滚动条
		 */
		protected var _scrollBar:VScrollBar;

		/**
		 * 选中的列表项
		 */
		protected var _selectItem:ToggleButton;

		/**
		 * 列表项数据
		 */
		private var _items:Vector.<String>;


		/**
		 * 列表项文本样式
		 */
		private var _itemStyle:TextStyle;

		/**
		 * 列表项选中文本样式
		 */
		private var _itemSelectedStyle:TextStyle;

		/**
		 * 列表项背景皮肤
		 */
		private var _itemSkin:ISkin;

		/**
		 * 列表项悬停状态时的背景皮肤
		 */
		private var _itemOverSkin:ISkin;

		/**
		 * 列表项选中状态时的背景皮肤
		 */
		private var _itemSelectedSkin:ISkin;


		/**
		 * 列表框控件
		 * @param width 宽度，默认100
		 * @param height 高度，默认100
		 *
		 */
		public function List(width:int = 100, height:int = 100)
		{
			super(width, height);

			_items = new Vector.<String>();
			_itemContainer = new Container();
			_scrollBar = new VScrollBar();

			_container = new Panel(width, height);
			(_container as Panel).bgSkin = skinMgr.getSkin(SkinDef.LIST_BG);
			_container.addChild(_itemContainer);

			_itemStyle = skinMgr.getStyle(StyleDef.LIST_ITEM);
			_itemSelectedStyle = skinMgr.getStyle(StyleDef.LIST_ITEM_SELECTED);

			_itemSkin = skinMgr.getSkin(SkinDef.LIST_ITEM_BG);
			_itemOverSkin = skinMgr.getSkin(SkinDef.LIST_ITEM_OVER_BG);
			_itemSelectedSkin = skinMgr.getSkin(SkinDef.LIST_ITEM_SELECTED_BG);

			_width = _container.width;
			_height = _container.height;
			layout();
		}


		/**
		 * 所有列表项
		 * @param value
		 *
		 */
		public function get items():Vector.<String>
		{
			return _items;
		}

		public function set items(value:Vector.<String>):void
		{
			_itemContainer.removeChildren();

			_items = value;
			for each (var s:String in value)
			{
				_itemContainer.addChild(createItem(s));
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
			return _itemContainer.getChildIndex(_selectItem);
		}

		public function set selectedIndex(value:int):void
		{
			_selectItem = _itemContainer.getChildAt(value) as ToggleButton;
			resetSkin();

			dispatchEvent(new UIEvent(UIEvent.SELECT));
		}


		/**
		 * 获取选择项文本
		 * @return
		 *
		 */
		public function get selectedText():String
		{
			if (_selectItem != null)
			{
				return _selectItem.text;
			}
			return null;
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


		/**
		 * 设置列表项皮肤
		 * @param cellSkin
		 * @param cellSelectedSkin
		 *
		 */
		public function setItemSkin(itemSkin:ISkin, itemOverSkin:ISkin, itemSelectedSkin:ISkin):void
		{
			_itemSkin = itemSkin;
			_itemOverSkin = itemOverSkin;
			_itemSelectedSkin = itemSelectedSkin;
			resetSkin();
		}


		/**
		 * 设置列表项文本样式
		 * @param itemStyle
		 * @param itemSelectedStyle
		 *
		 */
		public function setItemStyle(itemStyle:TextStyle, itemSelectedStyle:TextStyle):void
		{
			_itemStyle = itemStyle;
			_itemSelectedStyle = itemSelectedStyle;
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
			_itemContainer.addChildAt(createItem(text), index);
			if (index < 1)
			{
				_items.unshift(text);
			}
			else if (index >= _itemContainer.numChildren)
			{
				_items.push(text);
			}
			else
			{
				_items.splice(index, 0, text);
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
			if (index >= 0 && index < _items.length)
			{
				_items.splice(index, 1);
			}
			if (_selectItem == _itemContainer.removeChildAt(index))
			{
				_selectItem = null;
				dispatchEvent(new UIEvent(UIEvent.SELECT));
			}
			layout();
		}

		/**
		 * 移除所有列表项
		 *
		 */
		public function clearItems():void
		{
			_itemContainer.removeChildren();
			_items.splice(0, _items.length);
			layout();
		}


		private function createItem(text:String):ToggleButton
		{
			var item:ToggleButton = new ToggleButton(text);
			item.style = item.overStyle = item.downStyle = _itemStyle;
			item.selectedStyle = item.selectedOverStyle = item.selectedDownStyle = _itemSelectedStyle;
			item.upSkin = _itemSkin;
			item.overSkin = item.downSkin = _itemOverSkin;
			item.selectedSkin = item.selectedOverSkin = item.selectedDownSkin = _itemSelectedSkin;
			item.autoSize = false;
			return item;
		}


		private function resetSkin():void
		{
			for each (var item:ToggleButton in _itemContainer.children)
			{
				item.style = item.overStyle = item.downStyle = _itemStyle;
				item.selectedStyle = item.selectedOverStyle = item.selectedDownStyle = _itemSelectedStyle;
				item.upSkin = _itemSkin;
				item.overSkin = item.downSkin = _itemOverSkin;
				item.selectedSkin = item.selectedOverSkin = item.selectedDownSkin = _itemSelectedSkin;
			}
		}



		override public function hitTest(x:int, y:int):IControl
		{
			var target:IControl;

			if (_scrollBar.holder != null)
			{
				target = _scrollBar.hitTest(x, y);
				if (target != null)
				{
					return target;
				}
			}

			// 检测是否在控件范围内
			var p:Point = _container.globalToLocal(new Point(x, y));

			if (p.x >= 0 && p.x <= _width && p.y >= 0 && p.y <= _height)
			{
				target = _container;

				// 检测是否在列表项范围
				p.x -= _container.margin.left;
				p.y -= _container.margin.top;

				if (p.x >= 0 && p.x <= _container.contentWidth && p.y >= 0 && p.y <= _container.contentHeight)
				{
					// 检测是否在列表项范围内
					for each (var item:ToggleButton in _itemContainer.children)
					{
						if (item.hitTest(x, y) != null)
						{
							return item;
						}
					}
				}
			}

			return target;
		}



		/**
		 * 根据行数设置高度
		 * @param lines
		 *
		 */
		public function setHeightByLines(lines:int):void
		{
			var itemH:int;
			if (_itemContainer.numChildren > 0)
			{
				itemH = (_itemContainer.getChildAt(0) as ToggleButton).height;
			}

			this.height = itemH * lines + _container.margin.top + _container.margin.bottom;
		}



		override protected function layout():void
		{
			if (_itemContainer.numChildren == 0)
			{
				return;
			}

			var w:int = _container.contentWidth;
			var h:int = _container.contentHeight;
			var itemH:int = (_itemContainer.getChildAt(0) as ToggleButton).height;
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
			var item:ToggleButton;
			for (var i:int; i < length; i++)
			{
				item = _itemContainer.getChildAt(i) as ToggleButton;
				item.y = i * itemH;
				item.width = w;
			}
		}



		public function mouseDown(target:IControl):void
		{
			if (target is ToggleButton)
			{
				(target as ToggleButton).mouseDown(target);
			}
			else if (target.holder == _scrollBar.container)
			{
				_scrollBar.mouseDown(target);
			}
		}

		public function mouseUp(target:IControl):void
		{
			if (target is ToggleButton)
			{
				if (_selectItem != null)
				{
					_selectItem.selected = false;
				}
				_selectItem = target as ToggleButton;
				_selectItem.mouseUp(target);

				dispatchEvent(new UIEvent(UIEvent.SELECT));
			}
			else if (target.holder == _scrollBar.container)
			{
				_scrollBar.mouseUp(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			if (target is ToggleButton)
			{
				(target as ToggleButton).mouseOut(target);
			}
			else if (target.holder == _scrollBar.container)
			{
				_scrollBar.mouseOut(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target is ToggleButton)
			{
				(target as ToggleButton).mouseOver(target);
			}
			else if (target.holder == _scrollBar.container)
			{
				_scrollBar.mouseOver(target);
			}
		}



		public function getDraggable(target:IControl):Boolean
		{
			if (target.holder == _scrollBar.container)
			{
				return _scrollBar.getDraggable(target);
			}
			return false;
		}

		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			_scrollBar.setDragCoord(target, x, y);
		}
	}
}
