package com.macro.gUI.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IDrag;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.containers.Panel;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.display.BitmapData;
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
		private var _label:Label;
		
		/**
		 * 显示容器
		 */
		private var _contentContainer:Container;
		
		/**
		 * 水平滚动条
		 */
		private var _hScrollBar:HScrollBar;
		
		/**
		 * 垂直滚动条
		 */
		private var _vScrollBar:VScrollBar;
		
		/**
		 * 文件块控件，始终完全缩放，不支持布局对齐
		 * @param width
		 * @param height
		 * @param align
		 * 
		 */
		public function TextArea(width:int = 100, height:int = 100)
		{
			super(width, height, 0x11);
			
			_vScrollBar = new VScrollBar();
			_hScrollBar = new HScrollBar();
			
			_label = new Label();
			_label.style = GameUI.skinManager.getStyle(StyleDef.TEXTAREA);
			
			_contentContainer = new Container();
			_contentContainer.addChild(_label);
			
			_container = new Panel(width, height);
			(_container as Panel).skin = GameUI.skinManager.getSkin(SkinDef.TEXTAREA_BG);
			_container.addChild(_contentContainer);
			
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
		
		
		/**
		 * 设置列表框背景皮肤
		 * @param bgSkin
		 * 
		 */
		public function setBgSkin(bgSkin:ISkin):void
		{
			(_container as Panel).skin = bgSkin;
		}
		
		
		
		public override function hitTest(x:int, y:int):IControl
		{
			var target:IControl;
			
			if (_vScrollBar.parent != null)
			{
				target = _vScrollBar.hitTest(x, y);
				if (target != null)
				{
					return target;
				}
			}
			
			if (_hScrollBar.parent != null)
			{
				target = _hScrollBar.hitTest(x, y);
				if (target != null)
				{
					return target;
				}
			}
			
			// 检测是否在控件范围内
			var p:Point = _container.globalCoord();
			x -= p.x;
			y -= p.y;
			
			if (x >= 0 && x <= _rect.width && y >= 0 && y <= _rect.height)
			{
				target = _container;
			}
			
			return target;
		}
		
		
		protected override function layout():void
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
				_contentContainer.resize(maxW, maxH);
			}
			else if (scrollVisible == 1)
			{
				_container.removeChild(_vScrollBar);
				_container.addChild(_hScrollBar);
				_contentContainer.resize(maxW, minH);
				_hScrollBar.y = minH;
				_hScrollBar.width = maxW;
				_hScrollBar.viewport = new Viewport(_contentContainer.rect, _label);
			}
			else if (scrollVisible == 2)
			{
				_container.removeChild(_hScrollBar);
				_container.addChild(_vScrollBar);
				_contentContainer.resize(minW, maxH);
				_vScrollBar.x = minW;
				_vScrollBar.height = maxH;
				_vScrollBar.viewport = new Viewport(_contentContainer.rect, _label);
			}
			else
			{
				_container.addChild(_hScrollBar);
				_container.addChild(_vScrollBar);
				_contentContainer.resize(minW, minH);
				_hScrollBar.y = minH;
				_hScrollBar.width = minW;
				_vScrollBar.x = minW;
				_vScrollBar.height = minH;
				
				_hScrollBar.viewport = new Viewport(_contentContainer.rect, _label);
				_vScrollBar.viewport = _hScrollBar.viewport;
			}
		}
		
		
		
		public function mouseDown(target:IControl):void
		{
			if (target.parent == _vScrollBar.container)
			{
				_vScrollBar.mouseDown(target);
			}
			else if (target.parent == _hScrollBar.container)
			{
				_hScrollBar.mouseDown(target);
			}
		}
		
		public function mouseOut(target:IControl):void
		{
			if (target.parent == _vScrollBar.container)
			{
				_vScrollBar.mouseOut(target);
			}
			else if (target.parent == _hScrollBar.container)
			{
				_hScrollBar.mouseOut(target);
			}
		}
		
		public function mouseOver(target:IControl):void
		{
			if (target.parent == _vScrollBar.container)
			{
				_vScrollBar.mouseOver(target);
			}
			else if (target.parent == _hScrollBar.container)
			{
				_hScrollBar.mouseOver(target);
			}
		}
		
		public function mouseUp(target:IControl):void
		{
			if (target.parent == _vScrollBar.container)
			{
				_vScrollBar.mouseUp(target);
			}
			else if (target.parent == _hScrollBar.container)
			{
				_hScrollBar.mouseUp(target);
			}
		}
		
		public function getDragImage():BitmapData
		{
			return null;
		}
		
		public function getDragMode(target:IControl):int
		{
			if (target.parent == _vScrollBar.container)
			{
				return _vScrollBar.getDragMode(target);
			}
			else if (target.parent == _hScrollBar.container)
			{
				return _hScrollBar.getDragMode(target);
			}
			return DragMode.NONE;
		}
		
		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			if (target.parent == _vScrollBar.container)
			{
				return _vScrollBar.setDragCoord(target, x, y);
			}
			else if (target.parent == _hScrollBar.container)
			{
				return _hScrollBar.setDragCoord(target, x, y);
			}
		}
		
		
		
	}
}