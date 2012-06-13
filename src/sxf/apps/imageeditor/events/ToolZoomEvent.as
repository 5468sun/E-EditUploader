package sxf.apps.imageeditor.events{
	
	import flash.events.Event;
	
	public class ToolZoomEvent extends Event{
		
		public static const ZOOM_IN_IMAGE:String = "ZOOM_IN_IMAGE";
		public static const ZOOM_OUT_IMAGE:String = "ZOOM_OUT_IMAGE";
		
		public function ToolZoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
		
			return new ToolZoomEvent(type, bubbles, cancelable);
		
		}
	}
}