package com.macro.gUI.composite
{
	import com.macro.gUI.assist.LayoutAlign;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.TextInput;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	import flash.geom.Point;
	import flash.text.TextField;


	/**
	 * 组合框控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ComboBox extends AbstractComposite implements IButton, IEdit
	{

		protected var _list:List;

		protected var _textInput:TextInput;

		protected var _downBtn:Button;



		/**
		 * 组合框控件
		 * @param text 默认文本
		 * @param width 初始宽度
		 * @param align 布局对齐方式，默认左上角对齐
		 *
		 */
		public function ComboBox(text:String = null, width:int = 80, align:int = 0x11)
		{
			//稍后resize时会重设为标准大小
			super(width, 1, align);

			_autoSize = true;

			_textInput = new TextInput(text);
			_textInput.editable = false;
			_textInput.skin = skinManager.getSkin(SkinDef.COMBO_INPUT_BG);
			_textInput.disableSkin = skinManager.getSkin(SkinDef.COMBO_INPUT_BG_DISABLE);
			_textInput.style = skinManager.getStyle(StyleDef.COMBO_INPUT);
			_textInput.disableStyle = skinManager.getStyle(StyleDef.COMBO_INPUT_DISABLE);

			_downBtn = new Button();
			_downBtn.skin = skinManager.getSkin(SkinDef.COMBO_BUTTON);
			_downBtn.overSkin = skinManager.getSkin(SkinDef.COMBO_BUTTON_OVER);
			_downBtn.downSkin = skinManager.getSkin(SkinDef.COMBO_BUTTON_DOWN);
			_downBtn.disableSkin = skinManager.getSkin(SkinDef.COMBO_BUTTON_DISABLE);

			_container = new Container();
			_container.addChild(_textInput);
			_container.addChild(_downBtn);

			// 使用列表框控件作为弹出菜单
			_list = new List();

			var skin:ISkin;
			skin = skinManager.getSkin(SkinDef.COMBO_LIST_BG);
			if (skin != null)
			{
				_list.setBgSkin(skin);
			}

			var itemSkin:ISkin = skinManager.getSkin(SkinDef.COMBO_LIST_ITEM_BG);
			if (itemSkin == null)
			{
				itemSkin = skinManager.getSkin(SkinDef.LIST_ITEM_BG);
			}
			var itemOverSkin:ISkin = skinManager.getSkin(SkinDef.COMBO_LIST_ITEM_OVER_BG);
			if (itemOverSkin == null)
			{
				itemOverSkin = skinManager.getSkin(SkinDef.LIST_ITEM_OVER_BG);
			}
			var itemSelectedSkin:ISkin = skinManager.getSkin(SkinDef.COMBO_LIST_ITEM_SELECTED_BG);
			if (itemSelectedSkin == null)
			{
				itemSelectedSkin = skinManager.getSkin(SkinDef.LIST_ITEM_SELECTED_BG);
			}
			_list.setItemSkin(itemSkin, itemOverSkin, itemSelectedSkin);

			var itemStyle:TextStyle = skinManager.getStyle(StyleDef.COMBO_LIST_ITEM);
			if (itemStyle == null)
			{
				itemStyle = skinManager.getStyle(StyleDef.LIST_ITEM);
			}
			var itemSelectedStyle:TextStyle = skinManager.getStyle(StyleDef.COMBO_LIST_ITEM_SELECTED);
			if (itemSelectedStyle == null)
			{
				itemSelectedStyle = skinManager.getStyle(StyleDef.LIST_ITEM_SELECTED);
			}
			_list.setItemStyle(itemStyle, itemSelectedStyle);

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
		 * 一次性设置所有列表项
		 * @param value
		 *
		 */
		public function set items(value:Vector.<String>):void
		{
			_list.items = value;
			if (!_textInput.editable)
			{
				if (value != null && value.length > 0)
				{
					_textInput.text = value[0];
				}
				else
				{
					_textInput.text = null;
				}
			}
		}


		/**
		 * 选择项索引
		 * @return
		 *
		 */
		public function get selectedIndex():int
		{
			if (_list.items != null && _list.items.length > 0)
			{
				return _list.items.indexOf(_textInput.text);
			}
			return -1;
		}

		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value;
			_textInput.text = _list.selectedText;
		}


		/**
		 * 输入框的文本内容
		 * @return
		 *
		 */
		public function get text():String
		{
			return _textInput.text;
		}

		public function set text(value:String):void
		{
			_textInput.text = value;
		}



		public function get editable():Boolean
		{
			return _textInput.editable;
		}

		public function set editable(value:Boolean):void
		{
			_textInput.editable = value;
			if (!value && selectedIndex == -1)
			{
				selectedIndex = 0;
			}
		}


		public override function get enabled():Boolean
		{
			return _textInput.enabled;
		}

		public override function set enabled(value:Boolean):void
		{
			_textInput.enabled = value;
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



		/**
		 * 设置输入框样式
		 * @param normalStyle 常态样式
		 * @param disableStyle 禁用态样式
		 *
		 */
		public function setTextInputStyle(normalStyle:TextStyle, disableStyle:TextStyle):void
		{
			_textInput.style = normalStyle;
			_textInput.disableStyle = disableStyle;
			if (_autoSize)
			{
				resize(_rect.width);
			}
			else
			{
				layout();
			}
		}


		/**
		 * 设置输入框皮肤
		 * @param normalSkin 常态皮肤
		 * @param disableSkin 禁用态皮肤
		 *
		 */
		public function setTextInputSkin(normalSkin:ISkin, disableSkin:ISkin):void
		{
			_textInput.skin = normalSkin;
			_textInput.disableSkin = disableSkin;
			if (_autoSize)
			{
				resize(_rect.width);
			}
			else
			{
				layout();
			}
		}


		/**
		 * 设置按钮皮肤
		 * @param normalSkin
		 * @param overSkin
		 * @param downSkin
		 * @param disableSkin
		 *
		 */
		public function setButtonSkin(normalSkin:ISkin, overSkin:ISkin, downSkin:ISkin, disableSkin:ISkin):void
		{
			_downBtn.skin = normalSkin;
			_downBtn.overSkin = overSkin;
			_downBtn.downSkin = downSkin;
			_downBtn.disableSkin = disableSkin;
			if (_autoSize)
			{
				resize(_rect.width);
			}
			else
			{
				layout();
			}
		}


		/**
		 * 设置列表框文本样式
		 * @param itemStyle
		 * @param itemSelectedStyle
		 *
		 */
		public function setListStyle(itemStyle:TextStyle, itemSelectedStyle:TextStyle):void
		{
			_list.setItemStyle(itemStyle, itemSelectedStyle);
		}


		/**
		 * 设置列表框皮肤
		 * @param bgSkin
		 * @param itemSkin
		 * @param itemOverSkin
		 * @param itemSelectedSkin
		 *
		 */
		public function setListSkin(bgSkin:ISkin, itemSkin:ISkin, itemOverSkin:ISkin, itemSelectedSkin:ISkin):void
		{
			_list.setBgSkin(bgSkin);
			_list.setItemSkin(itemSkin, itemOverSkin, itemSelectedSkin);
		}



		/**
		 * 添加列表项
		 * @param text
		 * @param index 索引位置，默认值int.MAX_VALUE表示添加到末尾
		 *
		 */
		public function addItem(text:String, index:int = int.MAX_VALUE):void
		{
			_list.addItem(text, index);
		}

		/**
		 * 移除列表项
		 * @param index
		 *
		 */
		public function removeItem(index:int):void
		{
			_list.removeItem(index);
		}



		public override function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(x, y);

			if (_textInput.rect.containsPoint(p))
			{
				return _textInput;
			}

			if (_downBtn.rect.containsPoint(p))
			{
				return _downBtn;
			}

			return null;
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = (_textInput.skin ? _textInput.skin.minWidth : 10) + _downBtn.width;
				width = width < min ? min : width;
				height = _textInput.height > _downBtn.height ? _textInput.height : _downBtn.height;
			}

			super.resize(width, height);
		}



		public override function setDefaultSize():void
		{
			resize((_textInput.skin ? _textInput.skin.minWidth : 10) + _downBtn.width,
				   _textInput.height > _downBtn.height ? _textInput.height : _downBtn.height);
		}



		protected override function layout():void
		{
			if ((_align & LayoutAlign.TOP) == LayoutAlign.TOP)
			{
				_textInput.y = 0;
				_downBtn.y = 0;
			}
			else if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				_textInput.y = _rect.height - _textInput.height >> 1;
				_downBtn.y = _rect.height - _downBtn.height >> 1;
			}
			else
			{
				_textInput.y = _rect.height - _textInput.height;
				_downBtn.y = _rect.height - _downBtn.height;
			}

			_textInput.width = _rect.width - _downBtn.width;
			_downBtn.x = _textInput.width;
		}




		public function mouseDown(target:IControl):void
		{
			if (target == _downBtn)
			{
				_downBtn.mouseDown(target);

				if (_list.parent == null)
				{
					var p:Point = _textInput.localToGlobal();
					_list.x = p.x;
					_list.y = p.y + _textInput.height;
					_list.width = _rect.width;
					popupManager.addPopupMenu(_list, this);
				}
				else
				{
					popupManager.removePopupMenu();
				}
			}
			else if (target == _textInput)
			{
				popupManager.removePopupMenu();
			}
		}

		public function mouseUp(target:IControl):void
		{
			if (target == _downBtn)
			{
				_downBtn.mouseUp(target);
			}
		}

		public function mouseOver(target:IControl):void
		{
			if (target == _downBtn)
			{
				_downBtn.mouseOver(target);
			}
		}

		public function mouseOut(target:IControl):void
		{
			if (target == _downBtn)
			{
				_downBtn.mouseOut(target);
			}
		}



		public function beginEdit():TextField
		{
			return _textInput.beginEdit();
		}

		public function endEdit(value:String):void
		{
			if (_list.items != null && _list.items.length > 0)
			{
				var index:int = _list.items.indexOf(value);
				if (index != -1)
				{
					_list.selectedIndex = index;
				}
			}
			_textInput.endEdit(value);
		}
	}
}
