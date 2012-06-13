package sxf.apps.imageeditor.events
{
	import flash.events.Event;

	public class ZoomToolEvent extends Event
	{
		public static const ZOOM_IN:String = "zoomIn";
		public static const ZOOM_OUT:String = "zoomOut";
		
		public function ZoomToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ZoomToolEvent(type, bubbles, cancelable);
		}
	}
}