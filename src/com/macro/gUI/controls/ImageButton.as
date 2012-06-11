package com.macro.gUI.controls
{
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IKeyboard;
	import com.macro.gUI.events.ButtonEvent;
	import com.macro.gUI.skin.ISkin;
	import com.macro.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * 图片按钮控件
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class ImageButton extends ImageBox implements IButton, IKeyboard
	{
		
		/**
		 * 四态图片
		 */
		protected var _states:Dictionary;
		
		
		/**
		 * 鼠标位置
		 */
		protected var _mousePoint:Point;
		
		/**
		 * 鼠标按下位置
		 */
		protected var _mouseDownPoint:Point;
		
		/**
		 * 鼠标点击位置
		 */
		protected var _clickPoint:Point;
		
		/**
		 * 鼠标点击时间戳
		 */
		protected var _clickTime:int;
		
		
		/**
		 * 图片按钮控件，有四态。
		 * @param upState 常态
		 * @param autoSize 是否自动设置尺寸，默认true
		 * @param align 显示内容的对齐方式，默认左上角对齐
		 * @param skin 边框皮肤
		 * 
		 */
		public function ImageButton(upState:IBitmapDrawable = null, autoSize:Boolean = true, align:int = 0x11, skin:ISkin = null)
		{
			_states = new Dictionary();
			_states[CtrlState.UP] = _image;
			
			super(upState, autoSize, align, skin);
		}
		
		
		protected var _precise:Boolean;
		
		/**
		 * 是否精确测试，如果为true，则按像素来判断，否则只考虑范围矩形。默认值是false
		 * @return
		 *
		 */
		public function get precise():Boolean
		{
			return _precise;
		}
		
		public function set precise(value:Boolean):void
		{
			_precise = value;
		}
		
		
		protected var _tabIndex:int;
		
		public function get tabIndex():int
		{
			return _tabIndex;
		}
		
		public function set tabIndex(value:int):void
		{
			_tabIndex = value;
		}
		
		
		override public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				if (_enabled)
				{
					_image = _states[CtrlState.UP];
				}
				else
				{
					_image = _states[CtrlState.DISABLE];
					_image = _image ? _image : _states[CtrlState.UP];
				}
				
				resize();
			}
		}
		
		
		override public function set image(value:IBitmapDrawable):void
		{
			var tmp:BitmapData = _states[CtrlState.UP];
			var img:BitmapData = ImageUtil.getBitmapData(value);
			
			_states[CtrlState.UP] = img;
			if (_image == tmp)
			{
				_image = img;
				resize();
			}
			
			if (tmp != null)
			{
				tmp.dispose();
			}
		}
		
		
		public function set imageOver(value:IBitmapDrawable):void
		{
			_states[CtrlState.OVER] = ImageUtil.getBitmapData(value);
		}
		
		public function set imageDown(value:IBitmapDrawable):void
		{
			_states[CtrlState.DOWN] = ImageUtil.getBitmapData(value);
		}
		
		public function set imageDisable(value:IBitmapDrawable):void
		{
			var tmp:BitmapData = _states[CtrlState.DISABLE];
			var img:BitmapData = ImageUtil.getBitmapData(value);
			
			_states[CtrlState.DISABLE] = img;
			if (_image == tmp)
			{
				_image = img;
				resize();
			}
			
			if (tmp != null)
			{
				tmp.dispose();
			}
		}
		
		
		override public function hitTest(x:int, y:int):IControl
		{
			_mousePoint = globalToLocal(new Point(x, y));
			
			if (_precise)
			{
				if (_bitmapData.getPixel32(_mousePoint.x, _mousePoint.y) != 0)
				{
					return this;
				}
			}
			else
			{
				if (_bitmapData.rect.containsPoint(_mousePoint))
				{
					return this;
				}
			}
			return null;
		}
		
		
		public function mouseDown(target:IControl):void
		{
			if (_image != _states[CtrlState.DOWN])
			{
				_image = _states[CtrlState.DOWN];
				_image = _image ? _image : _states[CtrlState.UP];
				resize();
			}
			
			dispatchEvent(new ButtonEvent(ButtonEvent.MOUSE_DOWN));
			// 记录鼠标按下位置
			_mouseDownPoint = _mousePoint;
		}
		
		public function mouseUp(target:IControl):void
		{
			if (_image != _states[CtrlState.OVER])
			{
				_image = _states[CtrlState.OVER];
				_image = _image ? _image : _states[CtrlState.UP];
				resize();
			}
			
			dispatchEvent(new ButtonEvent(ButtonEvent.MOUSE_UP));
			// 如果有按下位置，则执行Click测试
			if (_mouseDownPoint != null)
			{
				var t:int = getTimer();
				if (t - _clickTime < 400 && _clickPoint != null && _mouseDownPoint.equals(_clickPoint))
				{
					dispatchEvent(new ButtonEvent(ButtonEvent.DOUBLE_CLICK));
					_clickPoint = null;
				}
				else
				{
					dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
					_clickPoint = _mouseDownPoint;
				}
				_clickTime = t;
				_mouseDownPoint = null;
			}
		}
		
		public function mouseOver(target:IControl):void
		{
			if (_image != _states[CtrlState.OVER])
			{
				_image = _states[CtrlState.OVER];
				_image = _image ? _image : _states[CtrlState.UP];
				resize();
			}
			
			dispatchEvent(new ButtonEvent(ButtonEvent.MOUSE_OVER));
		}
		
		public function mouseOut(target:IControl):void
		{
			if (_image != _states[CtrlState.UP])
			{
				_image = _states[CtrlState.UP];
				resize();
			}
			
			dispatchEvent(new ButtonEvent(ButtonEvent.MOUSE_OUT));
		}
		
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				mouseDown(this);
			}
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				mouseUp(this);
			}
		}
		
	}
}