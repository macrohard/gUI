package com.macro.gUI.containers
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.base.AbstractContainer;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.geom.Rectangle;


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
		public function Panel(width:int = 100, height:int = 100, skin:ISkin = null)
		{
			super(width, height);

			this.skin = skin ? skin : GameUI.skinManager.getSkin(SkinDef.PANEL_BG);

			resize();
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
				
				_margin.left = _skin.gridLeft;
				_margin.top = _skin.gridTop;
				_margin.right = _skin.paddingRight;
				_margin.bottom = _skin.paddingBottom;
				
				resize();
			}
		}
		
	}
}
