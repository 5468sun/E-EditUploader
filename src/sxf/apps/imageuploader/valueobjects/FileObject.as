package sxf.apps.imageuploader.valueobjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class FileObject
	{
		public static const OPERATE_NOT:String = "operateNot";
		public static const OPERATE_WAITTING:String = "operateWaitting";
		public static const OPERATE_DOING:String = "operateDoing";
		
		public static const LOAD_BEGIN:String = "loadBegin";
		public static const LOAD_PROGRESS:String = "loadProgress";
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		
		public static const PARSE_BEGIN:String = "parseBegin";
		public static const PARSE_PROGRESS:String = "parseProgress";
		public static const PARSE_COMPLETE:String = "parseComplete";
		public static const PARSE_ERROR:String = "parseError";
		
		public static const UPLOAD_BEGIN:String = "uploadBegin";
		public static const UPLOAD_PROGRESS:String = "uploadProgress";
		public static const UPLOAD_COMPLETE:String = "uploadComplete";
		public static const UPLOAD_ERROR:String = "uploadError";
		
		
		
		private var _name:String;
		private var _type:String;
		private var _size:Number;
		private var _fileRef:FileReference;
		private var _data:ByteArray;
		private var _bmpData:BitmapData;
		//private var _bmp:Bitmap;
		private var _state:String;
		private var _width:Number;
		private var _height:Number;
		private var _phase:String;
		
		
		public function FileObject()
		{
			_phase = OPERATE_NOT;
		}
		

		/*public function get bmp():Bitmap
		{
			return _bmp;
		}

		public function set bmp(value:Bitmap):void
		{
			_bmp = value;
		}*/

		

		public function get fileRef():FileReference
		{
			return _fileRef;
		}
		
		public function set fileRef(value:FileReference):void
		{
			_fileRef = value;
			name = _fileRef.name;
			type = _fileRef.type;
			size = _fileRef.size;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		[Bindable]
		public function get size():Number
		{
			return _size;
		}
		
		public function set size(value:Number):void
		{
			_size = value;
		}
		
		public function get data():ByteArray
		{
			return _data;
		}
		
		public function set data(value:ByteArray):void
		{
			_data = value;
		}
		
		
		public function get bmpData():BitmapData
		{
			return _bmpData;
		}
		
		public function set bmpData(value:BitmapData):void
		{
			_bmpData = value;
		}

		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
		[Bindable]
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		[Bindable]
		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get phase():String
		{
			return _phase;
		}
		
		public function set phase(value:String):void
		{
			_phase = value;
		}

	}
}