package com.macro.gUI.controls
{
	import com.macro.gUI.core.AbstractControl;
	import com.macro.gUI.core.IControl;
	import com.macro.gUI.core.feature.IButton;
	import com.macro.gUI.core.feature.IKeyboard;
	
	import flash.events.KeyboardEvent;
	
	public class ImageButton extends AbstractControl implements IButton, IKeyboard
	{
		public function ImageButton(width:int, height:int)
		{
			super(width, height);
		}
		
		public function mouseDown(target:IControl):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function mouseOut(target:IControl):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function mouseOver(target:IControl):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function mouseUp(target:IControl):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get tabIndex():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function keyUp(e:KeyboardEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}