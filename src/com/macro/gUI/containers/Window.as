package com.macro.gUI.containers
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.NULL;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IContainer;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IDrag;
	import com.macro.gUI.base.feature.IKeyboard;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 窗口容器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Window extends AbstractComposite implements IContainer, IButton, IDrag
	{
		/**
		 * 标题栏按钮按XP样式布局
		 */
		public static const BUTTON_LAYOUT_XP:int = 0;

		/**
		 * 标题栏按钮按Chrome样式布局
		 */
		public static const BUTTON_LAYOUT_CHROME:int = 1;



		/**
		 * 最小化按钮可见
		 */
		public static const BUTTON_VISIBLE_MINIMIZE:int = 1;

		/**
		 * 最大化按钮可见
		 */
		public static const BUTTON_VISIBLE_MAXIMIZ:int = 2;

		/**
		 * 关闭按钮可见
		 */
		public static const BUTTON_VISIBLE_CLOSE:int = 4;



		/**
		 * 内容容器
		 */
		private var _contentContainer:Container;

		/**
		 * 最小化按钮
		 */
		private var _minBtn:Button;

		/**
		 * 最大化按钮
		 */
		private var _maxBtn:Button;

		/**
		 * 关闭按钮
		 */
		private var _closeBtn:Button;

		/**
		 * 标题
		 */
		private var _title:Label;
		
		
		/**
		 * 点击时控件的全局坐标
		 */
		private var _globalCoord:Point;
		
		/**
		 * 点击时鼠标偏移量
		 */
		private var _mouseOffset:Point;



		/**
		 * 窗口容器，默认可以拖拽，align属性设置标题栏对齐方式
		 * @param titleBarLayout 标题栏布局样式，默认使用XP样式布局
		 * @param width
		 * @param height
		 *
		 */
		public function Window(titleBarLayout:int = 0, width:int = 300, height:int = 200)
		{
			// 标题栏默认左中对齐
			super(width, height, 0x21);

			_canDrag = true;
			_buttonLayout = titleBarLayout;

			_minBtn = new Button();
			_minBtn.skin = GameUI.skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_NORMAL);
			_minBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_OVER);
			_minBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_DOWN);
			_minBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_DISABLE);

			_maxBtn = new Button();
			_maxBtn.skin = GameUI.skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_NORMAL);
			_maxBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_OVER);
			_maxBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_DOWN);
			_maxBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_DISABLE);

			_closeBtn = new Button();
			_closeBtn.skin = GameUI.skinManager.getSkin(SkinDef.CLOSE_BUTTON_NORMAL);
			_closeBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.CLOSE_BUTTON_OVER);
			_closeBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.CLOSE_BUTTON_DOWN);
			_closeBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.CLOSE_BUTTON_DISABLE);

			_title = new Label();
			_title.style = GameUI.skinManager.getStyle(StyleDef.WINDOW_TITLE);

			_contentContainer = new Container();

			_container = new Panel(width, height);
			(_container as Panel).skin = GameUI.skinManager.getSkin(SkinDef.WINDOW_BG);
			_container.addChild(_title);
			_container.addChild(_minBtn);
			_container.addChild(_maxBtn);
			_container.addChild(_closeBtn);
			_container.addChild(_contentContainer);

			_rect = _container.rect;
			layout();
		}


		private var _canDrag:Boolean;

		/**
		 * 可否拖拽
		 * @return
		 *
		 */
		public function get draggable():Boolean
		{
			return _canDrag;
		}

		public function set draggable(value:Boolean):void
		{
			_canDrag = value;
		}


		/**
		 * 设置标题栏文本
		 * @return
		 *
		 */
		public function get title():String
		{
			return _title.text;
		}

		public function set title(value:String):void
		{
			_title.text = value;
			layout();
		}



		private var _buttonLayout:int;

		/**
		 * 标题栏按钮布局样式，请使用BUTTON_LAYOUT_常量
		 * @return
		 *
		 */
		public function get buttonLayout():int
		{
			return _buttonLayout;
		}

		public function set buttonLayout(value:int):void
		{
			_buttonLayout = value;
			layout();
		}


		private var _buttonStyle:int

		/**
		 * 标题栏按钮的可见性，请使用BUTTON_VISIBLE_常量。<br/>
		 * 举例，设置最小化和关闭可见，最大化不可见：<br/>
		 * buttonStyle = BUTTON_VISIBLE_MINIMIZE | BUTTON_VISIBLE_CLOSE
		 * @return
		 *
		 */
		public function get buttonStyle():int
		{
			return _buttonStyle;
		}

		public function set buttonStyle(value:int):void
		{
			_buttonStyle = value;
			layout();
		}


		public function get margin():Rectangle
		{
			return _container.margin;
		}

		public function set margin(value:Rectangle):void
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
			(_container as Panel).skin = bgSkin;
		}

		/**
		 * 设置标题文本样式
		 * @param style
		 *
		 */
		public function setTitleStyle(style:TextStyle):void
		{
			_title.style = style;
			layout();
		}



		public override function hitTest(x:int, y:int):IControl
		{
			_globalCoord = _container.globalCoord();
			var p:Point = new Point(x - _globalCoord.x, y - _globalCoord.y);
			_mouseOffset = p;

			if (_minBtn.parent != null && _minBtn.rect.containsPoint(p))
			{
				return _minBtn;
			}

			if (_maxBtn.parent != null && _maxBtn.rect.containsPoint(p))
			{
				return _maxBtn;
			}

			if (_closeBtn.parent != null && _closeBtn.rect.containsPoint(p))
			{
				return _closeBtn;
			}

			var m:Rectangle = _container.margin;
			if (p.x >= m.left && p.x <= _rect.width - m.right && p.y >= m.top && p.y <= _rect.height - m.bottom)
			{
				return _container;
			}
			if (p.x >= 0 && p.x <= _rect.width && p.y >= 0 && p.y <= _rect.height)
			{
				return new NULL();
			}

			return null;
		}


		protected override function layout():void
		{
			
		}



		public function mouseDown(target:IControl):void
		{
			if (target == _minBtn)
			{
				_minBtn.mouseDown(target);
			}
			else if (target == _maxBtn)
			{
				_maxBtn.mouseDown(target);
			}
			else if (target == _closeBtn)
			{
				_closeBtn.mouseDown(target);
			}
		}

		public function mouseUp(target:IControl):void
		{
			if (target == _minBtn)
			{
				_minBtn.mouseUp(target);
			}
			else if (target == _maxBtn)
			{
				_maxBtn.mouseUp(target);
			}
			else if (target == _closeBtn)
			{
				_closeBtn.mouseUp(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target == _minBtn)
			{
				_minBtn.mouseOver(target);
			}
			else if (target == _maxBtn)
			{
				_maxBtn.mouseOver(target);
			}
			else if (target == _closeBtn)
			{
				_closeBtn.mouseOver(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			if (target == _minBtn)
			{
				_minBtn.mouseOut(target);
			}
			else if (target == _maxBtn)
			{
				_maxBtn.mouseOut(target);
			}
			else if (target == _closeBtn)
			{
				_closeBtn.mouseOut(target);
			}
		}

		
		public function getDragMode(target:IControl):int
		{
			if (target is NULL)
			{
				return DragMode.DIRECT;
			}
			return DragMode.NONE;
		}

		public function getDragImage():BitmapData
		{
			return null;
		}

		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			// TODO 根据记录的全局坐标实现拖拽
			this.x = x - _mouseOffset.x;
			this.y = y - _mouseOffset.y;
		}



		public function addChild(child:IControl):void
		{
			_contentContainer.addChild(child);
		}

		public function addChildAt(child:IControl, index:int):void
		{
			_contentContainer.addChildAt(child, index);
		}

		public function removeChild(child:IControl):void
		{
			_contentContainer.removeChild(child);
		}

		public function removeChildAt(index:int):IControl
		{
			return _contentContainer.removeChildAt(index);
		}

		public function removeChildren(beginIndex:int = 0, endIndex:int = -1):void
		{
			_contentContainer.removeChildren(beginIndex, endIndex);
		}

		public function getChildAt(index:int):IControl
		{
			return _contentContainer.getChildAt(index);
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
