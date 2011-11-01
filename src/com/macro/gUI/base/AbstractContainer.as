package com.macro.gUI.base
{

	import avmplus.getQualifiedClassName;

	import com.macro.gUI.skin.ISkin;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;


	/**
	 * 抽象容器，不允许实例化，几乎所有容器都继承于它。
	 * 如果不需要完整的容器功能，可以直接实现IContainer接口
	 * @author Macro776@gmail.com
	 *
	 */
	public class AbstractContainer extends AbstractControl implements IContainer
	{

		/**
		 * 顶层画布
		 */
		protected var _bitmapDataCover:BitmapData;


		/**
		 * 子控件
		 */
		protected var _children:Vector.<IControl>;


		/**
		 * 顶层皮肤<br/><br/>
		 * 未直接曝露，支持此属性的子类自行提供访问器
		 */
		protected var _skinCover:ISkin;

		/**
		 * 容器可视范围边距。此属性定义的是与基类rect的间距。 <br/>
		 * 如基类_rect定义的是宽为100, 高为100的尺寸，_marginRect定义是[5, 5, 5, 5]，
		 * 则实际容器矩形是[5, 5, 95, 95]。注意，矩形中四个数值是left, top, right, bottom。<br/>
		 * 通常情况下，此属性值基于皮肤九切片中心区域来定义。<br/><br/>
		 * 
		 * 未直接曝露，支持此属性的子类自行提供访问器
		 */
		protected var _marginRect:Rectangle;



		/**
		 * 抽象容器
		 * @param width 容器宽度
		 * @param height 容器高度
		 *
		 */
		public function AbstractContainer(width:int, height:int)
		{
			super(width, height);

			if (getQualifiedClassName(this) == "com.macro.gUI.base::AbstractContainer")
				throw new Error("Abstract class can not be constructed!");

			_children = new Vector.<IControl>();
		}




		override public function resize(width:int = 0, height:int = 0):void
		{
			if (_skinCover && width < _skinCover.minWidth)
				width = _skinCover.minWidth;

			if (_skinCover && height < _skinCover.minHeight)
				height = _skinCover.minHeight;

			super.resize(width, height);
		}


		override protected function paint(recreate:Boolean = false):void
		{
			super.paint(recreate);

			if (recreate || !_bitmapDataCover)
			{
				if (_bitmapDataCover)
					_bitmapDataCover.dispose();

				_bitmapDataCover = new BitmapData(_rect.width, _rect.height, _transparent, 0);
			}
			else
				_bitmapDataCover.fillRect(_bitmapDataCover.rect, 0);

			if (_skinCover && _skinCover.bitmapData)
			{
				var h:Boolean, v:Boolean;

				if (_skinCover.gridRight > _skinCover.gridLeft)
					h = true;

				if (_skinCover.gridBottom > _skinCover.gridTop)
					v = true;

				if (h && v)
					drawFull(_bitmapDataCover, _rect, _skinCover);
				else if (h && !v)
					drawHorizontal(_bitmapDataCover, _rect, _skinCover);
				else if (!h && v)
					drawVertical(_bitmapDataCover, _rect, _skinCover);
				else
					drawFixed(_bitmapDataCover, _rect, _skinCover.align, _skinCover.bitmapData);
			}
		}




		//=======================================================================


		/**
		 * 添加子控件
		 * @param child
		 *
		 */
		public function addChild(child:IControl):void
		{
			_children.push(child);

			if (child.parent)
				child.parent.removeChild(child);
			AbstractControl(child).setParent(this);
		}

		/**
		 * 在给定深度添加子控件
		 * @param child
		 * @param index
		 *
		 */
		public function addChildAt(child:IControl, index:int):void
		{
			if (index < 1)
				_children.unshift(child);
			else if (index >= _children.length)
				_children.push(child);
			else
				_children.splice(index, 0, child);

			if (child.parent)
				child.parent.removeChild(child);
			AbstractControl(child).setParent(this);
		}

		/**
		 * 移除子控件
		 * @param child
		 *
		 */
		public function removeChild(child:IControl):void
		{
			var p:int = _children.indexOf(child);
			if (p != -1)
				_children.splice(p, 1);

			if (child is AbstractControl)
				AbstractControl(child).setParent(null);
		}

		/**
		 * 移除指定深度的控件，并将其返回
		 * @param index
		 * @return
		 *
		 */
		public function removeChildAt(index:int):IControl
		{
			var child:IControl;
			if (index >= 0 && index < _children.length)
			{
				child = _children.splice(index, 1)[0];

				if (child is AbstractControl)
					AbstractControl(child).setParent(null);
			}

			return child;
		}




		/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
		// 以下属性、方法由整个UI体系使用，子类无须关心

		public function get bitmapDataCover():BitmapData
		{
			return _bitmapDataCover;
		}

		public function get containerRect():Rectangle
		{
			var r:Rectangle = new Rectangle();
			r.left = _marginRect.left;
			r.top = _marginRect.top;
			r.right = _rect.width - _marginRect.right;
			r.bottom = _rect.height - _marginRect.bottom;
			return r;
		}

		public function get children():Vector.<IControl>
		{
			return _children;
		}
	}
}
