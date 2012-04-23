package com.macro.gUI.containers
{
	import com.macro.gUI.assist.CHILD_REGION;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.controls.TitleBar;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.events.TabEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	import com.macro.gUI.skin.impl.BitmapSkin;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 标签页面板
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TabPanel extends AbstractComposite implements IContainer,
			IButton
	{

		/**
		 * 标签栏在顶部
		 */
		public static const TAB_LAYOUT_TOP:int = 0;

		/**
		 * 标签栏在底部
		 */
		public static const TAB_LAYOUT_BOTTOM:int = 1;


		/**
		 * 内容容器
		 */
		protected var _tabContainers:Vector.<Container>;

		/**
		 * 标签页按钮
		 */
		protected var _tabs:Vector.<TitleBar>;

		/**
		 * 面板背景
		 */
		protected var _bg:Slice;


		/**
		 * 标签样式
		 */
		private var _tabSkin:ISkin;

		/**
		 * 当前选中标签样式
		 */
		private var _tabSelectedSkin:ISkin;

		/**
		 * 标签文本样式
		 */
		private var _tabStyle:TextStyle;



		/**
		 * 当前容器，即选中的标签页的容器
		 */
		protected var _currentContainer:Container;




		/**
		 * 标签页面板，仅支持顶部和底部布局样式。<br/>
		 * 只需定义顶部标签样式即可，底部标签样式将通过垂直翻转得到
		 * @param tabLayout 标签页布局，默认在顶部，参见TAB_LAYOUT_常量
		 * @param tabGap 标签间距
		 * @param width
		 * @param height
		 *
		 */
		public function TabPanel(tabLayout:int = 0, tabGap:int = -1, width:int = 300, height:int = 200)
		{
			super(width, height);

			_tabLayout = tabLayout;
			_tabGap = tabGap;

			_tabContainers = new Vector.<Container>();
			_tabs = new Vector.<TitleBar>();

			_tabSkin = skinManager.getSkin(SkinDef.TABPANEL_TAB);
			_tabSelectedSkin = skinManager.getSkin(SkinDef.TABPANEL_TAB_SELECTED);
			if (_tabLayout == TAB_LAYOUT_BOTTOM)
			{
				_tabSkin = flipVerticalSkin(_tabSkin);
				_tabSelectedSkin = flipVerticalSkin(_tabSelectedSkin);
			}

			_tabStyle = skinManager.getStyle(StyleDef.TAPPANEL_TITLE);

			_bg = new Slice(skinManager.getSkin(SkinDef.TABPANEL_BG), width, height);
			setMargin();

			_container = new Container(width, height);
			_container.addChild(_bg);

			_rect = _container.rect;
			layout();
		}


		private var _tabLayout:int;

		/**
		 * 标签页布局，参见TAB_LAYOUT_常量
		 * @return
		 *
		 */
		public function get tabLayout():int
		{
			return _tabLayout;
		}

		public function set tabLayout(value:int):void
		{
			if (_tabLayout == value)
			{
				return;
			}
			_tabLayout = value;
			_tabSkin = flipVerticalSkin(_tabSkin);
			_tabSelectedSkin = flipVerticalSkin(_tabSelectedSkin);

			resetTabSkin();
			setMargin();
			layout();
		}


		private var _tabGap:int;

		public function get tabGap():int
		{
			return _tabGap;
		}

		public function set tabGap(value:int):void
		{
			_tabGap = value;
			layout();
		}


		/**
		 * 当前选中的标签页索引，-1表示没有标签页被选中
		 * @return
		 *
		 */
		public function get selectedIndex():int
		{
			return _tabContainers.indexOf(_currentContainer);
		}

		public function set selectedIndex(value:int):void
		{
			if (_tabs.length == 0)
			{
				_currentContainer = null;
				return;
			}

			// 索引值超过范围时容错处理
			if (value < 0)
			{
				value = 0;
			}
			else if (value >= _tabs.length)
			{
				value = _tabs.length - 1;
			}

			if (_currentContainer != null)
			{
				var index:int = _tabContainers.indexOf(_currentContainer);
				if (value == index)
				{
					return;
				}
				_tabs[index].skin = _tabSkin;
				_container.removeChild(_currentContainer);
			}

			_currentContainer = _tabContainers[value];
			_container.addChild(_currentContainer);
			_tabs[_tabContainers.indexOf(_currentContainer)].skin = _tabSelectedSkin;

			layout();
			
			dispatchEvent(new TabEvent(TabEvent.TAB_CHANGED));
		}


		private var _margin:Margin;

		public function get margin():Margin
		{
			return _margin;
		}

		public function set margin(value:Margin):void
		{
			_margin = value;
			layout();
		}


		public function get children():Vector.<IControl>
		{
			if (_currentContainer != null)
			{
				return _currentContainer.children;
			}
			return null;
		}


		public function get numChildren():int
		{
			if (_currentContainer != null)
			{
				return _currentContainer.numChildren;
			}
			return 0;
		}



		/**
		 * 设置背景皮肤
		 * @param bgSkin
		 *
		 */
		public function setBgSkin(bgSkin:ISkin):void
		{
			_bg.skin = bgSkin;
			setMargin();
			layout();
		}


		/**
		 * 设置标签皮肤，只能设置顶部的标签皮肤样式，底部将通过垂直翻转得到
		 * @param tabSkin
		 * @param tabSelectedSkin
		 *
		 */
		public function setTabSkin(tabSkin:ISkin, tabSelectedSkin:ISkin):void
		{
			if (_tabLayout == TAB_LAYOUT_TOP)
			{
				_tabSkin = tabSkin;
				_tabSelectedSkin = tabSelectedSkin;
			}
			else
			{
				_tabSkin = flipVerticalSkin(tabSkin);
				_tabSelectedSkin = flipVerticalSkin(tabSelectedSkin);
			}
			resetTabSkin();
			setMargin();
			layout();
		}

		/**
		 * 设置标签文本样式
		 * @param tabStyle
		 *
		 */
		public function setTabStyle(tabStyle:TextStyle):void
		{
			_tabStyle = tabStyle;
			for each (var tab:TitleBar in _tabs)
			{
				tab.style = _tabStyle;
			}
			setMargin();
			layout();
		}


		/**
		 * 重置所有标签按钮的皮肤
		 *
		 */
		private function resetTabSkin():void
		{
			var index:int = this.selectedIndex;
			for (var i:int = _tabs.length - 1; i >= 0; i--)
			{
				if (i == index)
				{
					_tabs[i].skin = _tabSelectedSkin;
				}
				else
				{
					_tabs[i].skin = _tabSkin;
				}
			}
		}


		/**
		 * 垂直翻转皮肤
		 *
		 */
		private function flipVerticalSkin(source:ISkin):ISkin
		{
			var bmpd:BitmapData = new BitmapData(source.bitmapData.width, source.bitmapData.height, true, 0);
			bmpd.draw(source.bitmapData, new Matrix(1, 0, 0, -1, 0, bmpd.height), null, null, null, true);

			return new BitmapSkin(bmpd,
								  new Rectangle(source.gridLeft, source.gridTop, source.gridRight - source.gridLeft,
												source.gridBottom - source.gridTop), source.align);
		}


		/**
		 * 设置可视间距
		 *
		 */
		private function setMargin():void
		{
			_margin = new Margin(_bg.skin.gridLeft, _bg.skin.gridTop, _bg.skin.paddingRight, _bg.skin.paddingBottom);
			if (_tabs.length > 0)
			{
				var tab:TitleBar = _tabs[0];
				if (_tabLayout == TAB_LAYOUT_TOP)
				{
					_margin.top = tab.height + _bg.skin.gridTop;
				}
				else
				{
					_margin.bottom = tab.height + _bg.skin.paddingBottom;
				}
			}
		}



		/**
		 * 添加标签页
		 * @param title
		 * @param index 索引位置，默认值int.MAX_VALUE表示添加到末尾
		 * @return
		 *
		 */
		public function addTab(title:String, index:int = int.MAX_VALUE):Container
		{
			var tab:TitleBar = new TitleBar(title, _tabSkin, true);
			tab.style = _tabStyle;
			tab.padding = new Margin(8, 0, 8, 0);

			var tabContainer:Container = new Container();

			if (index < 0)
			{
				index = 0;
				_tabs.unshift(tab);
				_tabContainers.unshift(tabContainer);
			}
			else if (index >= _tabs.length)
			{
				index = _tabs.length;
				_tabs.push(tab);
				_tabContainers.push(tabContainer);
			}
			else
			{
				_tabs.splice(index, 0, tab);
				_tabContainers.splice(index, 0, tabContainer);
			}

			if (_tabs.length == 1)
			{
				setMargin();
			}

			_container.addChild(tab);
			selectedIndex = index;

			return tabContainer;
		}


		public function setTabTitle(index:int, title:String):void
		{
			if (index >= 0 && index < _tabs.length)
			{
				var tab:TitleBar = _tabs[index];
				tab.text = title;
				layout();
			}
		}


		/**
		 * 移除标签页
		 * @param index
		 *
		 */
		public function removeTab(index:int):void
		{
			if (index >= 0 && index < _tabs.length)
			{
				_container.removeChild(_tabs.splice(index, 1)[0]);

				var tabContainer:Container = _tabContainers.splice(index, 1)[0];
				_container.removeChild(tabContainer);

				if (_tabs.length == 0)
				{
					setMargin();
				}

				if (tabContainer == _currentContainer) // 移除的是当前索引项时，重设索引
				{
					selectedIndex = index;
				}
				else // 移除的不是当前索引项时，重新布局
				{
					layout();
				}
			}
		}

		/**
		 * 清除所有标签页
		 *
		 */
		public function clearTabs():void
		{
			for each (var tab:TitleBar in _tabs)
			{
				_container.removeChild(tab);
			}

			if (_currentContainer != null)
			{
				_container.removeChild(_currentContainer);
			}
			_currentContainer = null;

			_tabs.splice(0, _tabs.length);
			_tabContainers.splice(0, _tabContainers.length);

			setMargin();
			layout();
			
			dispatchEvent(new TabEvent(TabEvent.TAB_CHANGED));
		}


		/**
		 * 获取标签页容器
		 * @param index
		 * @return
		 *
		 */
		public function getTabContainer(index:int):Container
		{
			if (index >= 0 && index < _tabContainers.length)
			{
				return _tabContainers[index];
			}
			return null;
		}



		public override function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(x, y);
			if (p.x < 0 || p.y < 0 || p.x > _rect.width || p.y > _rect.height)
			{
				return null;
			}

			for (var i:int = _tabs.length - 1; i >= 0; i--)
			{
				var tab:TitleBar = _tabs[i];
				if (tab.rect.containsPoint(p))
				{
					return tab;
				}
			}

			if (_currentContainer != null &&
					_currentContainer.rect.containsPoint(p))
			{
				return new CHILD_REGION();
			}

			return _container;
		}



		protected override function layout():void
		{
			var length:int = _tabs.length;

			if (length == 0)
			{
				_bg.y = 0;
				_bg.resize(_rect.width, _rect.height);
				return;
			}

			var h:int = _tabs[0].height;
			_bg.resize(_rect.width, _rect.height - h);

			var ox:int;
			var oy:int;
			if (_tabLayout == TAB_LAYOUT_TOP)
			{
				_bg.y = h;
			}
			else
			{
				_bg.y = 0;
				oy = _bg.height;
			}

			var tab:TitleBar;
			for (var i:int; i < length; i++)
			{
				tab = _tabs[i];
				tab.x = ox;
				tab.y = oy;
				ox += tab.width + _tabGap;
				_container.setChildIndex(tab, i);
			}

			// 将当前选中标签置顶
			_container.addChild(_tabs[_tabContainers.indexOf(_currentContainer)]);

			_currentContainer.x = _margin.left;
			_currentContainer.y = _margin.top;
			_currentContainer.resize(_rect.width - _margin.left - _margin.right, _rect.height - _margin.top - _margin.bottom);
		}



		public function mouseDown(target:IControl):void
		{
			if (target is TitleBar)
			{
				this.selectedIndex = _tabs.indexOf(target);
			}
		}

		public function mouseUp(target:IControl):void
		{
		}

		public function mouseOver(target:IControl):void
		{
		}

		public function mouseOut(target:IControl):void
		{
		}





		public function addChild(child:IControl):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.addChild(child);
			}
		}

		public function addChildAt(child:IControl, index:int):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.addChildAt(child, index);
			}
		}



		public function getChildAt(index:int):IControl
		{
			if (_currentContainer != null)
			{
				return _currentContainer.getChildAt(index);
			}
			return null;
		}

		public function getChildIndex(child:IControl):int
		{
			if (_currentContainer != null)
			{
				return _currentContainer.getChildIndex(child);
			}
			return 0;
		}



		public function removeChild(child:IControl):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.removeChild(child);
			}
		}

		public function removeChildAt(index:int):IControl
		{
			if (_currentContainer != null)
			{
				return _currentContainer.removeChildAt(index);
			}
			return null;
		}

		public function removeChildren(beginIndex:int = 0, endIndex:int = -1):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.removeChildren(beginIndex, endIndex);
			}
		}

		public function setChildIndex(child:IControl, index:int):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.setChildIndex(child, index);
			}
		}

		public function swapChildren(child1:IControl, child2:IControl):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.swapChildren(child1, child2);
			}
		}

		public function swapChildrenAt(index1:int, index2:int):void
		{
			if (_currentContainer != null)
			{
				_currentContainer.swapChildrenAt(index1, index2);
			}
		}
	}
}
