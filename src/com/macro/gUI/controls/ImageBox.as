package com.macro.gUI.controls
{
	import com.macro.gUI.GameUI;
	import com.macro.gUI.base.AbstractControl;
	import com.macro.gUI.skin.ISkin;
	import com.macro.gUI.skin.SkinDef;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;


	/**
	 * 图片框
	 * @author Macro776@gmail.com
	 * 
	 */
	public class ImageBox extends AbstractControl
	{

		private var _image:BitmapData;
		
		private var _mc:MovieClip;
		
		
		/**
		 * 图片框控件，支持边框
		 * @param source 要显示的可绘制对象
		 * @param autoSize 是否自动根据显示内容设置尺寸
		 * @param align 显示内容的对齐方式，默认左上角对齐
		 * @param skin 边框皮肤
		 * 
		 */
		public function ImageBox(source:IBitmapDrawable = null, autoSize:Boolean = true, align:int = 0x11, skin:ISkin = null)
		{
			// 默认大小
			super(100, 100);

			_align = align;

			_autoSize = autoSize;
			
			_skin = skin;
			
			init();

			setSource(source);
		}
		
		/**
		 * 初始化控件属性，子类可以在此方法中覆盖父类定义
		 *
		 */
		protected function init():void
		{
			_skin = _skin ? _skin : GameUI.skinManager.getSkin(SkinDef.IMAGEBOX_BORDER);
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
		 * 设置新的显示对象
		 * @param value
		 * @param destroy 是否销毁原有的显示对象，默认不销毁
		 * 
		 */
		public function setSource(value:IBitmapDrawable, destroy:Boolean = false):void
		{
			if (_mc)
			{
				_mc.removeEventListener(Event.ENTER_FRAME, onRedrawHandler);
			}
			
			if (value)
			{
				if (destroy && _image)
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
				
				if (value is MovieClip)
				{
					_mc = value as MovieClip;
					_mc.addEventListener(Event.ENTER_FRAME, onRedrawHandler, false, 0, true);
				}
			}
		}



		public override function resize(width:int = 0, height:int = 0):void
		{
			if (_autoSize && _image)
			{
				width = _image.width;
				height = _image.height;
			}

			super.resize(width, height);
		}


		public override function setDefaultSize():void
		{
			if (_image)
			{
				resize(_image.width, _image.height);
			}
		}



		protected override function prePaint():void
		{
			if (_image)
			{
				drawFixed(_bitmapData, _rect, _align, _image);
			}
		}


		private function getBitmapData(image:IBitmapDrawable):BitmapData
		{
			if (image is BitmapData)
			{
				return BitmapData(image);
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

		private function onRedrawHandler(e:Event):void
		{
			_image = getBitmapData(_mc);
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
}
