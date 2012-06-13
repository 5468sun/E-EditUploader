package sxf.apps.imageeditor.events{
	
	import flash.events.Event;
	
	public class ToolEvent extends Event{
		
		public static const RECOVER_IMAGE:String = "RECOVER_IMAGE";
		public static const IMAGE_EDIT_DONE:String = "IMAGE_EDIT_DONE";
		
		public function ToolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
		
			return new ToolEvent(type, bubbles, cancelable);
		
		}
	}
}