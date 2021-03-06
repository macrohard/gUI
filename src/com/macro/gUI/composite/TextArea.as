package com.macro.gUI.composite
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.containers.Panel;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.geom.Point;


	/**
	 * 文本块控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class TextArea extends AbstractComposite implements IDrag, IButton
	{
		/**
		 * 文本对象
		 */
		protected var _label:Label;

		/**
		 * 显示容器
		 */
		protected var _displayContainer:Container;

		/**
		 * 水平滚动条
		 */
		protected var _hScrollBar:HScrollBar;

		/**
		 * 垂直滚动条
		 */
		protected var _vScrollBar:VScrollBar;

		/**
		 * 文本块控件
		 * @param width
		 * @param height
		 * @param align
		 *
		 */
		public function TextArea(width:int = 100, height:int = 100)
		{
			super(width, height);

			_vScrollBar = new VScrollBar();
			_hScrollBar = new HScrollBar();

			_label = new Label();
			_label.style = skinMgr.getStyle(StyleDef.TEXTAREA);

			_displayContainer = new Container();
			_displayContainer.addChild(_label);

			_container = new Panel(width, height);
			(_container as Panel).bgSkin = skinMgr.getSkin(SkinDef.TEXTAREA_BG);
			_container.addChild(_displayContainer);

			_width = _container.width;
			_height = _container.height;
			layout();
		}


		/**
		 * 文本
		 * @return
		 *
		 */
		public function get text():String
		{
			return _label.text;
		}

		public function set text(value:String):void
		{
			_label.text = value;
			layout();
		}


		/**
		 * 自动转行
		 * @return
		 *
		 */
		public function get wordWrap():Boolean
		{
			return _label.style.wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			var style:TextStyle = _label.style;
			style.wordWrap = value;
			_label.style = style;
			layout();
		}


		public function get bgSkin():ISkin
		{
			return (_container as Panel).bgSkin;
		}
		
		public function set bgSkin(value:ISkin):void
		{
			(_container as Panel).bgSkin = value;
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

			if (p.x >= 0 && p.x <= _width && p.y >= 0 && p.y <= _height)
			{
				target = _container;
			}

			return target;
		}


		override protected function layout():void
		{
			var maxW:int = _container.contentWidth;
			var maxH:int = _container.contentHeight;
			var minW:int = maxW - _vScrollBar.width;
			var minH:int = maxH - _hScrollBar.height;

			_label.resize(maxW);

			// 0表示没有滚动条，1表示出现水平滚动条，2表示出现垂直滚动条，3表示同时出现两者
			var scrollVisible:int;

			if (_label.style.wordWrap)
			{
				if (_label.height > maxH)
				{
					_label.resize(minW);
					scrollVisible = 2;
				}
			}
			else
			{
				if (_label.width > maxW)
				{
					scrollVisible |= 1;
					if (_label.height > minH)
					{
						scrollVisible |= 2;
					}
				}

				if (_label.height > maxH)
				{
					scrollVisible |= 2;
					if (_label.width > minW)
					{
						scrollVisible |= 1;
					}
				}
			}


			if (scrollVisible == 0)
			{
				_container.removeChild(_vScrollBar);
				_container.removeChild(_hScrollBar);
				_displayContainer.resize(maxW, maxH);
				_label.x = _label.y = 0;
			}
			else if (scrollVisible == 1)
			{
				_container.removeChild(_vScrollBar);
				_container.addChild(_hScrollBar);
				_displayContainer.resize(maxW, minH);
				_hScrollBar.y = minH;
				_hScrollBar.width = maxW;
				_hScrollBar.viewport = new Viewport(_displayContainer.rect, _label);
				_label.y = 0;
			}
			else if (scrollVisible == 2)
			{
				_container.removeChild(_hScrollBar);
				_container.addChild(_vScrollBar);
				_displayContainer.resize(minW, maxH);
				_vScrollBar.x = minW;
				_vScrollBar.height = maxH;
				_vScrollBar.viewport = new Viewport(_displayContainer.rect, _label);
				_label.x = 0;
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

				_hScrollBar.viewport = new Viewport(_displayContainer.rect, _label);
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



	}
}
