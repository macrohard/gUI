package com.macro.gUI.ani
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

		private var _mc:MovieClip;

		private var _frameNum:int;

		private var _scale:Point;

		private var _detectWidth:int;

		private var _detectHeight:int;

		private var _serials:Vector.<Frame>;

		/**
		 * MovieClip转位图序列化。
		 * 由于可能使用了滤镜、嵌套等方式，因此在初期一次性获取不可行，需要在运行时逐帧处理，
		 * 一旦取得完整的帧后，MovieClip对象将被释放
		 * @param mc 用于转换的动画影片剪辑
		 * @param frameNum 总帧数。由于MovieClip可能嵌套，自动探测帧数不可行。
		 * @param scale 缩放比，默认原大
		 * @param detectWidth 探测宽度，默认值200
		 * @param detectHeight 探测高度，默认值200
		 *
		 */
		public function MovieClipSerials(mc:MovieClip, frameNum:int, scale:Point = null, detectWidth:int = 200, detectHeight:int = 200)
		{
			_mc = mc;
			_frameNum = frameNum;
			_serials = new Vector.<Frame>(frameNum, true);
			_scale = (scale == null ? new Point(1, 1) : scale);
			_detectWidth = detectWidth;
			_detectHeight = detectHeight;
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
			var temp:BitmapData = new BitmapData(_detectWidth, _detectHeight, true, 0);

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
