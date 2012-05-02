package com.macro.gUI.controls
{
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	import com.macro.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;


	/**
	 * 图片框
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ImageBox extends AbstractControl
	{

		protected var _image:BitmapData;


		/**
		 * 图片框控件，支持皮肤，显示对象处于皮肤下层。
		 * 用于动画显示时，需注意性能问题，如果无须皮肤合成，则应使用Canvas控件
		 * @param source 要显示的可绘制对象
		 * @param autoSize 是否自动根据显示内容设置尺寸
		 * @param align 显示内容的对齐方式，默认左上角对齐
		 * @param skin 边框皮肤
		 *
		 */
		public function ImageBox(source:IBitmapDrawable = null, autoSize:Boolean = true, align:int = 0x11, skin:ISkin = null)
		{
			// 默认大小
			super(50, 50);

			_align = align;

			_autoSize = autoSize;

			_skin = skin;

			this.image = source;
		}


		private var _align:int;

		/**
		 * 显示内容的对齐方式。
		 * 请使用LayoutAlign枚举，可按如下方式设置左上角对齐：<br/>
		 * alignSkin = LayoutAlign.LEFT | LayoutAlign.TOP
		 */
		public function get align():int
		{
			return _align;
		}

		public function set align(value:int):void
		{
			if (_align != value)
			{
				_align = value;

				if (!_autoSize)
				{
					resize();
				}
			}
		}


		private var _autoSize:Boolean;

		/**
		 * 是否自动根据显示内容设置尺寸
		 * @return
		 *
		 */
		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			if (_autoSize != value)
			{
				_autoSize = value;
				if (_autoSize)
				{
					resize();
				}
			}
		}


		/**
		 * 顶层皮肤
		 * @return
		 *
		 */
		public function get coverSkin():ISkin
		{
			return _skin;
		}

		public function set coverSkin(value:ISkin):void
		{
			if (_skin != value)
			{
				_skin = value;
				resize();
			}
		}



		/**
		 * 设置新的显示对象，旧显示对象相关的BitmapData将被自动销毁
		 * @param value
		 *
		 */
		public function set image(value:IBitmapDrawable):void
		{
			if (_image != null)
			{
				_image.dispose();
			}

			_image = ImageUtil.getBitmapData(value);
			resize();
		}



		override public function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize && _image != null)
			{
				width = _image.width;
				height = _image.height;
			}

			super.resize(width, height);
		}


		override public function setDefaultSize():void
		{
			if (_image != null)
			{
				resize(_image.width, _image.height);
			}
		}



		override protected function prePaint():void
		{
			if (_image != null)
			{
				drawFixed(_bitmapData, _width, _height, _align, _image);
			}
		}
	}
}
