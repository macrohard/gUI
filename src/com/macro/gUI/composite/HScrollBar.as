package com.macro.gUI.composite
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IDrag;
	import com.macro.gUI.core.feature.IKeyboard;
	import com.macro.gUI.events.ScrollBarEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;


	/**
	 * 水平滚动条
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class HScrollBar extends AbstractComposite implements IKeyboard, IDrag, IButton
	{

		protected var _track:Slice;

		protected var _blockBtn:Button;

		protected var _leftBtn:Button;

		protected var _rightBtn:Button;


		/**
		 * 鼠标点击时的坐标位置
		 */
		private var _mouseX:int;

		/**
		 * 鼠标点击时的滑块位置
		 */
		private var _blockX:int;

		/**
		 * 自动滑动时的计时器标识
		 */
		private var _timerId:int;


		/**
		 * 水平滚动条控件。利用边距属性定义滑槽的位置，
		 * 再根据滑槽来定位滑块、背景和按钮的位置。<br/>
		 * 默认自动设置尺寸
		 * @param width 宽度
		 * @param align 布局对齐方式，默认垂直居中
		 *
		 */
		public function HScrollBar(width:int = 100, align:int = 0x20)
		{
			//稍后resize时会重设为标准大小
			super(width, 1, align);

			_autoSize = true;
			_value = 0;
			_stepSize = 1;
			_pageSize = 10;
			_maximum = 100;

			//四周边距
			_padding = new Margin(10, 8, 10, 8);


			var skin:ISkin = skinMgr.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BG);
			_track = new Slice(skin, width, skin.bitmapData.height);

			_blockBtn = new Button();
			_blockBtn.upSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK);
			_blockBtn.overSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_OVER);
			_blockBtn.downSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_DOWN);
			_blockBtn.disableSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_DISABLE);
			_blockBtn.autoSize = false;

			_leftBtn = new Button();
			_leftBtn.upSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_LEFT);
			_leftBtn.overSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_LEFT_OVER);
			_leftBtn.downSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_LEFT_DOWN);
			_leftBtn.disableSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_LEFT_DISABLE);

			_rightBtn = new Button();
			_rightBtn.upSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_RIGHT);
			_rightBtn.overSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_RIGHT_OVER);
			_rightBtn.downSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_RIGHT_DOWN);
			_rightBtn.disableSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_RIGHT_DISABLE);

			_container = new Container();
			_container.addChild(_track);
			_container.addChild(_blockBtn);
			_container.addChild(_leftBtn);
			_container.addChild(_rightBtn);

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


		private var _viewport:Viewport;

		/**
		 * 由滚动条控制的视口
		 * @return
		 *
		 */
		public function get viewport():Viewport
		{
			return _viewport;
		}

		public function set viewport(value:Viewport):void
		{
			_viewport = value;
			resetScrollBar();
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


		private var _pageSize:int;

		/**
		 * 按翻页键以及点击滑槽背景时的滚动步长
		 * @return
		 *
		 */
		public function get pageSize():int
		{
			return _pageSize;
		}

		public function set pageSize(value:int):void
		{
			_pageSize = value;
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


		private var _value:Number;

		/**
		 * 当前值
		 * @return
		 *
		 */
		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value < _minimum ? _minimum : (value > _maximum ? _maximum : value);
			relocateBlock();

			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.VALUE_CHANGED));
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
			_leftBtn.enabled = value;
			_rightBtn.enabled = value;
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
		
		
		public function get leftButtonUpSkin():ISkin
		{
			return _leftBtn.upSkin;
		}

		public function set leftButtonUpSkin(value:ISkin):void
		{
			_leftBtn.upSkin = value;
			update();
		}
		
		public function get leftButtonOverSkin():ISkin
		{
			return _leftBtn.overSkin;
		}
		
		public function set leftButtonOverSkin(value:ISkin):void
		{
			_leftBtn.overSkin = value;
		}
		
		public function get leftButtonDownSkin():ISkin
		{
			return _leftBtn.downSkin;
		}
		
		public function set leftButtonDownSkin(value:ISkin):void
		{
			_leftBtn.downSkin = value;
		}
		
		public function get leftButtonDisableSkin():ISkin
		{
			return _leftBtn.disableSkin;
		}
		
		public function set leftButtonDisableSkin(value:ISkin):void
		{
			_leftBtn.disableSkin = value;
			update();
		}

		
		public function get rightButtonUpSkin():ISkin
		{
			return _rightBtn.upSkin;
		}
		
		public function set rightButtonUpSkin(value:ISkin):void
		{
			_rightBtn.upSkin = value;
			update();
		}
		
		public function get rightButtonOverSkin():ISkin
		{
			return _rightBtn.overSkin;
		}
		
		public function set rightButtonOverSkin(value:ISkin):void
		{
			_rightBtn.overSkin = value;
		}
		
		public function get rightButtonDownSkin():ISkin
		{
			return _rightBtn.downSkin;
		}
		
		public function set rightButtonDownSkin(value:ISkin):void
		{
			_rightBtn.downSkin = value;
		}
		
		public function get rightButtonDisableSkin():ISkin
		{
			return _rightBtn.disableSkin;
		}
		
		public function set rightButtonDisableSkin(value:ISkin):void
		{
			_rightBtn.disableSkin = value;
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

			_mouseX = p.x;
			_blockX = _blockBtn.x;

			if (_blockBtn.rect.containsPoint(p))
			{
				return _blockBtn;
			}
			else if (_leftBtn.rect.containsPoint(p))
			{
				return _leftBtn;
			}
			else if (_rightBtn.rect.containsPoint(p))
			{
				return _rightBtn;
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
				var min:int = _padding.left + _padding.right + _blockBtn.width;
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

			_track.x = _padding.left;
			_track.y = oy - _track.bgSkin.gridTop;
			_track.width = _width - _padding.right - _track.x;

			_leftBtn.x = _padding.left - _leftBtn.width;
			_leftBtn.y = oy - _leftBtn.upSkin.gridTop;

			_rightBtn.x = _width - _padding.right;
			_rightBtn.y = oy - _rightBtn.upSkin.gridTop;

			_blockBtn.y = oy - _blockBtn.upSkin.gridTop;

			resetScrollBar();
		}

		/**
		 * 重置滑动块的大小及位置
		 *
		 */
		public function resetScrollBar():void
		{
			if (_viewport)
			{
				var ratio:Number = _viewport.ratioH;
				if (ratio >= 1)
				{
					_blockBtn.width = _track.width;
					_blockBtn.x = _track.x;
					return;
				}
				else
				{
					_blockBtn.width = ratio * _track.width;
				}
			}
			else
			{
				_blockBtn.setDefaultSize();
			}
			relocateBlock();
		}

		/**
		 * 定位滑动块的位置
		 *
		 */
		private function relocateBlock():void
		{
			var ratio:Number = (_value - _minimum) / (_maximum - _minimum);
			if (isNaN(ratio) || ratio < 0)
			{
				ratio = 0;
			}
			_blockBtn.x = _track.x + ratio * (_track.width - _blockBtn.width);
			scrollViewport(ratio);
		}

		/**
		 * 卷动视口
		 * @param ratio
		 *
		 */
		private function scrollViewport(ratio:Number):void
		{
			if (_viewport != null)
			{
				_viewport.scrollH(ratio);
				dispatchEvent(new ScrollBarEvent(ScrollBarEvent.SCROLL));
			}
		}



		public function mouseDown(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseDown(target);
			}
			else if (target == _leftBtn)
			{
				_leftBtn.mouseDown(target);
				if (_blockBtn.width < _track.width)
				{
					this.value -= _stepSize;
					_timerId = setInterval(autoleft, 50);
				}
			}
			else if (target == _rightBtn)
			{
				_rightBtn.mouseDown(target);
				if (_blockBtn.width < _track.width)
				{
					this.value += _stepSize;
					_timerId = setInterval(autoright, 50);
				}
			}
			else if (target == _track)
			{
				if (_mouseX > _blockBtn.x)
				{
					this.value += _pageSize;
				}
				else
				{
					this.value -= _pageSize;
				}
			}
		}

		public function mouseUp(target:IControl):void
		{
			clearInterval(_timerId);
			if (target == _blockBtn)
			{
				_blockBtn.mouseUp(target);
			}
			else if (target == _leftBtn)
			{
				_leftBtn.mouseUp(target);
			}
			else if (target == _rightBtn)
			{
				_rightBtn.mouseUp(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			clearInterval(_timerId);
			if (target == _blockBtn)
			{
				_blockBtn.mouseOut(target);
			}
			else if (target == _leftBtn)
			{
				_leftBtn.mouseOut(target);
			}
			else if (target == _rightBtn)
			{
				_rightBtn.mouseOut(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseOver(target);
			}
			else if (target == _leftBtn)
			{
				_leftBtn.mouseOver(target);
			}
			else if (target == _rightBtn)
			{
				_rightBtn.mouseOver(target);
			}
		}

		private function autoleft():void
		{
			this.value -= _stepSize;
		}

		private function autoright():void
		{
			this.value += _stepSize;
		}


		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.LEFT)
			{
				this.value -= _stepSize;
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				this.value += _stepSize;
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

			var j:int = _blockX + (p.x - _mouseX);
			var max:int = _track.x + _track.width - _blockBtn.width;
			j = j < _track.x ? _track.x : (j > max ? max : j);
			_blockBtn.x = j;

			var ratio:Number = (j - _track.x) / (_track.width - _blockBtn.width);
			if (isNaN(ratio) || ratio < 0)
			{
				ratio = 0;
			}
			_value = ratio * (_maximum - _minimum) + _minimum;

			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.VALUE_CHANGED));
			scrollViewport(ratio);
		}

	}
}
