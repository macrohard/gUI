package com.macro.utils.serialize
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * 矢量动画MovieClip转位图序列化
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class MovieClipSerials
	{
		/**
		 * 绘制MovieClip时初始大小，绘制完成后，再进行裁剪
		 */
		private static const detectArea:Point = new Point(500, 500);

		private var _mc:MovieClip;

		private var _frameNum:int;

		private var _scale:Point;

		private var _serials:Vector.<Frame>;

		/**
		 * MovieClip转位图序列化
		 * @param mc 用于转换的动画影片剪辑
		 * @param frameNum 总帧数。由于MovieClip可能嵌套，自动探测帧数不可行。
		 * @param scale 缩放比，默认原大
		 *
		 */
		public function MovieClipSerials(mc:MovieClip, frameNum:int,
										 scale:Point = null)
		{
			_mc = mc;
			_frameNum = frameNum;
			_serials = new Vector.<Frame>(frameNum, true);
			_scale = (scale == null ? new Point(1, 1) : scale);
		}

		/**
		 * 获取对应帧的位图对象
		 * @param playHead 播放头位置，从1开始计数
		 * @return
		 *
		 */
		public function getFrame(playHead:int):Frame
		{
			var f:int = playHead % _frameNum;
			var temp:BitmapData = new BitmapData(detectArea.x, detectArea.y,
												 true, 0);
			;
			var m:Matrix = new Matrix(_scale.x, 0, 0, _scale.y);
			var r:Rectangle;
			var frame:Frame = _serials[f];
			if (frame == null)
			{
				_mc.gotoAndStop(f);

				temp.fillRect(temp.rect, 0);
				temp.draw(_mc, m);

				r = temp.getColorBoundsRect(0xFF000000, 0x00000000, false);
				frame = new Frame(r.width, r.height);
				frame.copyPixels(temp, r, new Point(), null, null, true);
				frame.offsetPoint = r.topLeft;

				_serials[f] = frame;
			}
			return frame;
		}
	}

}
