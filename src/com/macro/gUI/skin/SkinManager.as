package com.macro.gUI.skin
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.impl.BitmapSkin;
	import com.macro.gUI.skin.impl.SpriteSkin;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;


	/**
	 * 皮肤管理器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class SkinManager
	{

		/**
		 * 皮肤样式列表
		 */
		private var _skin:Dictionary;

		/**
		 * 文本样式列表
		 */
		private var _style:Dictionary;



		/**
		 * 皮肤管理器
		 *
		 */
		public function SkinManager()
		{
			_skin = new Dictionary();
			_style = new Dictionary();
		}


		/**
		 * 注册皮肤
		 * @param id 皮肤定义关键字，参见SkinDef
		 * @param value 皮肤图元，目前支持BitmapData, Sprite等格式
		 * @param grid 九切片中心区域矩形。注意，缩放将使用此矩形的left, top, right, bottom值，而不是width, height。
		 * 当right大于left时，皮肤可以水平缩放，当bottom大于top时皮肤可以垂直缩放
		 * @param align 皮肤对齐方式，仅在使用非完全缩放的皮肤时有效。
		 * 请使用LayoutAlign枚举，可按此方式设置左上角对齐：LayoutAlign.LEFT | LayoutAlign.TOP
		 * @return
		 *
		 */
		public function setSkin(id:String, value:Object, grid:Rectangle = null, align:int = 0x11):ISkin
		{
			if (grid == null)
			{
				grid = new Rectangle();
			}

			var s:ISkin;
			if (value is BitmapData)
			{
				s = new BitmapSkin(BitmapData(value), grid, align);
			}
			else if (value is Sprite)
			{
				s = new SpriteSkin(Sprite(value), grid, align);
			}
			else
			{
				throw new Error("Unsupport skin class type!");
			}

			_skin[id] = s;
			return s;
		}


		/**
		 * 获取皮肤
		 * @param id 皮肤定义关键字，参见SkinDef
		 * @return
		 *
		 */
		public function getSkin(id:String):ISkin
		{
			return _skin[id];
		}



		/**
		 * 设置文本样式
		 * @param id 文本样式定义关键字，参见StyleDef
		 * @param style
		 *
		 */
		public function setStyle(id:String, style:TextStyle):void
		{
			_style[id] = style;
		}


		/**
		 * 获取文本样式
		 * @param id 文本样式定义关键字，参见StyleDef
		 * @return
		 *
		 */
		public function getStyle(id:String):TextStyle
		{
			return _style[id];
		}

	}
}
