package com.macro.utils.serialize
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;


	/**
	 * MovieClip序列化视图对象
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class SerialsView extends Sprite
	{
		private var _serials:MovieClipSerials;

		private var _playHead:int;

		private var _bmp:Bitmap;

		public function SerialsView()
		{
			_playHead = 1;
			this.mouseEnabled = false;

			_bmp = new Bitmap();
			this.addChild(_bmp);

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,
								  onRemovedFromStageHandler)
		}

		/**
		 * 使用MovieClip来初始化视图，将自动生成一个对应的MovieClipSerials
		 * @param mc 影片剪辑
		 * @param frameNum 总帧数。
		 * @param scale 缩放比
		 *
		 */
		public function initMovieClip(mc:MovieClip, frameNum:int,
									  scale:Point = null):void
		{
			_serials = new MovieClipSerials(mc, frameNum, scale);
		}

		/**
		 * 使用序列化对象来初始化视图，共用一个序列化实例时使用
		 * @param serial
		 *
		 */
		public function initSerials(serial:MovieClipSerials):void
		{
			_serials = serial;
		}

		private function onRemovedFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		private function onAddedToStageHandler(e:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		private function onEnterFrameHandler(e:Event):void
		{
			var frame:Frame = _serials.getFrame(_playHead++);
			_bmp.bitmapData = frame;
			_bmp.x = frame.offsetPoint.x;
			_bmp.y = frame.offsetPoint.y;
		}
	}
}
