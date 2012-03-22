package com.macro.gUI.controls.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IDrag;
	import com.macro.gUI.base.feature.IKeyboard;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;


	/**
	 * 水平滑槽
	 * @author Macro776@gmail.com
	 *
	 */
	public class HSlider extends AbstractComposite implements IKeyboard, IDrag, IButton
	{

		private var _bg:Slice;

		private var _blockBtn:Button;

		/**
		 * 鼠标点击的对象
		 */
		private var _mouseObj:IControl;
		

		/**
		 * 移动区域的最左侧位置
		 */
		private var _minX:int;

		/**
		 * 移动区域的最右侧位置
		 */
		private var _maxX:int;


		/**
		 * 水平滑槽控件。利用边距属性定义滑槽的位置，
		 * 然后根据滑块和背景的皮肤九切片定义来定位滑块及背景的位置
		 * @param width 宽度
		 * @param align 布局对齐方式，默认垂直居中
		 * @param blockSkin 滑块皮肤
		 * @param bgSkin 背景皮肤
		 *
		 */
		public function HSlider(width:int = 100, align:int = 0x20, blockSkin:ISkin = null, bgSkin:ISkin = null)
		{
			super(width, 20, align);

			//默认自动设置高度
			_autoSize = true;

			_stepSize = 1;

			_maximum = 10;

			//四周边距均默认为10
			_padding = new Rectangle(10, 10);

			bgSkin = bgSkin ? bgSkin : GameUI.skinManager.getSkin(SkinDef.SLIDER_HORIZONTAL_BG);
			_bg = new Slice(width, bgSkin.bitmapData.height, bgSkin);

			blockSkin = blockSkin ? blockSkin : GameUI.skinManager.getSkin(SkinDef.SLIDER_BLOCK_NORMAL);
			_blockBtn = new Button(null, null, 0x22, blockSkin);
			_blockBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SLIDER_BLOCK_OVER);
			_blockBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SLIDER_BLOCK_DOWN);
			_blockBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SLIDER_BLOCK_DISABLE);

			_children.push(_bg);
			_children.push(_blockBtn);

			resize(_rect.width);
		}


		private var _autoSize:Boolean;
		/**
		 * 自动设置高度
		 * @return
		 *
		 */
		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			if (_autoSize != value)
			{
				_autoSize = value;
				if (_autoSize)
				{
					resize(_rect.width);
				}
			}
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
				if (_autoSize)
				{
					resize(_rect.width);
				}
				else
				{
					layout();
				}
			}
		}

		
		private var _stepSize:int;
		/**
		 * 步长
		 * @return 
		 * 
		 */
		public function get stepSize():int
		{
			return _stepSize;
		}

		public function set stepSize(value:int):void
		{
			_stepSize = value;
		}

		
		private var _minimum:int;
		/**
		 * 最小值
		 * @return 
		 * 
		 */
		public function get minimum():int
		{
			return _minimum;
		}

		public function set minimum(value:int):void
		{
			_minimum = value;
			this.value = _value;
		}

		
		private var _maximum:int;
		/**
		 * 最大值
		 * @return 
		 * 
		 */
		public function get maximum():int
		{
			return _maximum;
		}

		public function set maximum(value:int):void
		{
			_maximum = value;
			this.value = _value;
		}

		
		private var _value:int;
		/**
		 * 当前值
		 * @return 
		 * 
		 */
		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			value = Math.round((value - _minimum) / _stepSize) * _stepSize + _minimum;
			_value = value < _minimum ? _minimum : (value > _maximum ? _maximum : value);
			relocateBlock();
		}

		
		public function get enabled():Boolean
		{
			return _blockBtn.enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_blockBtn.enabled = value;
		}
		
		
		public function get focusable():Boolean
		{
			return true;
		}
		
		
		public function get dragMode():int
		{
			if (_mouseObj == _blockBtn)
			{
				return DragMode.INTERNAL;
			}
			return DragMode.NONE;
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
		
		
		
		public function get blockNormalSkin():ISkin
		{
			return _blockBtn.normalSkin;
		}
		
		public function set blockNormalSkin(value:ISkin):void
		{
			_blockBtn.normalSkin = value;
			layout();
		}
		
		public function get blockOverSkin():ISkin
		{
			return _blockBtn.overSkin;
		}
		
		public function set blockOverSkin(value:ISkin):void
		{
			_blockBtn.overSkin = value;
			layout();
		}
		
		public function get blockDownSkin():ISkin
		{
			return _blockBtn.downSkin;
		}
		
		public function set blockDownSkin(value:ISkin):void
		{
			_blockBtn.downSkin = value;
			layout();
		}
		
		public function get blockDisableSkin():ISkin
		{
			return _blockBtn.disableSkin;
		}
		
		public function set blockDisableSkin(value:ISkin):void
		{
			_blockBtn.disableSkin = value;
			layout();
		}
		
		public function get bgSkin():ISkin
		{
			return _bg.skin;
		}
		
		public function set bgSkin(value:ISkin):void
		{
			_bg.skin = value;
			_bg.height = value.bitmapData.height;
			layout();
		}
		


		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = _padding.left + _padding.right;
				width = width < min ? min : width;
				height = _padding.top + _padding.bottom;
			}

			super.resize(width, height);
		}

		public override function setDefaultSize():void
		{
			resize(_rect.width, _padding.top + _padding.bottom);
		}




		protected override function layout():void
		{
			var oy:int = _padding.top;
			var h:int = _padding.top + _padding.bottom;
			if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy += (_rect.height - h) >> 1;
			}
			else if ((_align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy += _rect.height - h;
			}

			_bg.x = _padding.left - _bg.skin.gridLeft;
			_bg.y = oy - _bg.skin.gridTop;
			_bg.width = _rect.width - _padding.right + _bg.skin.paddingRight - _bg.x;

			_minX = _padding.left - _blockBtn.normalSkin.gridLeft;
			_maxX = _rect.width - _padding.right - _blockBtn.normalSkin.gridLeft;
			_blockBtn.y = oy - _blockBtn.normalSkin.gridTop;

			relocateBlock();
		}

		/**
		 * 定位滑块的位置
		 * 
		 */
		private function relocateBlock():void
		{
			var step:Number = (_maxX - _minX) / (_maximum - _minimum);
			_blockBtn.x = _minX + step * (_value - _minimum);
		}



		public function hitTest(x:int, y:int):IControl
		{
			if (_blockBtn.rect.contains(x, y))
			{
				_mouseObj = _blockBtn;
			}
			else if (_bg.rect.contains(x, y))
			{
				_mouseObj = _bg;
			}
			else
			{
				_mouseObj = null;
			}

			return _mouseObj;
		}

		public function mouseDown():void
		{
			if (_mouseObj == _blockBtn)
			{
				_blockBtn.mouseDown();
			}
		}

		public function mouseOut():void
		{
			_blockBtn.mouseOut();
		}

		public function mouseOver():void
		{
			if (_mouseObj == _blockBtn)
			{
				_blockBtn.mouseOver();
			}
		}

		public function mouseUp():void
		{
			if (_mouseObj == _blockBtn)
			{
				_blockBtn.mouseUp();
			}
		}


		public function keyDown(e:KeyboardEvent):void
		{
			if (!_blockBtn.enabled)
			{
				return;
			}

			if (e.keyCode == Keyboard.LEFT)
			{
				this.value -= this.stepSize;
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				this.value += this.stepSize;
			}
		}

		public function keyUp(e:KeyboardEvent):void
		{
		}


		public function getDragImage():BitmapData
		{
			return null;
		}

		public function setDragPos(x:int, y:int):void
		{
			if (_mouseObj != _blockBtn || !_blockBtn.enabled)
			{
				return;
			}

			var w:int = _rect.width - _padding.right - _padding.left;
			var d:int = x - _padding.left;
			this.value = Math.round(d / w * (_maximum - _minimum)) + _minimum;
		}
	}
}
