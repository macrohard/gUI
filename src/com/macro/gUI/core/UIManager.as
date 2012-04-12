package com.macro.gUI.core
{
	import com.macro.gUI.renders.IRenderEngine;
	import com.macro.gUI.renders.RenderMode;
	import com.macro.gUI.renders.layeredRender.LayeredRenderEngine;
	import com.macro.gUI.renders.mergedRender.MergeRenderEngine;
	import com.macro.gUI.skin.SkinManager;
	
	import flash.display.DisplayObjectContainer;


	public class UIManager
	{

		private var _render:IRenderEngine;

		private var _interactionManager:InteractionManager;

		private var _popupManager:PopupManager;

		private var _focusManager:FocusManager;


		public function UIManager(renderMode:int,
								  container:DisplayObjectContainer)
		{
			if (renderMode == RenderMode.RENDER_MODE_MERGE)
			{
				_render = new MergeRenderEngine(container);
			}
			else if (renderMode == RenderMode.RENDER_MODE_LAYER)
			{
				_render = new LayeredRenderEngine(container);
			}
			else
			{
				throw new Error("Unsupport Render Mode!");
			}
			_interactionManager = new InteractionManager(container);
			_skinManager = new SkinManager();

			_popupManager = new PopupManager();
			_focusManager = new FocusManager();
			
			AbstractControl.init(_render, _skinManager);
		}


		private var _skinManager:SkinManager;

		/**
		 * 皮肤管理器
		 * @return
		 *
		 */
		public function get skinManager():SkinManager
		{
			return _skinManager;
		}

		public function set skinManager(value:SkinManager):void
		{
			_skinManager = value;
		}

	}
}
