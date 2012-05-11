package com.macro.gUI.skin
{
	import com.macro.gUI.assist.TextStyle;
	import com.macro.gUI.skin.impl.BitmapSkin;
	import com.macro.gUI.skin.impl.SpriteSkin;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
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
		private var _skins:Dictionary;

		/**
		 * 文本样式列表
		 */
		private var _styles:Dictionary;



		/**
		 * 皮肤管理器
		 *
		 */
		public function SkinManager()
		{
			_skins = new Dictionary();
			_styles = new Dictionary();
		}


		/**
		 * 创建皮肤
		 * @param id 皮肤定义关键字，参见SkinDef
		 * @param value 皮肤图元，目前支持BitmapData, Sprite等格式
		 * @param grid 九切片中心区域矩形。注意，缩放将使用此矩形的left, top, right, bottom值，而不是width, height。
		 * 当right大于left时，皮肤可以水平缩放，当bottom大于top时皮肤可以垂直缩放
		 * @param align 皮肤对齐方式，仅在使用非完全缩放的皮肤时有效。默认左上角对齐
		 * 请使用LayoutAlign枚举，可按此方式设置居中对齐：LayoutAlign.CENTER | LayoutAlign.MIDDLE
		 * @return
		 *
		 */
		public function addSkin(id:String, value:Object, grid:Rectangle = null, align:int = 0x11):ISkin
		{
			if (grid == null)
			{
				grid = new Rectangle();
			}

			var s:ISkin;
			if (value is Bitmap)
			{
				s = new BitmapSkin((value as Bitmap).bitmapData, grid, align);
			}
			else if (value is BitmapData)
			{
				s = new BitmapSkin(value as BitmapData, grid, align);
			}
			else if (value is Sprite)
			{
				s = new SpriteSkin(value as Sprite, grid, align);
			}
			else
			{
				throw new Error("Unsupport skin class type!");
			}

			_skins[id] = s;
			return s;
		}
		
		/**
		 * 设置皮肤
		 * @param id
		 * @param skin
		 * 
		 */
		public function setSkin(id:String, skin:ISkin):void
		{
			_skins[id] = skin;
		}


		/**
		 * 获取皮肤
		 * @param id 皮肤定义关键字，参见SkinDef
		 * @return
		 *
		 */
		public function getSkin(id:String):ISkin
		{
			return _skins[id];
		}



		/**
		 * 设置文本样式
		 * @param id 文本样式定义关键字，参见StyleDef
		 * @param style
		 *
		 */
		public function setStyle(id:String, style:TextStyle):void
		{
			_styles[id] = style;
		}


		/**
		 * 获取文本样式
		 * @param id 文本样式定义关键字，参见StyleDef
		 * @return
		 *
		 */
		public function getStyle(id:String):TextStyle
		{
			return _styles[id];
		}

	}
}
