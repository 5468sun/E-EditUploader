package sxf.apps.imageeditor.events
{
	import flash.events.Event;

	public class RotateFlipToolEvent extends Event
	{
		public static const ROTATE_IMAGE:String = "rotateImage";
		public static const FLIP_IMAGE_HORIZONTAL:String = "flipImageHorizontal";
		public static const FLIP_IMAGE_VERICAL:String = "flipImageVertical";
		public static const ROTATE_FLIP_CANCEL:String = "rotateFlipCancel";
		
		private var _angle:Number;
		
		public function RotateFlipToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, angle:Number=NaN)
		{
			super(type, bubbles, cancelable);
			this._angle = angle;
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		override public function clone():Event
		{
			return new RotateFlipToolEvent(type, bubbles, cancelable,angle);
		}
	}
}