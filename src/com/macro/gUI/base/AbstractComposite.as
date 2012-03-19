package com.macro.gUI.base
{
	import avmplus.getQualifiedClassName;
	
	import flash.geom.Rectangle;


	/**
	 * 复合式控件，由若干基本控件组合而成，如SliderBar，ScrollBar等
	 * @author Macro776@gmail.com
	 *
	 */
	public class AbstractComposite extends AbstractControl implements IComposite
	{

		/**
		 * 复合式控件。不支持皮肤定义
		 * @param width
		 * @param height
		 * @param align 布局对齐方式，默认值为左上角对齐
		 *
		 */
		public function AbstractComposite(width:int, height:int, align:int = 0x11)
		{
			super(width, height);

			if (getQualifiedClassName(this) == "com.macro.gUI.base::AbstractComposite")
			{
				throw new Error("Abstract class can not be constructed!");
			}

			_align = align;

			_children = new Vector.<IControl>();
		}


		protected var _align:int;
		
		/**
		 * 布局对齐方式
		 * @return
		 *
		 */
		public function get align():int
		{
			return _align;
		}

		public function set align(value:int):void
		{
			_align = value;
			layout();
		}
		
		
		protected var _children:Vector.<IControl>;

		public function get children():Vector.<IControl>
		{
			return _children;
		}
		
		
		/**
		 * 复合式控件的可视范围就是控件的矩形范围，因此边距始终为0。
		 * @inheritDoc
		 * @return 
		 * 
		 */
		public function get margin():Rectangle
		{
			return new Rectangle();
		}
		
		

		override public function resize(width:int = 0, height:int = 0):void
		{
			super.resize(width, height);
			layout();
		}

		/**
		 * 复合式控件本身一般情况下不需要背景，因此在背景完全透明时，可以忽略掉绘制行为
		 * @param recreate
		 *
		 */
		override protected function paint(recreate:Boolean = false):void
		{
			if (_bgColor == 0 && _transparent)
			{
				if (_bitmapData != null)
				{
					_bitmapData.dispose();
					_bitmapData = null;
				}
				return;
			}

			super.paint(recreate);
		}

		/**
		 * 根据对齐定义重新布局
		 *
		 */
		protected function layout():void
		{
		}
	}
}
