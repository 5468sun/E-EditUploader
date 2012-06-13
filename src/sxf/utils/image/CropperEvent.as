package sxf.utils.image{
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class CropperEvent extends Event{
		
		public static const SELECTION_CHANGE:String = "SELECTION_CHANGE";
		
		private var _rect:Rectangle;
		//private var _changeType:String;
		
		public function CropperEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,rect:Rectangle=null){
			
			super(type, bubbles, cancelable);
			this._rect = rect;
			//this._changeType = changeType;

		}
		public function get rect():Rectangle{
		
			return _rect;
		
		}
		
		/*public function get changeType():String{
		
			return _changeType;
		
		}*/
		
		override public function clone():Event{
		
			return new CropperEvent(type, bubbles, cancelable, rect);
		}
	}
}