package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	public class RotateToolEvent extends Event
	{
		public static const ROTATE_IMAGE:String = "rotateImage";
		
		private var _angle:Number;
		
		public function RotateToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,  angle:Number=NaN)
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
			return new RotateToolEvent(type, bubbles, cancelable, angle);
		}
	}
}