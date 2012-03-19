package com.macro.gUI.controls.composite
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IKeyboard;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.controls.ToggleButton;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	/**
	 * 复选框控件，目前定义支持普通，禁用，选择，选择后禁用等四态皮肤
	 * @author Macro776@gmail.com
	 *
	 */
	public class CheckBox extends AbstractComposite implements IButton, IKeyboard
	{
		/**
		 * 文本标签与图标之间的间距
		 */
		private static const gap:int = 5;



		private var _autoSize:Boolean;

		private var _icon:ToggleButton;

		private var _label:Label;



		/**
		 * 复选框控件，目前定义支持普通，禁用，选择，选择后禁用等四态皮肤
		 * @param text 作为文本的字符串
		 * @param style 文本样式
		 * @param skin 复选框图标皮肤
		 * @param align 布局对齐方式，默认左上角对齐
		 *
		 */
		public function CheckBox(text:String = null, style:TextStyle = null, skin:ISkin = null, align:int = 0x11)
		{
			//默认大小
			super(100, 20, align);

			_autoSize = true;

			_label = new Label(text, style);
			_icon = new ToggleButton(null, null, 0x22,
									 skin ? skin : GameUI.skinManager.getSkin(SkinDef.CHECKBOX_NORMAL));
			_icon.overSkin = _icon.downSkin = _icon.normalSkin;
			_icon.disableSkin = GameUI.skinManager.getSkin(SkinDef.CHECKBOX_DISABLE);
			_icon.selectedSkin = GameUI.skinManager.getSkin(SkinDef.CHECKBOX_SELECTED);
			_icon.selectedDownSkin = _icon.selectedOverSkin = _icon.selectedSkin;
			_icon.selectedDisableSkin = GameUI.skinManager.getSkin(SkinDef.CHECKBOX_SELECTED_DISABLE);

			_children.push(_icon);
			_children.push(_label);

			resize();
		}



		/**
		 * 自动设置尺寸
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
					resize();
				}
			}
		}


		/**
		 * 是否选中
		 * @return
		 *
		 */
		public function get selected():Boolean
		{
			return _icon.selected;
		}

		public function set selected(value:Boolean):void
		{
			_icon.selected = value;
		}



		/**
		 * 标签文本
		 * @return
		 *
		 */
		public function get text():String
		{
			return _label.text;
		}

		public function set text(value:String):void
		{
			if (value && value.length > 0)
			{
				_label.text = value;
				if (_autoSize)
				{
					resize();
				}
				else
				{
					layout();
				}
			}
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				width = _icon.width + gap + _label.width;
				height = _icon.height > _label.height ? _icon.height : _label.height;
			}

			super.resize(width, height);
		}

		public override function setDefaultSize():void
		{
			resize(_icon.width + gap + _label.width, _icon.height > _label.height ? _icon.height : _label.height);
		}

		protected override function layout():void
		{
			var w:int = _icon.width + gap + _label.width;

			var ox:int;
			if ((_align & LayoutAlign.CENTER) == LayoutAlign.CENTER)
			{
				ox = (_rect.width - w) >> 1;
			}
			else if ((_align & LayoutAlign.RIGHT) == LayoutAlign.RIGHT)
			{
				ox = _rect.width - w;
			}

			_icon.x = ox;
			_label.x = ox + _icon.width + gap;


			if ((_align & LayoutAlign.TOP) == LayoutAlign.TOP)
			{
				_icon.y = 0;
				_label.y = 0;
			}
			else if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				_icon.y = (_rect.height - _icon.height) >> 1;
				_label.y = (_rect.height - _label.height) >> 1;
			}
			else
			{
				_icon.y = _rect.height - _icon.height;
				_label.y = _rect.height - _label.height;
			}
		}



		//==============================================================
		// 样式相关


		/**
		 * 标签文本样式
		 * @return
		 *
		 */
		public function get labelStyle():TextStyle
		{
			return _label.normalStyle;
		}

		public function set labelStyle(value:TextStyle):void
		{
			if (value)
			{
				_label.normalStyle = value;
				if (_autoSize)
				{
					resize();
				}
				else
				{
					layout();
				}
			}
		}

		/**
		 * 常态皮肤
		 * @return
		 *
		 */
		public function get normalSkin():ISkin
		{
			return _icon.normalSkin;
		}

		public function set normalSkin(value:ISkin):void
		{
			_icon.overSkin = _icon.downSkin = _icon.normalSkin = value;
			layout();
		}

		/**
		 * 禁用态皮肤
		 * @return
		 *
		 */
		public function get disableSkin():ISkin
		{
			return _icon.disableSkin;
		}

		public function set disableSkin(value:ISkin):void
		{
			_icon.disableSkin = value;
			layout();
		}

		/**
		 * 选中态皮肤
		 * @return
		 *
		 */
		public function get selectedSkin():ISkin
		{
			return _icon.selectedSkin;
		}

		public function set selectedSkin(value:ISkin):void
		{
			_icon.selectedDownSkin = _icon.selectedOverSkin = _icon.selectedSkin = value;
			layout();
		}

		/**
		 * 选中禁用态皮肤
		 * @return
		 *
		 */
		public function get selectedDisableSkin():ISkin
		{
			return _icon.selectedDisableSkin;
		}

		public function set selectedDisableSkin(value:ISkin):void
		{
			_icon.selectedDisableSkin = value;
			layout();
		}




		//==============================================================
		// 接口实现

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
			return _icon.enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_icon.enabled = value;
		}

		public function get focusable():Boolean
		{
			return true;
		}


		public function hitTest(x:int, y:int):IControl
		{
			if (_label.rect.contains(x, y) || _icon.rect.contains(x, y))
			{
				return _icon;
			}

			return null;
		}

		public function mouseDown():void
		{
		}

		public function mouseUp():void
		{
			_icon.mouseUp();
		}

		public function mouseOver():void
		{
		}

		public function mouseOut():void
		{
		}

		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				this.selected = !this.selected;
			}
		}

		public function keyUp(e:KeyboardEvent):void
		{
		}

	}
}
