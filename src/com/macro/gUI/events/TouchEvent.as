package com.macro.gUI.events
{
	import com.macro.gUI.core.IControl;

	/**
	 * 用户交互事件
	 * @author yangyi
	 * 
	 */
	public class TouchEvent extends UIEvent
	{
		
		/**
		 * 鼠标悬停
		 */
		public static const MOUSE_OVER:String = "mouse.over";
		
		/**
		 * 鼠标按下
		 */
		public static const MOUSE_DOWN:String = "mouse.down";
		
		/**
		 * 鼠标松开
		 */
		public static const MOUSE_UP:String = "mouse.up";
		
		/**
		 * 鼠标移出
		 */
		public static const MOUSE_OUT:String = "mouse.out";
		
		/**
		 * 单击事件
		 */
		public static const CLICK:String = "click";
		
		/**
		 * 双击事件
		 */
		public static const DOUBLE_CLICK:String = "double.click";
		
		
		
		/**
		 * 触发的控件
		 */
		public var control:IControl;
		
		
		public function TouchEvent(type:String, control:IControl = null)
		{
			super(type);
			this.control = control;
		}
	}
}