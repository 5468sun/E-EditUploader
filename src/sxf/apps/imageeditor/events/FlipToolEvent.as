package sxf.apps.imageeditor.events
{
	import flash.events.Event;

	public class FlipToolEvent extends Event
	{
		
		public static const FLIP_IMAGE_HORIZONTAL:String = "flipImageHorizontal";
		public static const FLIP_IMAGE_VERICAL:String = "flipImageVertical";
		
		private var _angle:Number;
		
		public function FlipToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		
		override public function clone():Event
		{
			return new FlipToolEvent(type, bubbles, cancelable);
		}
	}
}