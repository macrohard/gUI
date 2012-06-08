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
	import com.macro.gUI.events.ScrollEvent;
	import com.macro.gUI.events.UIEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;


	/**
	 * 垂直滚动条
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class VScrollBar extends AbstractComposite implements IKeyboard, IDrag, IButton
	{

		protected var _track:Slice;

		protected var _blockBtn:Button;

		protected var _upBtn:Button;

		protected var _downBtn:Button;


		/**
		 * 鼠标点击时的坐标位置
		 */
		private var _mouseY:int;

		/**
		 * 鼠标点击时的滑块位置
		 */
		private var _blockY:int;

		/**
		 * 自动滑动时的计时器标识
		 */
		private var _timerId:int;


		/**
		 * 垂直滚动条控件。利用边距属性定义滑槽的位置，
		 * 再根据滑槽来定位滑块、背景及按钮的位置<br/>
		 * 默认自动设置尺寸
		 * @param height 高度
		 * @param align 布局对齐方式，默认水平居中
		 *
		 */
		public function VScrollBar(height:int = 100, align:int = 0x02)
		{
			//稍后resize时会重设为标准大小
			super(1, height, align);

			_autoSize = true;
			_value = 0;
			_stepSize = 1;
			_pageSize = 10;
			_maximum = 100;

			//四周边距
			_padding = new Margin(8, 10, 8, 10);


			var skin:ISkin = skinMgr.getSkin(SkinDef.SCROLLBAR_VERTICAL_BG);
			_track = new Slice(skin, skin.bitmapData.width, height);

			_blockBtn = new Button();
			_blockBtn.upSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK);
			_blockBtn.overSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_OVER);
			_blockBtn.downSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_DOWN);
			_blockBtn.disableSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_DISABLE);
			_blockBtn.autoSize = false;

			_upBtn = new Button();
			_upBtn.upSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_UP);
			_upBtn.overSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_UP_OVER);
			_upBtn.downSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_UP_DOWN);
			_upBtn.disableSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_UP_DISABLE);

			_downBtn = new Button();
			_downBtn.upSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_DOWN);
			_downBtn.overSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_DOWN_OVER);
			_downBtn.downSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_DOWN_DOWN);
			_downBtn.disableSkin = skinMgr.getSkin(SkinDef.SCROLLBAR_DOWN_DISABLE);

			_container = new Container();
			_container.addChild(_track);
			_container.addChild(_blockBtn);
			_container.addChild(_upBtn);
			_container.addChild(_downBtn);

			resize(0, _height);
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
					resize(0, _height);
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
				resize(0, _height);
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

			dispatchEvent(new UIEvent(UIEvent.VALUE_CHANGED));
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
			_upBtn.enabled = value;
			_downBtn.enabled = value;
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

		
		public function get upButtonUpSkin():ISkin
		{
			return _upBtn.upSkin;
		}
		
		public function set upButtonUpSkin(value:ISkin):void
		{
			_upBtn.upSkin = value;
			update();
		}
		
		public function get upButtonOverSkin():ISkin
		{
			return _upBtn.overSkin;
		}
		
		public function set upButtonOverSkin(value:ISkin):void
		{
			_upBtn.overSkin = value;
		}
		
		public function get upButtonDownSkin():ISkin
		{
			return _upBtn.downSkin;
		}
		
		public function set upButtonDownSkin(value:ISkin):void
		{
			_upBtn.downSkin = value;
		}
		
		public function get upButtonDisableSkin():ISkin
		{
			return _upBtn.disableSkin;
		}
		
		public function set upButtonDisableSkin(value:ISkin):void
		{
			_upBtn.disableSkin = value;
			update();
		}

		
		public function get downButtonUpSkin():ISkin
		{
			return _downBtn.upSkin;
		}
		
		public function set downButtonUpSkin(value:ISkin):void
		{
			_downBtn.upSkin = value;
			update();
		}
		
		public function get downButtonOverSkin():ISkin
		{
			return _downBtn.overSkin;
		}
		
		public function set downButtonOverSkin(value:ISkin):void
		{
			_downBtn.overSkin = value;
		}
		
		public function get downButtonDownSkin():ISkin
		{
			return _downBtn.downSkin;
		}
		
		public function set downButtonDownSkin(value:ISkin):void
		{
			_downBtn.downSkin = value;
		}
		
		public function get downButtonDisableSkin():ISkin
		{
			return _downBtn.disableSkin;
		}
		
		public function set downButtonDisableSkin(value:ISkin):void
		{
			_downBtn.disableSkin = value;
			update();
		}
		
		
		public function get trackSkin():ISkin
		{
			return _track.bgSkin;
		}

		public function set trackSkin(value:ISkin):void
		{
			_track.bgSkin = value;
			_track.width = value.bitmapData.width;
			update();
		}
		
		
		private function update():void
		{
			if (_autoSize)
			{
				resize(0, _height);
			}
			else
			{
				layout();
			}
		}



		override public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));

			_mouseY = p.y;
			_blockY = _blockBtn.y;

			if (_blockBtn.rect.containsPoint(p))
			{
				return _blockBtn;
			}
			else if (_upBtn.rect.containsPoint(p))
			{
				return _upBtn;
			}
			else if (_downBtn.rect.containsPoint(p))
			{
				return _downBtn;
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
				var min:int = _padding.top + _padding.bottom + _blockBtn.height;
				height = height < min ? min : height;
				width = _padding.left + _padding.right;
			}

			super.resize(width, height);
		}

		override public function setDefaultSize():void
		{
			resize(_padding.left + _padding.right, _height);
		}


		override protected function layout():void
		{
			var ox:int = _padding.left;
			var w:int = _padding.left + _padding.right;
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox += _width - w >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox += _width - w;
			}

			_track.x = ox - _track.bgSkin.gridLeft;
			_track.y = _padding.top
			_track.height = _height - _padding.bottom - _track.y;

			_upBtn.x = ox - _upBtn.upSkin.gridLeft;
			_upBtn.y = _padding.top - _upBtn.height;

			_downBtn.x = ox - _downBtn.upSkin.gridLeft;
			_downBtn.y = _height - _padding.bottom;


			_blockBtn.x = ox - _blockBtn.upSkin.gridLeft;

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
				var ratio:Number = _viewport.ratioV;
				if (ratio >= 1)
				{
					_blockBtn.height = _track.height;
					_blockBtn.y = _track.y;
					return;
				}
				else
					_blockBtn.height = ratio * _track.height;
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
			_blockBtn.y = _track.y + ratio * (_track.height - _blockBtn.height);
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
				_viewport.scrollV(ratio);
				dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL));
			}
		}



		public function mouseDown(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseDown(target);
			}
			else if (target == _upBtn)
			{
				_upBtn.mouseDown(target);
				if (_blockBtn.height < _track.height)
				{
					this.value -= _stepSize;
					_timerId = setInterval(autoup, 50);
				}
			}
			else if (target == _downBtn)
			{
				_downBtn.mouseDown(target);
				if (_blockBtn.height < _track.height)
				{
					this.value += _stepSize;
					_timerId = setInterval(autodown, 50);
				}
			}
			else if (target == _track)
			{
				if (_mouseY > _blockBtn.y)
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
			else if (target == _upBtn)
			{
				_upBtn.mouseUp(target);
			}
			else if (target == _downBtn)
			{
				_downBtn.mouseUp(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			clearInterval(_timerId);
			if (target == _blockBtn)
			{
				_blockBtn.mouseOut(target);
			}
			else if (target == _upBtn)
			{
				_upBtn.mouseOut(target);
			}
			else if (target == _downBtn)
			{
				_downBtn.mouseOut(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target == _blockBtn)
			{
				_blockBtn.mouseOver(target);
			}
			else if (target == _upBtn)
			{
				_upBtn.mouseOver(target);
			}
			else if (target == _downBtn)
			{
				_downBtn.mouseOver(target);
			}
		}

		private function autoup():void
		{
			this.value -= _stepSize;
		}

		private function autodown():void
		{
			this.value += _stepSize;
		}


		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.UP)
			{
				this.value -= _stepSize;
			}
			else if (e.keyCode == Keyboard.DOWN)
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

			var j:int = _blockY + (p.y - _mouseY);
			var max:int = _track.y + _track.height - _blockBtn.height;
			j = j < _track.y ? _track.y : (j > max ? max : j);
			_blockBtn.y = j;

			var ratio:Number = (j - _track.y) / (_track.height - _blockBtn.height);
			if (isNaN(ratio) || ratio < 0)
			{
				ratio = 0;
			}
			_value = ratio * (_maximum - _minimum) + _minimum;

			scrollViewport(ratio);
		}

	}
}
