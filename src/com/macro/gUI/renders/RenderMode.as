package com.macro.gUI.renders
{
	public class RenderMode
	{
		/**
		 * 合并渲染，所有控件渲染到一张大BitmapData上，适用于大量运动对象的场合，如整个背景地图的卷轴
		 */
		public static const RENDER_MODE_MERGE:int = 0;
		
		/**
		 * 分层渲染，每个控件单独渲染到一个BitmapData中，通过Bitmap来封装，运动对象较少时，拥有更好的性能
		 */
		public static const RENDER_MODE_LAYER:int = 1;
		
		/**
		 * 硬件渲染
		 */
		public static const RENDER_MODE_STAGE3D:int = 2;
	}
}