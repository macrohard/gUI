package com.macro.gUI.containers
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.base.AbstractContainer;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;

	import flash.geom.Rectangle;


	/**
	 * 面板容器
	 * @author Macro776@gmail.com
	 *
	 */
	public class Panel extends AbstractContainer
	{
		/**
		 * 面板容器
		 * @param width 容器宽度
		 * @param height 容器高度
		 * @param skin 底层皮肤
		 * @param skinCover 封面皮肤
		 *
		 */
		public function Panel(width:int = 100, height:int = 100, skin:ISkin = null, skinCover:ISkin = null)
		{
			super(width, height);

			_skin = skin;

			_skinCover = skinCover;

			init();

			paint();
		}


		/**
		 * 初始化控件属性，子类可以在此方法中覆盖父类定义
		 *
		 */
		protected function init():void
		{
			_skin = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.PANEL_BG);
			_skinCover = _skinCover ? _skinCover : GameUI.skinManager.getSkin(SkinDef.PANEL_COVER);

			_marginRect = new Rectangle();
			_marginRect.left = _skin.gridLeft;
			_marginRect.top = _skin.gridTop;
			_marginRect.right = _skin.marginRight;
			_marginRect.bottom = _skin.marginBottom;
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

		public function get skinCover():ISkin
		{
			return _skinCover;
		}

		public function set skinCover(value:ISkin):void
		{
			_skinCover = value;
			paint();
		}
	}
}
