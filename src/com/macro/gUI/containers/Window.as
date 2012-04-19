package com.macro.gUI.containers
{
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.CHILD_REGION;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	import flash.display.BitmapData;
	import flash.geom.Point;


	/**
	 * 窗口容器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Window extends AbstractComposite implements IContainer,
			IButton, IDrag
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
		 * 所有按钮不可见
		 */
		public static const BUTTON_VISIBLE_NONE:int = 0;

		/**
		 * 所有按钮可见，最大化按钮禁用
		 */
		public static const BUTTON_VISIBLE_MINIMIZE_CLOSE:int = 1;

		/**
		 * 所有按钮可见，最小化按钮禁用
		 */
		public static const BUTTON_VISIBLE_MAXIMIZ_CLOSE:int = 2;

		/**
		 * 仅关闭按钮可见
		 */
		public static const BUTTON_VISIBLE_CLOSE:int = 3;

		/**
		 * 所有按钮可见
		 */
		public static const BUTTON_VISIBLE_ALL:int = 4;



		/**
		 * 内容容器
		 */
		protected var _contentContainer:Container;

		/**
		 * 窗口背景
		 */
		protected var _bg:Slice;

		/**
		 * 最小化按钮
		 */
		protected var _minBtn:Button;

		/**
		 * 最大化按钮
		 */
		protected var _maxBtn:Button;

		/**
		 * 关闭按钮
		 */
		protected var _closeBtn:Button;

		/**
		 * 标题
		 */
		protected var _title:Label;


		/**
		 * 点击时控件的原始坐标
		 */
		private var _originalCoord:Point;

		/**
		 * 点击时鼠标的全局坐标
		 */
		private var _mouseCoord:Point;



		/**
		 * 窗口容器。align属性用于设置标题栏对齐方式<br/>
		 * 根据margin属性的top确定标题栏的高度，margin的值是根据窗口背景皮肤的九切片定义来设置的，也可以直接设置<br/>
		 * 默认情况下，窗口可以拖拽，标题栏居中对齐
		 * @param title 标题文本
		 * @param buttonVisible 按钮可见性，默认所有按钮可见，参见BUTTON_VISIBLE_常量
		 * @param buttonLayout 标题栏按钮布局样式，默认使用XP样式布局，参见BUTTON_LAYOUT_常量
		 * @param width
		 * @param height
		 *
		 */
		public function Window(title:String = null, buttonVisible:int = 4, buttonLayout:int = 0, width:int = 300, height:int = 200)
		{
			// 标题栏默认居中对齐
			super(width, height, 0x22);

			_canDrag = true;
			_buttonLayout = buttonLayout;
			_buttonStyle = buttonVisible;

			var skin:ISkin = skinManager.getSkin(SkinDef.WINDOW_BG);
			_bg = new Slice(skin, width, height);
			_margin = new Margin(skin.gridLeft, skin.gridTop, skin.paddingRight, skin.paddingBottom);

			_title = new Label(title);
			_title.style = skinManager.getStyle(StyleDef.WINDOW_TITLE);

			_minBtn = new Button();
			_minBtn.skin = skinManager.getSkin(SkinDef.MINIMIZE_BUTTON);
			_minBtn.overSkin = skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_OVER);
			_minBtn.downSkin = skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_DOWN);
			_minBtn.disableSkin = skinManager.getSkin(SkinDef.MINIMIZE_BUTTON_DISABLE);

			_maxBtn = new Button();
			_maxBtn.skin = skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON);
			_maxBtn.overSkin = skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_OVER);
			_maxBtn.downSkin = skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_DOWN);
			_maxBtn.disableSkin = skinManager.getSkin(SkinDef.MAXIMIZE_BUTTON_DISABLE);

			_closeBtn = new Button();
			_closeBtn.skin = skinManager.getSkin(SkinDef.CLOSE_BUTTON);
			_closeBtn.overSkin = skinManager.getSkin(SkinDef.CLOSE_BUTTON_OVER);
			_closeBtn.downSkin = skinManager.getSkin(SkinDef.CLOSE_BUTTON_DOWN);

			_contentContainer = new Container();

			_container = new Container(_bg.width, _bg.height);
			_container.addChild(_bg);
			_container.addChild(_title);
			_container.addChild(_contentContainer);

			_rect = _container.rect;
			setButtonState();
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
		 * 标题栏按钮的可见性，请使用BUTTON_VISIBLE_常量
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
			setButtonState();
			layout();
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
			_bg.skin = bgSkin;
			_margin = new Margin(bgSkin.gridLeft, bgSkin.gridTop, bgSkin.paddingRight, bgSkin.paddingBottom);
			layout();
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


		private function setButtonState():void
		{
			_container.removeChild(_minBtn);
			_container.removeChild(_maxBtn);
			_container.removeChild(_closeBtn);

			if (_buttonStyle == BUTTON_VISIBLE_CLOSE)
			{
				_container.addChild(_closeBtn);
			}
			else if (_buttonStyle != BUTTON_VISIBLE_NONE)
			{
				_container.addChild(_minBtn);
				_container.addChild(_maxBtn);
				_container.addChild(_closeBtn);

				if (_buttonStyle == BUTTON_VISIBLE_MAXIMIZ_CLOSE)
				{
					_minBtn.enabled = false;
					_maxBtn.enabled = true;
				}
				else if (_buttonStyle == BUTTON_VISIBLE_MINIMIZE_CLOSE)
				{
					_minBtn.enabled = true;
					_maxBtn.enabled = false;
				}
				else if (_buttonStyle == BUTTON_VISIBLE_ALL)
				{
					_minBtn.enabled = true;
					_maxBtn.enabled = true;
				}
			}
		}



		public override function hitTest(x:int, y:int):IControl
		{
			_originalCoord = _rect.topLeft;
			_mouseCoord = new Point(x, y);

			var p:Point = _container.globalToLocal(x, y);
			if (p.x < 0 || p.y < 0 || p.x > _rect.width || p.y > _rect.height)
			{
				return null;
			}

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

			if (_contentContainer.rect.containsPoint(p))
			{
				return new CHILD_REGION();
			}

			return _container;
		}



		protected override function layout():void
		{
			var pad:int = 5; // 四周边距
			var gap:int; // 按钮间距
			var titleH:int = _margin.top; // 标题栏高度

			if (_buttonLayout == BUTTON_LAYOUT_XP)
			{
				gap = 2;

				_closeBtn.x = _rect.width - pad - _closeBtn.width;
				_closeBtn.y = titleH - _closeBtn.height >> 1;

				_maxBtn.x = _closeBtn.x - gap - _maxBtn.width;
				_maxBtn.y = titleH - _closeBtn.height >> 1;

				_minBtn.x = _maxBtn.x - gap - _minBtn.width;
				_minBtn.y = titleH - _closeBtn.height >> 1;

			}
			else if (_buttonLayout == BUTTON_LAYOUT_CHROME)
			{
				gap = -1;

				_closeBtn.x = _rect.width - pad - _closeBtn.width;
				_closeBtn.y = 0;

				_maxBtn.x = _closeBtn.x - gap - _maxBtn.width;
				_maxBtn.y = 0;

				_minBtn.x = _maxBtn.x - gap - _minBtn.width;
				_minBtn.y = 0;
			}

			var ox:int = pad;
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox = _rect.width - _title.width >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox = _rect.width - pad - _title.width;
			}

			var oy:int;
			if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy = titleH - _title.height >> 1;
			}
			else if ((_align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy = titleH - _title.height;
			}

			_title.x = ox;
			_title.y = oy;

			_bg.resize(_rect.width, _rect.height);
			_contentContainer.x = _margin.left;
			_contentContainer.y = _margin.top;
			_contentContainer.resize(_rect.width - _margin.left - _margin.right, _rect.height - _margin.top - _margin.bottom);
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
			if (target == _container && _canDrag)
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
			this.x = _originalCoord.x + x - _mouseCoord.x;
			this.y = _originalCoord.y + y - _mouseCoord.y;
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
