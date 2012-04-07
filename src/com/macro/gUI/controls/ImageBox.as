package com.macro.gUI.controls
{
	import com.macro.gUI.base.AbstractControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
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

		private var _image:BitmapData;


		/**
		 * 图片框控件，支持边框
		 * // TODO 实现BitBlt或顶点索引
		 * @param source 要显示的可绘制对象
		 * @param autoSize 是否自动根据显示内容设置尺寸
		 * @param align 显示内容的对齐方式，默认左上角对齐
		 * @param skin 边框皮肤
		 *
		 */
		public function ImageBox(source:IBitmapDrawable = null, autoSize:Boolean = true, align:int = 0x11,
								 skin:ISkin = null)
		{
			// 默认大小
			super(100, 100);

			_align = align;

			_autoSize = autoSize;

			_skin = skin ? skin : skinManager.getSkin(SkinDef.IMAGEBOX_BORDER);

			setSource(source);
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
					paint();
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
		 * 皮肤
		 * @return
		 *
		 */
		public function get skin():ISkin
		{
			return _skin;
		}

		public function set skin(value:ISkin):void
		{
			if (_skin != value)
			{
				_skin = value;
				if (_autoSize)
				{
					resize();
				}
				else
				{
					paint();
				}
			}
		}



		/**
		 * 设置新的显示对象
		 * @param value
		 * @param destroy 是否销毁原有的显示对象，默认不销毁
		 *
		 */
		public function setSource(value:IBitmapDrawable, destroy:Boolean = false):void
		{
			if (value != null)
			{
				if (destroy && _image != null)
				{
					_image.dispose();
				}

				_image = getBitmapData(value);
				if (_autoSize)
				{
					resize();
				}
				else
				{
					paint();
				}
			}
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize && _image != null)
			{
				width = _image.width;
				height = _image.height;
			}

			super.resize(width, height);
		}


		public override function setDefaultSize():void
		{
			if (_image != null)
			{
				resize(_image.width, _image.height);
			}
		}



		protected override function prePaint():void
		{
			if (_image != null)
			{
				drawFixed(_bitmapData, _rect, _align, _image);
			}
		}


		private function getBitmapData(image:IBitmapDrawable):BitmapData
		{
			if (image is BitmapData)
			{
				return image as BitmapData;
			}
			else if (image is DisplayObject)
			{
				var r:Rectangle = (image as DisplayObject).getBounds(null);
				var bmd:BitmapData = new BitmapData(r.right + 1, r.bottom + 1, true, 0);
				bmd.draw(image);
				return bmd;
			}

			throw new Error("Unknow IBitmapDrawable Object!");
		}
	}
}
