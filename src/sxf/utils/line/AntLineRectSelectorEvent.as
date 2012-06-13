package sxf.utils.line
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;
	
	public class AntLineRectSelectorEvent extends Event{
		
		public static const INIT:String = "INIT";
		public static const INIT_END:String = "INIT_END";
		public static const BEGIN:String = "BEGIN";
		public static const PROCCESS:String = "PROCCESS";
		public static const FINISH:String = "FINISH";
		public static const CANCEL:String = "CANCEL";
		
		
		private var _initPoint:Point;
		private var _endPoint:Point;
		private var _rect:Rectangle;
		
		public function AntLineRectSelectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,initPoint:Point=null,endPoint:Point=null,rect:Rectangle=null){
			
			super(type, bubbles, cancelable);
			this._initPoint = initPoint;
			this._endPoint = endPoint;
			this._rect = rect;
		}
		
		public function get initPoint():Point{
		
			return _initPoint;
			
		}
		public function get endPoint():Point{
		
			return _endPoint;
		
		}
		public function get rect():Rectangle{
		
			return _rect;
		
		}
	}
}