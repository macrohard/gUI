package com.macro.gUI.containers
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.AbstractContainer;
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.events.WindowEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.display.BitmapData;
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
		 * 可拖拽区域，当值为null时表示没有限制
		 */
		private var _dragArea:Rectangle;



		/**
		 * 窗口容器。align属性用于设置标题栏对齐方式<br/>
		 * 根据margin属性的top确定标题栏的高度，margin的值是根据窗口背景皮肤的九切片定义来设置的，也可以直接设置<br/>
		 * 默认情况下，窗口可以拖拽，标题栏居中对齐
		 * @param width
		 * @param height
		 * @param title 标题文本
		 * @param buttonVisible 按钮可见性，默认所有按钮可见，参见BUTTON_VISIBLE_常量
		 * @param buttonLayout 标题栏按钮布局样式，默认使用XP样式布局，参见BUTTON_LAYOUT_常量
		 *
		 */
		public function Window(width:int = 100, height:int = 100, title:String = null, buttonVisible:int = 4, buttonLayout:int = 0)
		{
			// 标题栏默认居中对齐
			super(width, height, 0x22);

			_isDraggable = true;
			_buttonLayout = buttonLayout;
			_buttonStyle = buttonVisible;

			var skin:ISkin = skinMgr.getSkin(SkinDef.WINDOW_BG);
			_bg = new Slice(skin, width, height);
			_margin = new Margin(skin.gridLeft, skin.gridTop, skin.paddingRight, skin.paddingBottom);

			_title = new Label(title);
			_title.style = skinMgr.getStyle(StyleDef.WINDOW_TITLE);

			_minBtn = new Button();
			_minBtn.upSkin = skinMgr.getSkin(SkinDef.WINDOW_MINIMIZE_BUTTON);
			_minBtn.overSkin = skinMgr.getSkin(SkinDef.WINDOW_MINIMIZE_BUTTON_OVER);
			_minBtn.downSkin = skinMgr.getSkin(SkinDef.WINDOW_MINIMIZE_BUTTON_DOWN);
			_minBtn.disableSkin = skinMgr.getSkin(SkinDef.WINDOW_MINIMIZE_BUTTON_DISABLE);

			_maxBtn = new Button();
			_maxBtn.upSkin = skinMgr.getSkin(SkinDef.WINDOW_MAXIMIZE_BUTTON);
			_maxBtn.overSkin = skinMgr.getSkin(SkinDef.WINDOW_MAXIMIZE_BUTTON_OVER);
			_maxBtn.downSkin = skinMgr.getSkin(SkinDef.WINDOW_MAXIMIZE_BUTTON_DOWN);
			_maxBtn.disableSkin = skinMgr.getSkin(SkinDef.WINDOW_MAXIMIZE_BUTTON_DISABLE);

			_closeBtn = new Button();
			_closeBtn.upSkin = skinMgr.getSkin(SkinDef.WINDOW_CLOSE_BUTTON);
			_closeBtn.overSkin = skinMgr.getSkin(SkinDef.WINDOW_CLOSE_BUTTON_OVER);
			_closeBtn.downSkin = skinMgr.getSkin(SkinDef.WINDOW_CLOSE_BUTTON_DOWN);

			_contentContainer = new Container();

			_container = new Container(_bg.width, _bg.height);
			_container.addChild(_bg);
			_container.addChild(_title);
			_container.addChild(_contentContainer);

			_width = _container.width;
			_height = _container.height;
			setButtonState();
			layout();
		}
		
		
		override public function get bitmapData():BitmapData
		{
			return _bg.bitmapData;
		}


		private var _isDraggable:Boolean;

		/**
		 * 可否拖拽
		 * @return
		 *
		 */
		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}

		public function set isDraggable(value:Boolean):void
		{
			_isDraggable = value;
		}


		private var _canDragOutStage:Boolean;

		public function get canDragOutStage():Boolean
		{
			return _canDragOutStage;
		}

		public function set canDragOutStage(value:Boolean):void
		{
			_canDragOutStage = value;
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
			if (value != null)
			{
				_margin = value;
				layout();
				uiMgr.renderer.updateCoord(this);
			}
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
		public function get bgSkin():ISkin
		{
			return _bg.bgSkin;
		}
		
		public function set bgSkin(value:ISkin):void
		{
			_bg.bgSkin = value;
			_margin = new Margin(value.gridLeft, value.gridTop, value.paddingRight, value.paddingBottom);
			layout();
		}

		/**
		 * 设置标题文本样式
		 * @param style
		 *
		 */
		public function get titleStyle():TextStyle
		{
			return _title.style;
		}
		
		public function set titleStyle(value:TextStyle):void
		{
			_title.style = value;
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



		override public function hitTest(x:int, y:int):IControl
		{
			_originalCoord = new Point(_x, _y);
			_mouseCoord = new Point(x, y);

			var p:Point = _container.globalToLocal(new Point(x, y));
			if (p.x < 0 || p.y < 0 || p.x > _width || p.y > _height)
			{
				return null;
			}

			if (_minBtn.holder != null && _minBtn.rect.containsPoint(p))
			{
				return _minBtn;
			}

			if (_maxBtn.holder != null && _maxBtn.rect.containsPoint(p))
			{
				return _maxBtn;
			}

			if (_closeBtn.holder != null && _closeBtn.rect.containsPoint(p))
			{
				return _closeBtn;
			}

			if (_contentContainer.rect.containsPoint(p))
			{
				return AbstractContainer.CHILD_REGION;
			}

			return _container;
		}


		override public function resize(width:int = 0, height:int = 0):void
		{
			if (_bg.bgSkin != null)
			{
				if (width < _bg.bgSkin.minWidth)
				{
					width = _bg.bgSkin.minWidth;
				}

				if (height < _bg.bgSkin.minHeight)
				{
					height = _bg.bgSkin.minHeight;
				}
			}

			super.resize(width, height);
		}



		override protected function layout():void
		{
			var pad:int = 5; // 四周边距
			var gap:int; // 按钮间距
			var titleH:int = _margin.top; // 标题栏高度

			if (_buttonLayout == BUTTON_LAYOUT_XP)
			{
				gap = 2;

				_closeBtn.x = _width - pad - _closeBtn.width;
				_closeBtn.y = titleH - _closeBtn.height >> 1;

				_maxBtn.x = _closeBtn.x - gap - _maxBtn.width;
				_maxBtn.y = titleH - _closeBtn.height >> 1;

				_minBtn.x = _maxBtn.x - gap - _minBtn.width;
				_minBtn.y = titleH - _closeBtn.height >> 1;

			}
			else if (_buttonLayout == BUTTON_LAYOUT_CHROME)
			{
				gap = -1;

				_closeBtn.x = _width - pad - _closeBtn.width;
				_closeBtn.y = 0;

				_maxBtn.x = _closeBtn.x - gap - _maxBtn.width;
				_maxBtn.y = 0;

				_minBtn.x = _maxBtn.x - gap - _minBtn.width;
				_minBtn.y = 0;
			}

			var ox:int = pad;
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox = _width - _title.width >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox = _width - pad - _title.width;
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

			_bg.resize(_width, _height);
			_contentContainer.x = _margin.left;
			_contentContainer.y = _margin.top;
			_contentContainer.resize(_width - _margin.left - _margin.right, _height - _margin.top - _margin.bottom);
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
				dispatchEvent(new WindowEvent(WindowEvent.MIN_BUTTON_CLICK));
			}
			else if (target == _maxBtn)
			{
				_maxBtn.mouseUp(target);
				dispatchEvent(new WindowEvent(WindowEvent.MAX_BUTTON_CLICK));
			}
			else if (target == _closeBtn)
			{
				_closeBtn.mouseUp(target);
				dispatchEvent(new WindowEvent(WindowEvent.CLOSE_BUTTON_CLICK));
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


		public function getDraggable(target:IControl):Boolean
		{
			if (target == _container && _isDraggable)
			{
				_dragArea = null;
				if (!_canDragOutStage && this.holder != null)
				{
					var p1:Point = this.holder.globalToLocal(new Point());
					var p2:Point = this.holder.globalToLocal(new Point(uiMgr.stageWidth - _width, uiMgr.stageHeight - _height));
					_dragArea = new Rectangle(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y);
				}

				return true;
			}
			return false;
		}

		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			x = _originalCoord.x + x - _mouseCoord.x;
			y = _originalCoord.y + y - _mouseCoord.y;
			if (_dragArea != null)
			{
				x = x < _dragArea.left ? _dragArea.left : (x > _dragArea.right ? _dragArea.right : x);
				y = y < _dragArea.top ? _dragArea.top : (y > _dragArea.bottom ? _dragArea.bottom : y);
			}
			this.x = x;
			this.y = y;
		}



		public function addChild(child:IControl):void
		{
			_contentContainer.addChild(child);
			setChildParent(child as AbstractControl);
		}

		public function addChildAt(child:IControl, index:int):void
		{
			_contentContainer.addChildAt(child, index);
			setChildParent(child as AbstractControl);
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
