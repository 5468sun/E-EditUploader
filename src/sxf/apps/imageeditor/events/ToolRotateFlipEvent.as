package sxf.apps.imageeditor.events{
	
	import flash.events.Event;
	
	public class ToolRotateFlipEvent extends Event{
		
		public static const BEGIN:String = "ROTATE_FLIP_BEGIN";
		public static const CANCEL:String = "ROTATE_FLIP_CANCEL";
		public static const ROTATE_IMAGE_CLOCKWISE:String = "ROTATE_IMAGE_CLOCKWISE";
		public static const ROTATE_IMAGE_COUNTER_CLOCKWISE:String = "ROTATE_IMAGE_COUNTER_CLOCKWISE";
		public static const FLIP_IMAGE_VERTICAL:String = "FLIP_IMAGE_VERTICAL";
		public static const FLIP_IMAGE_HORIZONTAL:String = "FLIP_IMAGE_HORIZONTAL";
		
		public function ToolRotateFlipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
		
			return new ToolRotateFlipEvent(type, bubbles, cancelable);
		
		}
			
	}
}