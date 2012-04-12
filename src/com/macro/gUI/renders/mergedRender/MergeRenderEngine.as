package com.macro.gUI.renders.mergedRender
{
	import com.macro.gUI.core.IContainer;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.renders.IRenderEngine;
	import com.macro.gUI.core.InteractionManager;
	import com.macro.gUI.core.PopupManager;
	
	import flash.display.DisplayObjectContainer;


	/**
	 * 界面管理器，构建基于Bitmap的视图结构，并处理控件的添加、删除行为
	 * 分散渲染时，只需要关注Resize事件中的BitmapData重建，其它情况下，直接更新BitmapData会自动实现显示更新；
	 * 合并渲染时，由于每帧强制重绘，就无须关心BitmapData的重建或重绘问题。
	 * 使用Stage3D时，需要分散渲染，否则从内存上传位图数据到显存会带来巨大开销。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class MergeRenderEngine implements IRenderEngine
	{
		
		private var _interactionManager:InteractionManager;

		private var _popupManager:PopupManager;




		public function MergeRenderEngine(container:DisplayObjectContainer)
		{
			_popupManager = new PopupManager();
		}


		/**
		 * 渲染根容器
		 * @param container
		 * @return
		 *
		 */
		public function render(root:IContainer):void
		{
			
		}


		/**
		 * 更新控件的位置
		 * @param control
		 *
		 */
		public function setCoord(control:IControl, x:int, y:int):void
		{
			
		}

		/**
		 * 更新控件的源图，这是由于控件的源图尺寸发生了变化，重新创建了BitmapData
		 * @param control
		 *
		 */
		public function update(control:IControl):void
		{
			
		}

		
		
		
		/**
		 * 更新控件的透明度
		 * @param control
		 *
		 */
		public function updateAlpha(control:IControl):void
		{
		}

		/**
		 * 更新控件的可见性
		 * @param control
		 *
		 */
		public function updateVisible(control:IControl):void
		{
		}



		/**
		 * 更新容器，通常是由于addChild或removeChild
		 * @param container
		 *
		 */
		public function updateContainer(container:IContainer):void
		{
		}


		/**
		 * 添加弹出窗口
		 * @param window
		 * @param modal 是否模态
		 *
		 */
		public function addPopupWindow(window:IContainer,
									   modal:Boolean = true):void
		{
			_popupManager.addPopupWindow(window, modal);
		}

		/**
		 * 添加弹出菜单
		 * @param menu
		 *
		 */
		public function addPopupMenu(menu:IControl):void
		{
			_popupManager.addPopupMenu(menu);
		}

		/**
		 * 移除弹出菜单或窗口
		 * @param popupItem
		 *
		 */
		public function removePopup(popupItem:IControl):void
		{
			_popupManager.removePopup(popupItem);
		}


	}
}
