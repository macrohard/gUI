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
	 * 垂直滚动条
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class VScrollBar extends AbstractComposite implements IKeyboard, IDrag, IButton, IFocus
	{
		
		private var _track:Slice;
		
		private var _blockBtn:Button;
		
		private var _upBtn:Button;
		
		private var _downBtn:Button;
		
		
		/**
		 * 鼠标点击的对象
		 */
		private var _mouseObj:IControl;
		
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
		 * 然后根据滑块和背景的皮肤九切片定义来定位滑块及背景的位置
		 * @param height 高度
		 * @param align 布局对齐方式，默认水平居中
		 * @param blockSkin 滑块皮肤
		 * @param bgSkin 背景皮肤
		 * @param upBtnSkin 上滚动按钮皮肤
		 * @param downBtnSkin 下滚动按钮皮肤
		 * 
		 */
		public function VScrollBar(height:int = 100, align:int = 0x02, blockSkin:ISkin = null, bgSkin:ISkin = null,
								   upBtnSkin:ISkin = null, downBtnSkin:ISkin = null)
		{
			super(20, height, align);
			
			//默认自动设置高度
			_autoSize = true;
			
			_value = 0;
			_stepSize = 1;
			_pageSize = 10;
			_maximum = 100;
			
			//四周边距均默认为10
			_padding = new Rectangle(10, 10);
			
			
			bgSkin = bgSkin ? bgSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_VERTICAL_BG);
			_track = new Slice(bgSkin, bgSkin.bitmapData.width, height);
			
			blockSkin = blockSkin ? blockSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_NORMAL);
			_blockBtn = new Button(null, null, 0x22, blockSkin);
			_blockBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_OVER);
			_blockBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_DOWN);
			_blockBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_VERTICAL_BLOCK_DISABLE);
			_blockBtn.autoSize = false;
			
			upBtnSkin = upBtnSkin ? upBtnSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_UP_NORMAL);
			_upBtn = new Button(null, null, 0x22, upBtnSkin);
			_upBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_UP_OVER);
			_upBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_UP_DOWN);
			_upBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_UP_DISABLE);
			
			downBtnSkin = downBtnSkin ? downBtnSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_DOWN_NORMAL);
			_downBtn = new Button(null, null, 0x22, downBtnSkin);
			_downBtn.overSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_DOWN_OVER);
			_downBtn.downSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_DOWN_DOWN);
			_downBtn.disableSkin = GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_DOWN_DISABLE);
			
			_container = new Container();
			_container.addChild(_track);
			_container.addChild(_blockBtn);
			_container.addChild(_upBtn);
			_container.addChild(_downBtn);
			
			resize(0, _rect.height);
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
					resize(0, _rect.height);
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
					resize(0, _rect.height);
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
			_upBtn.enabled = value;
			_downBtn.enabled = value;
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
		
		
		public function get upNormalSkin():ISkin
		{
			return _upBtn.normalSkin;
		}
		
		public function set upNormalSkin(value:ISkin):void
		{
			_upBtn.normalSkin = value;
			layout();
		}
		
		public function get upOverSkin():ISkin
		{
			return _upBtn.overSkin;
		}
		
		public function set upOverSkin(value:ISkin):void
		{
			_upBtn.overSkin = value;
			layout();
		}
		
		public function get upDownSkin():ISkin
		{
			return _upBtn.downSkin;
		}
		
		public function set upDownSkin(value:ISkin):void
		{
			_upBtn.downSkin = value;
			layout();
		}
		
		public function get upDisableSkin():ISkin
		{
			return _upBtn.disableSkin;
		}
		
		public function set upDisableSkin(value:ISkin):void
		{
			_upBtn.disableSkin = value;
			layout();
		}
		
		public function get downNormalSkin():ISkin
		{
			return _downBtn.normalSkin;
		}
		
		public function set downNormalSkin(value:ISkin):void
		{
			_downBtn.normalSkin = value;
			layout();
		}
		
		public function get downOverSkin():ISkin
		{
			return _downBtn.overSkin;
		}
		
		public function set downOverSkin(value:ISkin):void
		{
			_downBtn.overSkin = value;
			layout();
		}
		
		public function get downDownSkin():ISkin
		{
			return _downBtn.downSkin;
		}
		
		public function set downDownSkin(value:ISkin):void
		{
			_downBtn.downSkin = value;
			layout();
		}
		
		public function get downDisableSkin():ISkin
		{
			return _downBtn.disableSkin;
		}
		
		public function set downDisableSkin(value:ISkin):void
		{
			_downBtn.disableSkin = value;
			layout();
		}
		
		
		public function get bgSkin():ISkin
		{
			return _track.skin;
		}
		
		public function set bgSkin(value:ISkin):void
		{
			_track.skin = value;
			_track.width = value.bitmapData.width;
			layout();
		}
		
		
		
		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = _padding.top + _padding.bottom + _blockBtn.height;
				height = height < min ? min : height;
				width = _padding.left + _padding.right;
			}
			
			super.resize(width, height);
		}
		
		public override function setDefaultSize():void
		{
			resize(_padding.left + _padding.right, _rect.height);
		}
		
		
		protected override function layout():void
		{
			var ox:int = _padding.left;
			var w:int = _padding.left + _padding.right;
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox += (_rect.width - w) >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox += _rect.width - w;
			}
			
			_track.x = ox - _track.skin.gridLeft;
			_track.y = _padding.top
			_track.height = _rect.height - _padding.bottom - _track.y;
			
			_upBtn.x = ox - _upBtn.normalSkin.gridLeft;
			_upBtn.y = _padding.top - _upBtn.height;
			
			_downBtn.x = ox - _downBtn.normalSkin.gridLeft;
			_downBtn.y = _rect.height - _padding.bottom;
			
			
			_blockBtn.x = ox - _blockBtn.normalSkin.gridLeft;
			
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
			}
		}
		
		
		
		public function hitTest(x:int, y:int):IControl
		{
			var p:Point = this.globalCoord();
			x -= p.x;
			y -= p.y;
			
			_mouseObj = null;
			_mouseY = y;
			_blockY = _blockBtn.y;
			
			if (_blockBtn.rect.contains(x, y))
			{
				_mouseObj = _blockBtn;
			}
			else if (_upBtn.rect.contains(x, y))
			{
				_mouseObj = _upBtn;
			}
			else if (_downBtn.rect.contains(x, y))
			{
				_mouseObj = _downBtn;
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
			else if (_mouseObj == _upBtn)
			{
				_upBtn.mouseDown();
				if (_blockBtn.height < _track.height)
				{
					this.value -= _stepSize;
					_timerId = setInterval(autoup, 50);
				}
			}
			else if (_mouseObj == _downBtn)
			{
				_downBtn.mouseDown();
				if (_blockBtn.height < _track.height)
				{
					this.value += _stepSize;
					_timerId = setInterval(autodown, 50);
				}
			}
			else if (_mouseObj == _track)
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
			else if (_mouseObj == _upBtn)
			{
				_upBtn.mouseUp();
			}
			else if (_mouseObj == _downBtn)
			{
				_downBtn.mouseUp();
			}
		}
		
		public function mouseOut():void
		{
			clearInterval(_timerId);
			_blockBtn.mouseOut();
			_upBtn.mouseOut();
			_downBtn.mouseOut();
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
			else if (_mouseObj == _upBtn)
			{
				_upBtn.mouseOver();
			}
			else if (_mouseObj == _downBtn)
			{
				_downBtn.mouseOver();
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
			if (!_blockBtn.enabled)
			{
				return;
			}
			
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
			
			var j:int = _blockY + (y - _mouseY);
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
