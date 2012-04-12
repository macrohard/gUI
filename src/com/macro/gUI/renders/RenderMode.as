package com.macro.gUI.renders
{
	public class RenderMode
	{
		/**
		 * 合并渲染，所有控件渲染到一张大位图上
		 */
		public static const RENDER_MODE_MERGE:int = 0;
		
		/**
		 * 分层渲染，每个控件单独渲染到一个位图中
		 */
		public static const RENDER_MODE_LAYER:int = 1;
		
		/**
		 * 硬件渲染
		 */
		public static const RENDER_MODE_STAGE3D:int = 2;
	}
}