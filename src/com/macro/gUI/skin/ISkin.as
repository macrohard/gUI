package com.macro.gUI.skin
{
	import flash.display.BitmapData;


	/**
	 * 皮肤。
	 * @author Macro776@gmail.com
	 *
	 */
	public interface ISkin
	{
		/**
		 * 皮肤位图
		 * @return
		 *
		 */
		function get bitmapData():BitmapData;
		
		
		/**
		 * 皮肤对齐方式
		 * @return 
		 * 
		 */
		function get align():int;

		/**
		 * 九切片中心区域左上角横坐标，即左边距
		 * @return
		 *
		 */
		function get gridLeft():int;

		/**
		 * 九切片中心区域左上角纵坐标，即上边距
		 * @return
		 *
		 */
		function get gridTop():int;

		/**
		 * 九切片中心区域右下角横坐标
		 * @return
		 *
		 */
		function get gridRight():int;

		/**
		 * 九切片中心区域右下角纵坐标
		 * @return
		 *
		 */
		function get gridBottom():int;

		/**
		 * 九切片中心区域右边距
		 * @return
		 *
		 */
		function get paddingRight():int;

		/**
		 * 九切片中心区域下边距
		 * @return
		 *
		 */
		function get paddingBottom():int;

		/**
		 * 最小宽度
		 * @return
		 *
		 */
		function get minWidth():int;

		/**
		 * 最小高度
		 * @return
		 *
		 */
		function get minHeight():int;
	}
}
