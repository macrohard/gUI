package com.macro.gUI.composite
{
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
		 * @param align 布局对齐方式，默认左上角对齐
		 *
		 */
		public function ComboBox(text:String = null, align:int = 0x11)
		{
			super(1, 1, align);

			_autoSize = true;

			_textInput = new TextInput(text);
			_textInput.skin = skinManager.getSkin(SkinDef.COMBO_INPUT_NORMAL);
			_textInput.disableSkin = skinManager.getSkin(SkinDef.COMBO_INPUT_DISABLE);
			_textInput.style = skinManager.getStyle(StyleDef.COMBO_INPUT);
			_textInput.disableStyle = skinManager.getStyle(StyleDef.COMBO_INPUT_DISABLE);

			_downBtn = new Button();
			_downBtn.skin = skinManager.getSkin(SkinDef.COMBO_BUTTON_NORMAL);
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
		 * 是否可编辑
		 * @return
		 *
		 */
		public function get editable():Boolean
		{
			return _textInput.editable;
		}

		public function set editable(value:Boolean):void
		{
			_textInput.editable = value;
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

		
		
		public function setInputStyle(normalStyle:TextStyle, disableStyle:TextStyle):void
		{
			
		}
		
		
		
		public override function hitTest(x:int, y:int):IControl
		{
			return null;
		}
		
		
		
		public override function resize(width:int=0, height:int=0):void
		{
			
		}
		
		
		
		public override function setDefaultSize():void
		{
			
		}
		
		
		
		protected override function layout():void
		{
			
		}
		



		public function mouseDown(target:IControl):void
		{
			
		}

		public function mouseUp(target:IControl):void
		{
			
		}

		public function mouseOver(target:IControl):void
		{
			
		}

		public function mouseOut(target:IControl):void
		{
			
		}



		public function beginEdit():TextField
		{
			return _textInput.beginEdit();
		}

		public function endEdit(value:String):void
		{
			_textInput.endEdit(value);
		}
	}
}
