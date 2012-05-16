package com.macro.gUI.containers
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.core.AbstractContainer;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;


	/**
	 * 面板容器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Panel extends AbstractContainer
	{
		/**
		 * 面板容器，可视范围由底层皮肤的九切片定义来确定
		 * @param width 容器宽度
		 * @param height 容器高度
		 *
		 */
		public function Panel(width:int = 100, height:int = 100)
		{
			super(width, height);

			_skin = _skin ? _skin : skinMgr.getSkin(SkinDef.PANEL_BG);
			_margin = new Margin(_skin.gridLeft, _skin.gridTop, _skin.paddingRight, _skin.paddingBottom);
			resize();
		}


		public function get bgSkin():ISkin
		{
			return _skin
		}

		public function set bgSkin(value:ISkin):void
		{
			if (_skin != value && value != null)
			{
				_skin = value;
				_margin = new Margin(_skin.gridLeft, _skin.gridTop, _skin.paddingRight, _skin.paddingBottom);
				resize();
			}
		}

	}
}
