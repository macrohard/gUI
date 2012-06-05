package com.macro.gUI.containers
{
	import com.macro.gUI.core.AbstractContainer;
	import com.macro.utils.ImageUtil;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;


	/**
	 * 背景面板容器
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class BackgroundPanel extends AbstractContainer
	{

		private var _image:BitmapData;

		/**
		 * 背景面板容器，使用外部图元作为面板背景
		 * @param width 初始宽度
		 * @param height 初始高度
		 * @param source 要显示的可绘制对象
		 * @param autoSize 是否自动根据显示内容设置尺寸
		 * @param align 显示内容的对齐方式，默认左上角对齐
		 *
		 */
		public function BackgroundPanel(width:int = 100, height:int = 100, source:IBitmapDrawable = null, autoSize:Boolean = true,
										align:int = 0x11)
		{
			// 默认大小
			super(width, height);

			_align = align;

			_autoSize = autoSize;

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
		
		
		
		override public function set height(value:int):void
		{
			_autoSize = false;
			super.height = value;
		}
		
		override public function set width(value:int):void
		{
			_autoSize = false;
			super.width = value;
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
