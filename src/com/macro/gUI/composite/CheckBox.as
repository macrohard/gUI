package com.macro.gUI.composite
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.base.AbstractComposite;
	import com.macro.gUI.base.IControl;
	import com.macro.gUI.base.feature.IButton;
	import com.macro.gUI.base.feature.IKeyboard;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Label;
	import com.macro.gUI.controls.ToggleButton;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;


	/**
	 * 复选框控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class CheckBox extends AbstractComposite implements IButton, IKeyboard
	{

		/**
		 * 文本标签与图标之间的间距
		 */
		private static const gap:int = 5;


		private var _icon:ToggleButton;

		private var _label:Label;



		/**
		 * 复选框控件，目前定义支持普通，禁用，选择，选择后禁用等四态皮肤<br/>
		 * 默认自动设置尺寸
		 * @param text 作为文本的字符串
		 * @param align 布局对齐方式，默认左上角对齐
		 *
		 */
		public function CheckBox(text:String = null, align:int = 0x11)
		{
			//稍后resize时会重设为标准大小
			super(1, 1, align);

			_autoSize = true;

			_label = new Label(text);
			_icon = new ToggleButton(null, 0x22);
			_icon.overSkin = _icon.downSkin = _icon.skin = skinManager.getSkin(SkinDef.CHECKBOX_NORMAL);
			_icon.disableSkin = skinManager.getSkin(SkinDef.CHECKBOX_DISABLE);
			_icon.selectedDownSkin = _icon.selectedOverSkin = _icon.selectedSkin = skinManager.getSkin(SkinDef.CHECKBOX_SELECTED);
			_icon.selectedDisableSkin = skinManager.getSkin(SkinDef.CHECKBOX_SELECTED_DISABLE);

			_container = new Container();
			_container.addChild(_icon);
			_container.addChild(_label);

			resize();
		}


		private var _autoSize:Boolean;

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


		public override function get enabled():Boolean
		{
			return _icon.enabled;
		}

		public override function set enabled(value:Boolean):void
		{
			_icon.enabled = value;
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



		/**
		 * 标签文本样式
		 * @param style
		 *
		 */
		public function setLabelStyle(style:TextStyle):void
		{
			if (style)
			{
				_label.style = style;
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
		 * 设置按钮皮肤
		 * @param normalSkin 常态皮肤
		 * @param disableSkin 禁用态皮肤
		 * @param selectedSkin 选中态皮肤
		 * @param selectedDisableSkin 选中禁用态皮肤
		 *
		 */
		public function setSkins(normalSkin:ISkin, disableSkin:ISkin, selectedSkin:ISkin,
								 selectedDisableSkin:ISkin):void
		{
			_icon.overSkin = _icon.downSkin = _icon.skin = normalSkin;
			_icon.disableSkin = disableSkin;
			_icon.selectedDownSkin = _icon.selectedOverSkin = _icon.selectedSkin = selectedSkin;
			_icon.selectedDisableSkin = selectedDisableSkin;

			layout();
		}



		public override function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(x, y);

			if (_label.rect.containsPoint(p) || _icon.rect.containsPoint(p))
			{
				return _icon;
			}

			return null;
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



		public function mouseDown(target:IControl):void
		{
		}

		public function mouseUp(target:IControl):void
		{
			this.selected = !this.selected;
		}

		public function mouseOver(target:IControl):void
		{
		}

		public function mouseOut(target:IControl):void
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
