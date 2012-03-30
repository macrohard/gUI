package com.macro.gUI.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Viewport;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IDrag;
	import com.macro.gUI.base.feature.IFocus;
	import com.macro.gUI.base.feature.IKeyboard;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.Slice;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;


	/**
	 * 水平滚动条
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class HScrollBar extends AbstractComposite implements IKeyboard, IDrag, IButton, IFocus
	{

		private var _track:Slice;

		private var _blockBtn:Button;

		private var _leftBtn:Button;

		private var _rightBtn:Button;


		/**
		 * 鼠标点击的对象
		 */
		private var _mouseObj:IControl;

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
		 * 然后根据滑块和背景的皮肤九切片定义来定位滑块及背景的位置
		 * @param width 宽度
		 * @param align 布局对齐方式，默认垂直居中
		 * @param blockSkin 滑块皮肤
		 * @param bgSkin 背景皮肤
		 * @param leftBtnSkin 左滚动按钮皮肤
		 * @param rightBtnSkin 右滚动按钮皮肤
		 *
		 */
		public function HScrollBar(width:int = 100, align:int = 0x20, blockSkin:ISkin = null, bgSkin:ISkin = null,
								   leftBtnSkin:ISkin = null, rightBtnSkin:ISkin = null)
		{
			super(width, 20, align);

			//默认自动设置高度
			_autoSize = true;

			_value = 0;
			_stepSize = 1;
			_pageSize = 10;
			_maximum = 100;

			//四周边距均默认为10
			_padding = new Rectangle(10, 10);


			bgSkin = bgSkin ? bgSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BG);
			_track = new Slice(bgSkin, width, bgSkin.bitmapData.height);

			blockSkin = blockSkin ? blockSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_NORMAL);
			_blockBtn = new Button(null, null, 0x22, blockSkin);
			_blockBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_OVER);
			_blockBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_DOWN);
			_blockBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_HORIZONTAL_BLOCK_DISABLE);
			_blockBtn.autoSize = false;

			leftBtnSkin = leftBtnSkin ? leftBtnSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_LEFT_NORMAL);
			_leftBtn = new Button(null, null, 0x22, leftBtnSkin);
			_leftBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_LEFT_OVER);
			_leftBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_LEFT_DOWN);
			_leftBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_LEFT_DISABLE);

			rightBtnSkin = rightBtnSkin ? rightBtnSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_RIGHT_NORMAL);
			_rightBtn = new Button(null, null, 0x22, rightBtnSkin);
			_rightBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_RIGHT_OVER);
			_rightBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_RIGHT_DOWN);
			_rightBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_RIGHT_DISABLE);

			_container = new Container();
			_container.addChild(_track);
			_container.addChild(_blockBtn);
			_container.addChild(_leftBtn);
			_container.addChild(_rightBtn);

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


		public function get enabled():Boolean
		{
			return _blockBtn.enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_blockBtn.enabled = value;
			_leftBtn.enabled = value;
			_rightBtn.enabled = value;
		}


		
		public function get dragMode():int
		{
			if (_mouseObj == _blockBtn)
			{
				return DragMode.INTERNAL;
			}

			return DragMode.NONE;
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


		public function get leftNormalSkin():ISkin
		{
			return _leftBtn.normalSkin;
		}

		public function set leftNormalSkin(value:ISkin):void
		{
			_leftBtn.normalSkin = value;
			layout();
		}

		public function get leftOverSkin():ISkin
		{
			return _leftBtn.overSkin;
		}

		public function set leftOverSkin(value:ISkin):void
		{
			_leftBtn.overSkin = value;
			layout();
		}

		public function get leftDownSkin():ISkin
		{
			return _leftBtn.downSkin;
		}

		public function set leftDownSkin(value:ISkin):void
		{
			_leftBtn.downSkin = value;
			layout();
		}

		public function get leftDisableSkin():ISkin
		{
			return _leftBtn.disableSkin;
		}

		public function set leftDisableSkin(value:ISkin):void
		{
			_leftBtn.disableSkin = value;
			layout();
		}

		public function get rightNormalSkin():ISkin
		{
			return _rightBtn.normalSkin;
		}

		public function set rightNormalSkin(value:ISkin):void
		{
			_rightBtn.normalSkin = value;
			layout();
		}

		public function get rightOverSkin():ISkin
		{
			return _rightBtn.overSkin;
		}

		public function set rightOverSkin(value:ISkin):void
		{
			_rightBtn.overSkin = value;
			layout();
		}

		public function get rightDownSkin():ISkin
		{
			return _rightBtn.downSkin;
		}

		public function set rightDownSkin(value:ISkin):void
		{
			_rightBtn.downSkin = value;
			layout();
		}

		public function get rightDisableSkin():ISkin
		{
			return _rightBtn.disableSkin;
		}

		public function set rightDisableSkin(value:ISkin):void
		{
			_rightBtn.disableSkin = value;
			layout();
		}

		public function get bgSkin():ISkin
		{
			return _track.skin;
		}

		public function set bgSkin(value:ISkin):void
		{
			_track.skin = value;
			_track.height = value.bitmapData.height;
			layout();
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = _padding.left + _padding.right + _blockBtn.width;
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
				oy += _rect.height - h >> 1;
			}
			else if ((_align & LayoutAlign.BOTTOM) == LayoutAlign.BOTTOM)
			{
				oy += _rect.height - h;
			}

			_track.x = _padding.left;
			_track.y = oy - _track.skin.gridTop;
			_track.width = _rect.width - _padding.right - _track.x;

			_leftBtn.x = _padding.left - _leftBtn.width;
			_leftBtn.y = oy - _leftBtn.normalSkin.gridTop;

			_rightBtn.x = _rect.width - _padding.right;
			_rightBtn.y = oy - _rightBtn.normalSkin.gridTop;

			_blockBtn.y = oy - _blockBtn.normalSkin.gridTop;

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
			}
		}


		public function hitTest(x:int, y:int):IControl
		{
			var p:Point = this.globalCoord();
			x -= p.x;
			y -= p.y;
			
			_mouseObj = null;
			_mouseX = x;
			_blockX = _blockBtn.x;

			if (_blockBtn.rect.contains(x, y))
			{
				_mouseObj = _blockBtn;
			}
			else if (_leftBtn.rect.contains(x, y))
			{
				_mouseObj = _leftBtn;
			}
			else if (_rightBtn.rect.contains(x, y))
			{
				_mouseObj = _rightBtn;
			}
			else if (_track.rect.contains(x, y))
			{
				_mouseObj = _track;
			}

			return _mouseObj;
		}

		public function mouseDown():void
		{
			if (!_blockBtn.enabled)
			{
				return;
			}

			if (_mouseObj == _blockBtn)
			{
				_blockBtn.mouseDown();
			}
			else if (_mouseObj == _leftBtn)
			{
				_leftBtn.mouseDown();
				if (_blockBtn.width < _track.width)
				{
					this.value -= _stepSize;
					_timerId = setInterval(autoleft, 50);
				}
			}
			else if (_mouseObj == _rightBtn)
			{
				_rightBtn.mouseDown();
				if (_blockBtn.width < _track.width)
				{
					this.value += _stepSize;
					_timerId = setInterval(autoright, 50);
				}
			}
			else if (_mouseObj == _track)
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

		public function mouseUp():void
		{
			clearInterval(_timerId);
			if (!_blockBtn.enabled)
			{
				return;
			}

			if (_mouseObj == _blockBtn)
			{
				_blockBtn.mouseUp();
			}
			else if (_mouseObj == _leftBtn)
			{
				_leftBtn.mouseUp();
			}
			else if (_mouseObj == _rightBtn)
			{
				_rightBtn.mouseUp();
			}
		}

		public function mouseOut():void
		{
			clearInterval(_timerId);
			_blockBtn.mouseOut();
			_leftBtn.mouseOut();
			_rightBtn.mouseOut();
		}

		public function mouseOver():void
		{
			if (!_blockBtn.enabled)
			{
				return;
			}

			if (_mouseObj == _blockBtn)
			{
				_blockBtn.mouseOver();
			}
			else if (_mouseObj == _leftBtn)
			{
				_leftBtn.mouseOver();
			}
			else if (_mouseObj == _rightBtn)
			{
				_rightBtn.mouseOver();
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
			if (!_blockBtn.enabled)
			{
				return;
			}

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
			
			var p:Point = this.globalCoord();
			x -= p.x;
			y -= p.y;

			var j:int = _blockX + (x - _mouseX);
			var max:int = _track.x + _track.width - _blockBtn.width;
			j = j < _track.x ? _track.x : (j > max ? max : j);
			_blockBtn.x = j;
			
			var ratio:Number = (j - _track.x) / (_track.width - _blockBtn.width);
			if (isNaN(ratio) || ratio < 0)
			{
				ratio = 0;
			}
			_value = ratio * (_maximum - _minimum) + _minimum;
			
			scrollViewport(ratio);
		}

	}
}
