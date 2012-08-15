package sxf.apps.imageuploader.events{
	
	import flash.events.Event;
	
	public class ItemHandleEvent extends Event{
		
		public static const DELETE_ITEM:String = "deleteItem";
		public static const EDIT_ITEM:String = "editItem";
		public static const RELOAD_ITEM:String = "reloadItem";
		public static const UPLOAD_ITEM:String = "uploadItem";
		public static const REUPLOAD_ITEM:String = "reuploadItem";
		public static const CANCEL_UPLOAD_ITEM:String = "cancelUploadItem";
		
		private var _index:int;
		
		public function get index():int{
			
			return _index;
		}

		public function set index(value:int):void{
			
			_index = value;
		}

		
		public function ItemHandleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, index:int=NaN){
			
			super(type, bubbles, cancelable);
			this._index = index;
			
		}
		
		override public function clone():Event{
		
			return new ItemHandleEvent(type, bubbles, cancelable, index);
			
		}
	}
}