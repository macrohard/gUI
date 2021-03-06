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
	import com.macro.gUI.events.ComboBoxEvent;
	import com.macro.gUI.events.ListEvent;
	import com.macro.gUI.events.TextInputEvent;
	import com.macro.gUI.events.UIEvent;
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
			_showItems = 5;

			_textInput = new TextInput(text);
			_textInput.editable = false;
			_textInput.bgSkin = skinMgr.getSkin(SkinDef.COMBO_INPUT_BG);
			_textInput.disableSkin = skinMgr.getSkin(SkinDef.COMBO_INPUT_BG_DISABLE);
			_textInput.style = skinMgr.getStyle(StyleDef.COMBO_INPUT);
			_textInput.disableStyle = skinMgr.getStyle(StyleDef.COMBO_INPUT_DISABLE);

			_downBtn = new Button();
			_downBtn.upSkin = skinMgr.getSkin(SkinDef.COMBO_BUTTON);
			_downBtn.overSkin = skinMgr.getSkin(SkinDef.COMBO_BUTTON_OVER);
			_downBtn.downSkin = skinMgr.getSkin(SkinDef.COMBO_BUTTON_DOWN);
			_downBtn.disableSkin = skinMgr.getSkin(SkinDef.COMBO_BUTTON_DISABLE);

			_container = new Container();
			_container.addChild(_textInput);
			_container.addChild(_downBtn);

			// 使用列表框控件作为弹出菜单
			_list = new List();
			_list.addEventListener(ListEvent.SELECT, listSelectHandler);

			var skin:ISkin;
			skin = skinMgr.getSkin(SkinDef.COMBO_LIST_BG);
			if (skin != null)
			{
				_list.bgSkin = skin;
			}

			var itemSkin:ISkin = skinMgr.getSkin(SkinDef.COMBO_LIST_ITEM_BG);
			if (itemSkin == null)
			{
				itemSkin = skinMgr.getSkin(SkinDef.LIST_ITEM_BG);
			}
			var itemOverSkin:ISkin = skinMgr.getSkin(SkinDef.COMBO_LIST_ITEM_OVER_BG);
			if (itemOverSkin == null)
			{
				itemOverSkin = skinMgr.getSkin(SkinDef.LIST_ITEM_OVER_BG);
			}
			var itemSelectedSkin:ISkin = skinMgr.getSkin(SkinDef.COMBO_LIST_ITEM_SELECTED_BG);
			if (itemSelectedSkin == null)
			{
				itemSelectedSkin = skinMgr.getSkin(SkinDef.LIST_ITEM_SELECTED_BG);
			}
			_list.itemUpSkin = itemSkin;
			_list.itemOverSkin = itemOverSkin;
			_list.itemSelectedSkin = itemSelectedSkin;

			var itemStyle:TextStyle = skinMgr.getStyle(StyleDef.COMBO_LIST_ITEM);
			if (itemStyle == null)
			{
				itemStyle = skinMgr.getStyle(StyleDef.LIST_ITEM);
			}
			var itemSelectedStyle:TextStyle = skinMgr.getStyle(StyleDef.COMBO_LIST_ITEM_SELECTED);
			if (itemSelectedStyle == null)
			{
				itemSelectedStyle = skinMgr.getStyle(StyleDef.LIST_ITEM_SELECTED);
			}
			_list.itemUpStyle = itemStyle;
			_list.itemSelectedStyle = itemSelectedStyle;

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
		
		
		private var _showItems:int;
		
		/**
		 * 弹出菜单显示的最大列表项数量
		 * @return 
		 * 
		 */
		public function get maxShowItems():int
		{
			return _showItems;
		}
		
		public function set maxShowItems(value:int):void
		{
			_showItems = value;
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
			
			dispatchEvent(new ComboBoxEvent(ComboBoxEvent.SELECT));
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
		
		
		public function get restrict():String
		{
			return _textInput.restrict;
		}
		
		public function set restrict(value:String):void
		{
			_textInput.restrict = value;
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
			return _textInput.enabled;
		}

		override public function set enabled(value:Boolean):void
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


		
		public function get textInputUpStyle():TextStyle
		{
			return _textInput.style;
		}

		public function set textInputUpStyle(value:TextStyle):void
		{
			_textInput.style = value;
			update();
		}
		
		public function get textInputDisableStyle():TextStyle
		{
			return _textInput.disableStyle;
		}
		
		public function set textInputDisableStyle(value:TextStyle):void
		{
			_textInput.disableStyle = value;
			update();
		}

		
		public function get textInputUpSkin():ISkin
		{
			return _textInput.bgSkin;
		}

		public function set textInputUpSkin(value:ISkin):void
		{
			_textInput.bgSkin = value;
			update();
		}
		
		public function get textInputDisableSkin():ISkin
		{
			return _textInput.disableSkin;
		}
		
		public function set textInputDisableSkin(value:ISkin):void
		{
			_textInput.disableSkin = value;
			update();
		}

		
		public function get buttonUpSkin():ISkin
		{
			return _downBtn.upSkin;
		}

		public function set buttonUpSkin(value:ISkin):void
		{
			_downBtn.upSkin = value;
			update();
		}
		
		public function get buttonOverSkin():ISkin
		{
			return _downBtn.overSkin;
		}
		
		public function set buttonOverSkin(value:ISkin):void
		{
			_downBtn.overSkin = value;
		}
		
		public function get buttonDownSkin():ISkin
		{
			return _downBtn.downSkin;
		}
		
		public function set buttonDownSkin(value:ISkin):void
		{
			_downBtn.downSkin = value;
		}
		
		public function get buttonDisableSkin():ISkin
		{
			return _downBtn.disableSkin;
		}
		
		public function set buttonDisableSkin(value:ISkin):void
		{
			_downBtn.disableSkin = value;
			update();
		}

		
		public function get listBgSkin():ISkin
		{
			return _list.bgSkin;
		}

		public function set listBgSkin(value:ISkin):void
		{
			_list.bgSkin = value;
		}
		
		
		public function get listItemUpSkin():ISkin
		{
			return _list.itemUpSkin;
		}
		
		public function set listItemUpSkin(value:ISkin):void
		{
			_list.itemUpSkin = value;
		}
		
		public function get listItemOverSkin():ISkin
		{
			return _list.itemOverSkin;
		}
		
		public function set listItemOverSkin(value:ISkin):void
		{
			_list.itemOverSkin = value;
		}
		
		public function get listItemSelectedSkin():ISkin
		{
			return _list.itemSelectedSkin;
		}
		
		public function set listItemSelectedSkin(value:ISkin):void
		{
			_list.itemSelectedSkin = value;
		}
		
		
		public function get listItemUpStyle():TextStyle
		{
			return _list.itemUpStyle;
		}
		
		public function set listItemUpStyle(value:TextStyle):void
		{
			_list.itemUpStyle = value;
		}
		
		public function get listItemSelectedStyle():TextStyle
		{
			return _list.itemSelectedStyle;
		}
		
		public function set listItemSelectedStyle(value:TextStyle):void
		{
			_list.itemSelectedStyle = value;
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



		/**
		 * 添加列表项
		 * @param text
		 * @param index 索引位置，默认值int.MAX_VALUE表示添加到末尾
		 *
		 */
		public function addItem(text:String, index:int = int.MAX_VALUE):void
		{
			_list.addItem(text, index);
			
			if (selectedIndex == -1 && _textInput.editable == false)
			{
				selectedIndex = 0;
			}
		}

		/**
		 * 移除列表项
		 * @param index
		 *
		 */
		public function removeItem(index:int):void
		{
			_list.removeItem(index);
			
			if (selectedIndex == -1 && _textInput.editable == false)
			{
				selectedIndex = 0;
			}
		}
		
		
		private function listSelectHandler(e:UIEvent):void
		{
			_textInput.text = _list.selectedText;
			uiMgr.popupManager.removePopupMenu();
			
			dispatchEvent(new ComboBoxEvent(ComboBoxEvent.SELECT));
		}



		override public function hitTest(x:int, y:int):IControl
		{
			var p:Point = globalToLocal(new Point(x, y));

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



		override public function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize)
			{
				var min:int = (_textInput.bgSkin ? _textInput.bgSkin.minWidth : 10) + _downBtn.width;
				width = width < min ? min : width;
				height = _textInput.height > _downBtn.height ? _textInput.height : _downBtn.height;
			}

			super.resize(width, height);
		}



		override public function setDefaultSize():void
		{
			resize((_textInput.bgSkin ? _textInput.bgSkin.minWidth : 10) + _downBtn.width,
				   _textInput.height > _downBtn.height ? _textInput.height : _downBtn.height);
		}



		override protected function layout():void
		{
			if ((_align & LayoutAlign.TOP) == LayoutAlign.TOP)
			{
				_textInput.y = 0;
				_downBtn.y = 0;
			}
			else if ((_align & LayoutAlign.MIDDLE) == LayoutAlign.MIDDLE)
			{
				_textInput.y = _height - _textInput.height >> 1;
				_downBtn.y = _height - _downBtn.height >> 1;
			}
			else
			{
				_textInput.y = _height - _textInput.height;
				_downBtn.y = _height - _downBtn.height;
			}

			_textInput.width = _width - _downBtn.width;
			_downBtn.x = _textInput.width;
		}




		public function mouseDown(target:IControl):void
		{
			if (target == _downBtn)
			{
				_downBtn.mouseDown(target);

				if (_list.holder == null)
				{
					var p:Point = _textInput.localToGlobal();
					_list.x = p.x;
					_list.y = p.y + _textInput.height;
					_list.width = _width;
					_list.setHeightByLines(Math.min(_showItems, _list.items.length));
					if (_list.y + _list.height > uiMgr.stageHeight)
					{
						_list.y = p.y - _list.height;
					}
					uiMgr.popupManager.addPopupMenu(_list, this);
				}
				else
				{
					uiMgr.popupManager.removePopupMenu();
				}
			}
			else if (target == _textInput)
			{
				uiMgr.popupManager.removePopupMenu();
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
			dispatchEvent(new TextInputEvent(TextInputEvent.EDIT_BEGIN));
			return _textInput.beginEdit();
		}

		public function endEdit():void
		{
			_textInput.endEdit();
			var value:String = _textInput.text;
			if (_list.items != null && _list.items.length > 0)
			{
				var index:int = _list.items.indexOf(value);
				if (index != -1)
				{
					_list.selectedIndex = index;
				}
			}
			dispatchEvent(new TextInputEvent(TextInputEvent.EDIT_FINISH));
		}
	}
}
