package sxf.apps.imageuploader.events{
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ImageUploaderEvent extends Event{
		
		public static const EDIT_IMAGE:String = "editImage";
		
		private var _imageByteArray:ByteArray;

		public function ImageUploaderEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false,imageData:ByteArray=null){
			
			super(type, bubbles, cancelable);
			this._imageByteArray = imageData;
			
		}
		
		public function get imageByteArray():ByteArray{
			
			return _imageByteArray;
		}
		
		public function set imageByteArray(value:ByteArray):void{
			
			_imageByteArray = value;
		}
	}
}