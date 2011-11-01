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
		 * 子控件
		 */
		protected var _children:Vector.<IControl>;

		/**
		 * 布局对齐方式
		 */
		protected var _align:int;


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
				throw new Error("Abstract class can not be constructed!");

			_align = align;

			_children = new Vector.<IControl>();
		}


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
				if (_bitmapData)
					_bitmapData.dispose();
				_bitmapData = null;
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




		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
		// 以下属性、方法由整个UI体系使用，子类无须关心

		public function get children():Vector.<IControl>
		{
			return _children;
		}

		public function get containerRect():Rectangle
		{
			return _rect;
		}
	}
}
