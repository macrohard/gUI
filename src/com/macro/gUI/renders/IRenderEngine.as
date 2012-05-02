package com.macro.gUI.renders
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;


	/**
	 * UI渲染接口
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public interface IRenderEngine
	{

		/**
		 * 更新控件，包括坐标、遮罩、可见性及透明度等等
		 * @param control
		 *
		 */
		function updateCoord(control:IControl):void;

		/**
		 * 更新控件绘制
		 * @param control
		 * @param isRebuild 是否重建了BitmapData，通常是因为控件尺寸的变更
		 *
		 */
		function updatePaint(control:IControl, isRebuild:Boolean):void;
		
		/**
		 * 更新可见性
		 * @param control
		 * 
		 */
		function updateVisible(control:IControl):void;
		
		
		/**
		 * 添加子控件
		 * @param container
		 * @param child
		 * 
		 */
		function addChild(container:IContainer, child:IControl):void;
		
		/**
		 * 移除子控件
		 * @param container
		 * @param child
		 * 
		 */
		function removeChild(container:IContainer, child:IControl):void;
		
		/**
		 * 移除指定范围的子控件
		 * @param container
		 * @param childList
		 * 
		 */
		function removeChildren(container:IContainer, childList:Vector.<IControl>):void;
		
		/**
		 * 更新子控件的层级
		 * @param container
		 * @param child
		 * @param index
		 * 
		 */
		function updateChildIndex(container:IContainer, child:IControl):void;
		
	}
}
