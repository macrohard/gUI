package com.macro.gUI.controls
{
	import com.macro.gUI.assist.ButtonGroup;
	import com.macro.gUI.assist.CtrlState;
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.ISelect;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.gUI.skin.StyleDef;
	
	import flash.utils.Dictionary;


	/**
	 * 切换按钮控件。默认自动设置尺寸
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ToggleButton extends Button implements ISelect
	{
		
		/**
		 * 按钮群组
		 */
		private static var group:ButtonGroup = new ButtonGroup();
		
		
		/**
		 * 切换按钮控件
		 * @param text 作为文本的字符串
		 * @param align 文本对齐方式，默认居中对齐
		 *
		 */
		public function ToggleButton(text:String = null, align:int = 0x22)
		{
			if (_styles == null)
			{
				_styles = new Dictionary();
				_styles[CtrlState.UP] = skinMgr.getStyle(StyleDef.BUTTON);
				_styles[CtrlState.OVER] = skinMgr.getStyle(StyleDef.BUTTON_OVER);
				_styles[CtrlState.DOWN] = skinMgr.getStyle(StyleDef.BUTTON_DOWN);
				_styles[CtrlState.DISABLE] = skinMgr.getStyle(StyleDef.BUTTON_DISABLE);
				_styles[CtrlState.SELECTED] = skinMgr.getStyle(StyleDef.TOGGLEBUTTON_SELECTED);
				_styles[CtrlState.SELECTED_OVER] = skinMgr.getStyle(StyleDef.TOGGLEBUTTON_SELECTED_OVER);
				_styles[CtrlState.SELECTED_DOWN] = skinMgr.getStyle(StyleDef.TOGGLEBUTTON_SELECTED_DOWN);
				_styles[CtrlState.SELECTED_DISABLE] = skinMgr.getStyle(StyleDef.TOGGLEBUTTON_SELECTED_DISABLE);
			}

			if (_skins == null)
			{
				_skins = new Dictionary();
				_skins[CtrlState.UP] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON);
				if (_skins[CtrlState.UP] == null)
				{
					_skins[CtrlState.UP] = skinMgr.getSkin(SkinDef.BUTTON);
				}
				_skins[CtrlState.OVER] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_OVER);
				if (_skins[CtrlState.OVER] == null)
				{
					_skins[CtrlState.OVER] = skinMgr.getSkin(SkinDef.BUTTON_OVER);
				}
				_skins[CtrlState.DOWN] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_DOWN);
				if (_skins[CtrlState.DOWN] == null)
				{
					_skins[CtrlState.DOWN] = skinMgr.getSkin(SkinDef.BUTTON_DOWN);
				}
				_skins[CtrlState.DISABLE] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_DISABLE);
				if (_skins[CtrlState.DISABLE] == null)
				{
					_skins[CtrlState.DISABLE] = skinMgr.getSkin(SkinDef.BUTTON_DISABLE);
				}
				_skins[CtrlState.SELECTED] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_SELECTED);
				_skins[CtrlState.SELECTED_OVER] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_SELECTED_OVER);
				_skins[CtrlState.SELECTED_DOWN] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_SELECTED_DOWN);
				_skins[CtrlState.SELECTED_DISABLE] = skinMgr.getSkin(SkinDef.TOGGLEBUTTON_SELECTED_DISABLE);
			}

			_skin = _skin ? _skin : _skins[CtrlState.UP];
			_style = _style ? _style : _styles[CtrlState.UP];

			super(text, align);
		}


		protected var _selected:Boolean;

		/**
		 * 选中状态
		 * @return
		 *
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				_selected = value;
				if (value)
				{
					group.unselect(this);
				}
				mouseOut(this);
			}
		}
		
		
		/**
		 * 按钮分组标识<br>
		 * 注意，同一类型的控件使用同一个群组管理器，因此，在同一类型的控件中群组标识不要重复
		 * @return
		 *
		 */
		public function get groupId():String
		{
			return group.getGroupId(this);
		}
		
		public function set groupId(value:String):void
		{
			if (value == null)
			{
				throw new Error("Invalid value!");
			}
			group.setGroupId(this, value);
		}


		override public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				if (_enabled)
				{
					if (_selected)
					{
						_skin = _skins[CtrlState.SELECTED];
						_style = _styles[CtrlState.SELECTED];
					}
					else
					{
						_skin = _skins[CtrlState.UP];
						_style = _styles[CtrlState.UP];
					}
				}
				else
				{
					if (_selected)
					{
						_skin = _skins[CtrlState.SELECTED_DISABLE];
						_skin = _skin ? _skin : _skins[CtrlState.SELECTED];
						_style = _styles[CtrlState.SELECTED_DISABLE];
					}
					else
					{
						_skin = _skins[CtrlState.DISABLE];
						_skin = _skin ? _skin : _skins[CtrlState.UP];
						_style = _styles[CtrlState.DISABLE];
					}
				}
				resize();
			}
		}



		public function get selectedStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED];
		}

		public function set selectedStyle(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.SELECTED])
			{
				_style = value;
				resize();
			}

			_styles[CtrlState.SELECTED] = value;
		}

		public function get selectedOverStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED_OVER];
		}

		public function set selectedOverStyle(value:TextStyle):void
		{
			_styles[CtrlState.SELECTED_OVER] = value;
		}

		public function get selectedDownStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED_DOWN];
		}

		public function set selectedDownStyle(value:TextStyle):void
		{
			_styles[CtrlState.SELECTED_DOWN] = value;
		}

		public function get selectedDisableStyle():TextStyle
		{
			return _styles[CtrlState.SELECTED_DISABLE];
		}

		public function set selectedDisableStyle(value:TextStyle):void
		{
			if (_style == _styles[CtrlState.SELECTED_DISABLE])
			{
				_style = value;
				resize();
			}

			_styles[CtrlState.SELECTED_DISABLE] = value;
		}



		public function get selectedSkin():ISkin
		{
			return _skins[CtrlState.SELECTED];
		}

		public function set selectedSkin(value:ISkin):void
		{
			if (_skins[CtrlState.SELECTED] == value)
			{
				return;
			}

			if (_skin == _skins[CtrlState.SELECTED])
			{
				_skin = value;
				resize();
			}

			_skins[CtrlState.SELECTED] = value;
		}

		public function get selectedOverSkin():ISkin
		{
			return _skins[CtrlState.SELECTED_OVER];
		}

		public function set selectedOverSkin(value:ISkin):void
		{
			_skins[CtrlState.SELECTED_OVER] = value;
		}

		public function get selectedDownSkin():ISkin
		{
			return _skins[CtrlState.SELECTED_DOWN];
		}

		public function set selectedDownSkin(value:ISkin):void
		{
			_skins[CtrlState.SELECTED_DOWN] = value;
		}

		public function get selectedDisableSkin():ISkin
		{
			return _skins[CtrlState.SELECTED_DISABLE];
		}

		public function set selectedDisableSkin(value:ISkin):void
		{
			if (_skins[CtrlState.SELECTED_DISABLE] == value)
			{
				return;
			}

			if (_skin == _skins[CtrlState.SELECTED_DISABLE])
			{
				_skin = value;
				resize();
			}

			_skins[CtrlState.SELECTED_DISABLE] = value;
		}



		override public function mouseDown(target:IControl):void
		{
			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED_DOWN] &&
						_style == _styles[CtrlState.SELECTED_DOWN])
				{
					return;
				}

				_skin = _skins[CtrlState.SELECTED_DOWN];
				_skin = _skin ? _skin : _skins[CtrlState.SELECTED];
				_style = _styles[CtrlState.SELECTED_DOWN];
			}
			else
			{
				if (_skin == _skins[CtrlState.DOWN] &&
						_style == _styles[CtrlState.DOWN])
				{
					return;
				}

				_skin = _skins[CtrlState.DOWN];
				_skin = _skin ? _skin : _skins[CtrlState.UP];
				_style = _styles[CtrlState.DOWN];
			}
			resize();
		}
		
		override public function mouseUp(target:IControl):void
		{
			selected = !_selected;
			
			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED_OVER] &&
					_style == _styles[CtrlState.SELECTED_OVER])
				{
					return;
				}
				
				_skin = _skins[CtrlState.SELECTED_OVER];
				_skin = _skin ? _skin : _skins[CtrlState.SELECTED];
				_style = _styles[CtrlState.SELECTED_OVER];
			}
			else
			{
				if (_skin == _skins[CtrlState.OVER] &&
					_style == _styles[CtrlState.OVER])
				{
					return;
				}
				
				_skin = _skins[CtrlState.OVER];
				_skin = _skin ? _skin : _skins[CtrlState.UP];
				_style = _styles[CtrlState.OVER];
			}
			resize();
		}

		override public function mouseOut(target:IControl):void
		{
			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED] &&
						_style == _styles[CtrlState.SELECTED])
				{
					return;
				}

				_skin = _skins[CtrlState.SELECTED];
				_style = _styles[CtrlState.SELECTED];
			}
			else
			{
				if (_skin == _skins[CtrlState.UP] &&
						_style == _styles[CtrlState.UP])
				{
					return;
				}

				_skin = _skins[CtrlState.UP];
				_style = _styles[CtrlState.UP];
			}
			resize();
		}

		override public function mouseOver(target:IControl):void
		{
			if (_selected)
			{
				if (_skin == _skins[CtrlState.SELECTED_OVER] &&
						_style == _styles[CtrlState.SELECTED_OVER])
				{
					return;
				}

				_skin = _skins[CtrlState.SELECTED_OVER];
				_skin = _skin ? _skin : _skins[CtrlState.SELECTED];
				_style = _styles[CtrlState.SELECTED_OVER];
			}
			else
			{
				if (_skin == _skins[CtrlState.OVER] &&
						_style == _styles[CtrlState.OVER])
				{
					return;
				}

				_skin = _skins[CtrlState.OVER];
				_skin = _skin ? _skin : _skins[CtrlState.UP];
				_style = _styles[CtrlState.OVER];
			}
			resize();
		}
	}
}
