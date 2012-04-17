package com.macro.gUI.composite
{
	import com.macro.gUI.containers.Container;
	import com.macro.gUI.controls.Button;
	import com.macro.gUI.controls.TextInput;
	import com.macro.gUI.core.AbstractComposite;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IEdit;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;

	/**
	 * 组合框控件
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ComboBox extends AbstractComposite implements IButton, IEdit
	{

		protected var _editBox:TextInput;

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
			
			_editBox = new TextInput(text);
			_editBox.skin = skinManager.getSkin(SkinDef.COMBO_INPUT_NORMAL);
			_editBox.disableSkin = skinManager.getSkin(SkinDef.COMBO_INPUT_DISABLE);
			_editBox.style = skinManager.getStyle(StyleDef.COMBO_INPUT);
			_editBox.disableStyle = skinManager.getStyle(StyleDef.COMBO_INPUT_DISABLE);

			_downBtn = new Button();
			_downBtn.skin = skinManager.getSkin(SkinDef.COMBO_BUTTON_NORMAL);
			_downBtn.overSkin = skinManager.getSkin(SkinDef.COMBO_BUTTON_OVER);
			_downBtn.downSkin = skinManager.getSkin(SkinDef.COMBO_BUTTON_DOWN);
			_downBtn.disableSkin = skinManager.getSkin(SkinDef.COMBO_BUTTON_DISABLE);
			
			_container = new Container();
			_container.addChild(_editBox);
			_container.addChild(_downBtn);
			
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
			return _editBox.editable;
		}
		
		public function set editable(value:Boolean):void
		{
			_editBox.editable = value;
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



		public function beginEdit():void
		{
		}

		
	}
}
