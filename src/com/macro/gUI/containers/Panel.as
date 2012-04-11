package com.macro.gUI.containers
{
	import com.macro.gUI.assist.Margin;
	import com.macro.gUI.base.AbstractContainer;
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
		public function Panel(width:int = 100, height:int = 100,
							  skin:ISkin = null)
		{
			super(width, height);

			this.skin = skin ? skin : skinManager.getSkin(SkinDef.PANEL_BG);
		}


		public function get skin():ISkin
		{
			return _skin
		}

		public function set skin(value:ISkin):void
		{
			if (_skin != value && value != null)
			{
				_skin = value;

				_margin = new Margin(_skin.gridLeft, _skin.gridTop,
									 _skin.paddingRight, _skin.paddingBottom);

				paint();
			}
		}

	}
}
