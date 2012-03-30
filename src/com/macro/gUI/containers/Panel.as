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
		 * @param skin 底层皮肤
		 * @param skinCover 封面皮肤
		 *
		 */
		public function Panel(width:int = 100, height:int = 100, skin:ISkin = null)
		{
			super(width, height);

			_skin = skin;

			init();

			paint();
		}


		public function get skin():ISkin
		{
			return _skin
		}

		public function set skin(value:ISkin):void
		{
			_skin = value;
			paint();
		}


		/**
		 * 初始化控件属性，子类可以在此方法中覆盖父类定义
		 *
		 */
		protected function init():void
		{
			_skin = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.PANEL_BG);

			_margin = new Rectangle();
			_margin.left = _skin.gridLeft;
			_margin.top = _skin.gridTop;
			_margin.right = _skin.paddingRight;
			_margin.bottom = _skin.paddingBottom;
		}
	}
}
