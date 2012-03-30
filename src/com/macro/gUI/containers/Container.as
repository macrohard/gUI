package com.macro.gUI.containers
{
	import com.macro.gUI.base.AbstractContainer;

	import flash.geom.Rectangle;


	/**
	 * 空容器，无皮肤、背景定义
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Container extends AbstractContainer
	{

		public function Container(width:int = 100, height:int = 100)
		{
			super(width, height);
			_margin = new Rectangle();
		}

		/**
		 * 空容器无皮肤、背景
		 * @param rebuild
		 *
		 */
		protected override function paint(rebuild:Boolean = false):void
		{
		}


	}
}
