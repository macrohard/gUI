package com.macro.gUI.controls.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.DragMode;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.Viewport;
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
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**
	 * 垂直滚动条
	 * @author Macro776@gmail.com
	 *
	 */
	public class VScrollBar extends AbstractComposite implements IKeyboard, IDrag, IButton
	{
		
		private var _stepSize:int;
		
		private var _pageSize:int;
		
		private var _minimum:int;
		
		private var _maximum:int;
		
		private var _value:Number;
		
		
		
		private var _track:Slice;
		
		private var _blockBtn:Button;
		
		private var _upBtn:Button;
		
		private var _downBtn:Button;
		
		
		private var _autoSize:Boolean;
		
		private var _margin:Rectangle;
		
		private var _viewport:Viewport;
		
		
		
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
			_margin = new Rectangle(10, 10);
			
			
			bgSkin = bgSkin ? bgSkin : GameUI.skinManager.getSkin(SkinDef.SCROLLBAR_VERTICAL_BG);
			_track = new Slice(bgSkin.bitmapData.width, height, bgSkin);
			
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
			
			_children.push(_track);
			_children.push(_blockBtn);
			_children.push(_upBtn);
			_children.push(_downBtn);
			
			resize(0, _rect.height);
		}
		
		
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
					resize(0, _rect.height);
			}
		}
		
		/**
		 * 滑槽与四周的边距
		 * @return
		 *
		 */
		public function get margin():Rectangle
		{
			return _margin;
		}
		
		public function set margin(value:Rectangle):void
		{
			if (!_margin || !_margin.equals(value))
			{
				_margin = value;
				if (_autoSize)
					resize(0, _rect.height);
				else
					layout();
			}
		}
		
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
		
		
		
		override public function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = _margin.top + _margin.bottom + _blockBtn.height;
				height = height < min ? min : height;
				width = _margin.left + _margin.right;
			}
			
			super.resize(width, height);
		}
		
		override public function setDefaultSize():void
		{
			resize(_margin.left + _margin.right, _rect.height);
		}
		
		
		
		
		override protected function layout():void
		{
			var ox:int = _margin.left;
			var w:int = _margin.left + _margin.right;
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
				ox += (_rect.width - w) >> 1;
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
				ox += _rect.width - w;
			
			_track.x = ox - _track.skin.gridLeft;
			_track.y = _margin.top
			_track.height = _rect.height - _margin.bottom - _track.y;
			
			_upBtn.x = ox - _upBtn.normalSkin.gridLeft;
			_upBtn.y = _margin.top - _upBtn.height;
			
			_downBtn.x = ox - _downBtn.normalSkin.gridLeft;
			_downBtn.y = _rect.height - _margin.bottom;
			
			
			_blockBtn.x = ox - _blockBtn.normalSkin.gridLeft;
			
			resetScrollBar();
		}
		
		public function resetScrollBar():void
		{
			if (_viewport)
			{
				var ratio:Number = _viewport.containerRect.height / _viewport.scrollTarget.rect.height;
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
		
		private function relocateBlock():void
		{
			var ratio:Number = (_value - _minimum) / (_maximum - _minimum);
			_blockBtn.y = _track.y + ratio * (_track.height - _blockBtn.height);
			scrollViewport();
		}
		
		/**
		 * TODO 设置Viewport滚动位置
		 * 
		 */
		private function scrollViewport():void
		{
			
		}
		
		
		
		//==============================================================
		// 样式定义
		
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
		
		
		
		//==============================================================
		// 接口实现
		
		private var _tabIndex:int;
		
		private var _mouseObj:IControl;
		
		private var _mouseY:int;
		
		private var _blockY:int;
		
		private var _timer:int;
		
		
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
		
		public function get focusable():Boolean
		{
			return true;
		}
		
		public function get tabIndex():int
		{
			return _tabIndex;
		}
		
		public function set tabIndex(value:int):void
		{
			_tabIndex = value;
		}
		
		
		
		public function hitTest(x:int, y:int):IControl
		{
			_mouseY = y;
			_blockY = _blockBtn.y;
			
			if (_blockBtn.rect.contains(x, y))
				_mouseObj = _blockBtn;
			else if (_upBtn.rect.contains(x, y))
				_mouseObj = _upBtn;
			else if (_downBtn.rect.contains(x, y))
				_mouseObj = _downBtn;
			else if (_track.rect.contains(x, y))
				_mouseObj = _track;
			else
				_mouseObj = null;
			
			return _mouseObj;
		}
		
		public function mouseDown():void
		{
			if (!_blockBtn.enabled)
				return;
			
			if (_mouseObj == _blockBtn)
				_blockBtn.mouseDown();
			else if (_mouseObj == _upBtn)
			{
				_upBtn.mouseDown();
				this.value -= _stepSize;
				_timer = setInterval(autoup, 50);
			}
			else if (_mouseObj == _downBtn)
			{
				_downBtn.mouseDown();
				this.value += _stepSize;
				_timer = setInterval(autodown, 50);
			}
			else if (_mouseObj == _track)
			{
				if (_mouseY > _blockBtn.y)
					this.value += _pageSize;
				else
					this.value -= _pageSize;
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
		
		public function mouseUp():void
		{
			clearInterval(_timer);
			if (!_blockBtn.enabled)
				return;
			
			if (_mouseObj == _blockBtn)
				_blockBtn.mouseUp();
			else if (_mouseObj == _upBtn)
				_upBtn.mouseUp();
			else if (_mouseObj == _downBtn)
				_downBtn.mouseUp();
		}
		
		public function mouseOut():void
		{
			clearInterval(_timer);
			_blockBtn.mouseOut();
			_upBtn.mouseOut();
			_downBtn.mouseOut();
		}
		
		public function mouseOver():void
		{
			if (!_blockBtn.enabled)
				return;
			
			if (_mouseObj == _blockBtn)
				_blockBtn.mouseOver();
			else if (_mouseObj == _upBtn)
				_upBtn.mouseOver();
			else if (_mouseObj == _downBtn)
				_downBtn.mouseOver();
		}
		
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (!_blockBtn.enabled)
				return;
			
			if (e.keyCode == Keyboard.UP)
				this.value -= _stepSize;
			else if (e.keyCode == Keyboard.DOWN)
				this.value += _stepSize;
			
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
		}
		
		
		
		public function get dragMode():int
		{
			if (_mouseObj == _blockBtn)
				return DragMode.INTERNAL;
			
			return DragMode.NONE;
		}
		
		public function getDragImage():BitmapData
		{
			return null;
		}
		
		public function setDragPos(x:int, y:int):void
		{
			if (_mouseObj != _blockBtn || !_blockBtn.enabled)
				return;
			
			var p:int = _blockY + (y - _mouseY);
			var max:int = _track.y + _track.height - _blockBtn.height;
			p = p < _track.y ? _track.y : (p > max ? max : p);
			_blockBtn.y = p;
			_value = (p - _track.y) / (_track.height - _blockBtn.height) * (_maximum - _minimum) + _minimum;
			scrollViewport();
		}
		
	}
}
