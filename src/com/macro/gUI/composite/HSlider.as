package com.macro.gUI.composite
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.core.feature.IKeyboard;
	import com.macro.gUI.events.SliderEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;


	/**
	 * 水平滑槽
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class HSlider extends AbstractComposite implements IKeyboard, IDrag, IButton
	{

		protected var _track:Slice;

		protected var _blockBtn:Button;


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
		 * 再根据滑槽来定位滑块和背景的位置。<br/>
		 * 默认自动设置尺寸
		 * @param width 宽度
		 * @param align 布局对齐方式，默认垂直居中
		 *
		 */
		public function HSlider(width:int = 100, align:int = 0x20)
		{
			//稍后resize时会重设为标准大小
			super(width, 1, align);

			_autoSize = true;
			_stepSize = 1;
			_maximum = 10;

			//四周边距均默认为10
			_padding = new Margin(10, 10, 10, 10);

			var skin:ISkin = skinMgr.getSkin(SkinDef.SLIDER_HORIZONTAL_BG);
			_track = new Slice(skin, width, skin.bitmapData.height);

			_blockBtn = new Button();
			_blockBtn.upSkin = skinMgr.getSkin(SkinDef.SLIDER_BLOCK);
			_blockBtn.overSkin = skinMgr.getSkin(SkinDef.SLIDER_BLOCK_OVER);
			_blockBtn.downSkin = skinMgr.getSkin(SkinDef.SLIDER_BLOCK_DOWN);
			_blockBtn.disableSkin = skinMgr.getSkin(SkinDef.SLIDER_BLOCK_DISABLE);

			_container = new Container();
			_container.addChild(_track);
			_container.addChild(_blockBtn);

			resize(_width);
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
					resize(_width);
				}
			}
		}


		private var _padding:Margin;

		/**
		 * 滑槽与四周的边距。注意，不是显示内容与四周的边距，设置不精确时，会导致显示内容被裁剪
		 * @return
		 *
		 */
		public function get padding():Margin
		{
			return _padding;
		}

		public function set padding(value:Margin):void
		{
			_padding = value;
			if (_autoSize)
			{
				resize(_width);
			}
			else
			{
				layout();
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

			dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGED));
		}
		
		
		
		override public function set height(value:int):void
		{
			_autoSize = false;
			super.height = value;
		}
		
		override public function set width(value:int):void
		{
			_autoSize = false;
			super.width = value;
		}



		override public function get enabled():Boolean
		{
			return _blockBtn.enabled;
		}

		override public function set enabled(value:Boolean):void
		{
			_blockBtn.enabled = value;
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


		
		public function get blockUpSkin():ISkin
		{
			return _blockBtn.upSkin;
		}

		public function set blockUpSkin(value:ISkin):void
		{
			_blockBtn.upSkin = value;
			update();
		}
		
		public function get blockOverSkin():ISkin
		{
			return _blockBtn.overSkin;
		}
		
		public function set blockOverSkin(value:ISkin):void
		{
			_blockBtn.overSkin = value;
		}
		
		public function get blockDownSkin():ISkin
		{
			return _blockBtn.downSkin;
		}
		
		public function set blockDownSkin(value:ISkin):void
		{
			_blockBtn.downSkin = value;
		}
		
		public function get blockDisableSkin():ISkin
		{
			return _blockBtn.disableSkin;
		}
		
		public function set blockDisableSkin(value:ISkin):void
		{
			_blockBtn.disableSkin = value;
			update();
		}
		
		
		public function get trackSkin():ISkin
		{
			return _track.bgSkin;
		}

		public function set trackSkin(value:ISkin):void
		{
			_track.bgSkin = value;
			_track.height = value.bitmapData.height;
			update();
		}
		
		
		private function update():void
		{
			if (_autoSize)
			{
				resize(_width);
			}
			else
			{
				layout();
			}
		}



		override public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));

			if (_blockBtn.rect.containsPoint(p))
			{
				return _blockBtn;
			}
			else if (_track.rect.containsPoint(p))
			{
				return _track;
			}

			return null;
		}



		override public function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = _padding.left + _padding.right;
				width = width < min ? min : width;
				height = _padding.top + _padding.bottom;
			}

			super.resize(width, height);
		}

		override public function setDefaultSize():void
		{
			resize(_width, _padding.top + _padding.bottom);
		}




		override protected function layout():void
		{
			var oy:int = _padding.top;
			var h:int = _padding.top + _padding.bottom;
			if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				oy += _height - h >> 1;
			}
			else if ((_align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy += _height - h;
			}

			_track.x = _padding.left - _track.bgSkin.gridLeft;
			_track.y = oy - _track.bgSkin.gridTop;
			_track.width = _width - _padding.right + _track.bgSkin.paddingRight - _track.x;

			_minX = _padding.left - _blockBtn.upSkin.gridLeft;
			_maxX = _width - _padding.right - _blockBtn.upSkin.gridLeft;
			_blockBtn.y = oy - _blockBtn.upSkin.gridTop;

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



		public function mouseDown(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseDown(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseOut(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseOver(target);
			}
		}

		public function mouseUp(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseUp(target);
			}
		}


		public function keyDown(e:KeyboardEvent):void
		{
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



		public function getDraggable(target:IControl):Boolean
		{
			if (target == _blockBtn)
			{
				return true;
			}
			return false;
		}

		public function setDragCoord(target:IControl, x:int, y:int):void
		{
			var p:Point = globalToLocal(new Point(x, y));

			var w:int = _width - _padding.right - _padding.left;
			var d:int = p.x - _padding.left;
			this.value = Math.round(d / w * (_maximum - _minimum)) + _minimum;
		}
	}
}
