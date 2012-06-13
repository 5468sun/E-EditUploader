
package sxf.apps.imageeditor.events
{
	import flash.events.Event;
	
	import sxf.apps.imageeditor.valueobjects.ImgMapperInfo;
	
	public class ImgMapperEvent extends Event{
		
		public static const IMAGE_MAPPER_UPDATE:String = "IMAGE_MAPPER_UPDATE";
		
		private var _infoObj:ImgMapperInfo;
		
		public function ImgMapperEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,infoObj:ImgMapperInfo=null){
			
			super(type, bubbles, cancelable);
			this._infoObj = infoObj;
		}
		
		public function get infoObj():ImgMapperInfo{
			
			return _infoObj;
		}
		
		override public function clone():Event{
			
			return new ImgMapperEvent(type,false,false,infoObj);
		}
	}
}

