package sxf.apps.imageeditor.events{
	
	import flash.events.Event;
	
	public class ResizeEvent extends Event{
		
		public static const BEGIN:String = "RESIZE_BEGIN";
		public static const CANCLE:String = "RESIZE_CANCEL";
		public static const RESIZE:String = "IMAGE_RESIZE";
		private var _newWidth:Number;
		private var _newHeight:Number;
		
		public function ResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,newWidth:Number=NaN,newHeight:Number=NaN){
			
			super(type, bubbles, cancelable);
			this._newWidth = newWidth;
			this._newHeight = newHeight;
			
		}
		
		public function get newWidth():Number{
		
			return this._newWidth;
		
		}
		
		public function get newHeight():Number{
		
			return this._newHeight;
		
		}
	}
}