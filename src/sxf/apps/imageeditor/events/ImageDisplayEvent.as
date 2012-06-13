package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	import sxf.apps.imageeditor.valueobjects.ImageDisplayInfo;
	
	public class ImageDisplayEvent extends Event{
		
		public static const IMAGE_INITED:String = "IMAGE_INITED";
		public static const IMAGE_ZOOMED:String = "IMAGE_ZOOMED";
		public static const IMAGE_MAPPER_MOVED:String = "IMAGE_MAPPER_MOVED";
		public static const IMAGE_DRAG_MOVED:String = "IMAGE_DRAG_MOVED";
		public static const IMAGE_FLIPPED:String = "IMAGE_FLIPPED";
		public static const IMAGE_ROTATED:String = "IMAGE_ROTATED";
		
		private var _infoObj:ImageDisplayInfo;

		public function ImageDisplayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,infoObj:ImageDisplayInfo=null){
			
			super(type, bubbles, cancelable);
			this._infoObj = infoObj;
		}
		
		public function get infoObj():ImageDisplayInfo{
			
			return _infoObj;
		}
		
		override public function clone():Event{
			return new ImageDisplayEvent(type,false,false,infoObj);
		}
	}
}

