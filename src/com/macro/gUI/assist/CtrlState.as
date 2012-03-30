package com.macro.gUI.assist
{


	/**
	 * 控件状态
	 * @author Macro <macro776@gmail.com>
	 * 
	 */
	public class CtrlState
	{
		/**
		 * 常态
		 */
		public static const NORMAL:int = 0x01;

		/**
		 * 按下态
		 */
		public static const DOWN:int = 0x02;

		/**
		 * 悬停态
		 */
		public static const OVER:int = 0x03;

		/**
		 * 禁用态
		 */
		public static const DISABLE:int = 0x04;

		
		
		// 以下常用于切换按钮、复选框、单选按钮等
		
		/**
		 * 选中态
		 */
		public static const SELECTED:int = 0x11;

		/**
		 * 选中按下态
		 */
		public static const SELECTED_DOWN:int = 0x12;

		/**
		 * 选中悬停态
		 */
		public static const SELECTED_OVER:int = 0x13;

		/**
		 * 选中禁用态
		 */
		public static const SELECTED_DISABLE:int = 0x14;

	}
}
