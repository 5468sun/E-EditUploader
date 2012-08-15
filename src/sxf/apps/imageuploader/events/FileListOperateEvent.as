package sxf.apps.imageuploader.events
{
	import flash.events.Event;
	
	import sxf.apps.imageuploader.valueobjects.FileObject;
	
	public class FileListOperateEvent extends Event
	{
		public static const FILE_STATE_CHANGE:String = "fileStateChange";
		public static const FILE_PHASE_CHANGE:String = "filePhaseChange";
		
		public static const FILE_LOAD_BEGIN:String = "fileLoadBegin";
		public static const FILE_LOAD_PROGRESS:String = "fileLoadProgress";
		public static const FILE_LOAD_COMPLETE:String = "fileLoadComplete";
		public static const FILE_ALL_LOAD_COMPLETE:String = "fileAllLoadComplete";
		public static const FILE_LOAD_ERROR:String = "fileLoadError";
		
		public static const FILE_PARSE_BEGIN:String = "fileParseBegin";
		public static const FILE_PARSE_PROGRESS:String = "fileParseProgress";
		public static const FILE_PARSE_COMPLETE:String = "fileParseComplete";
		public static const FILE_ALL_PARSE_COMPLETE:String = "fileAllParseComplete";
		public static const FILE_PARSE_ERROR:String = "fileParseError";
		
		
		public static const FILE_UPLOAD_BEGIN:String = "fileUploadBegin";
		public static const FILE_UPLOAD_PROGRESS:String = "fileUploadProgress";
		public static const FILE_UPLOAD_COMPLETE:String = "fileUploadComplete";
		public static const FILE_ALL_UPLOAD_COMPLETE:String = "fileAllUploadComplete";
		public static const FILE_UPLOAD_ERROR:String = "fileUploadError";
		
		
		private var _file:FileObject;
		private var _percent:Number;
		private var _prevState:String;
		private var _currentState:String;
		private var _prevPhase:String;
		private var _currentPhase:String;
		
		public function FileListOperateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, file:FileObject=null, percent:Number=NaN, prevState:String=null, currentState:String=null, prevPhase:String=null, currentPhase:String=null)
		{
			super(type, bubbles, cancelable);
			this._file = file;
			this._percent = percent;
			this._prevState = prevState;
			this._currentState = currentState;
			this._prevPhase = prevPhase;
			this._currentPhase = currentPhase;
		}


		public function get file():FileObject
		{
			return _file;
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		public function get prevState():String
		{
			return _prevState;
		}
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function get prevPhase():String
		{
			return _prevPhase;
		}
		
		public function get currentPhase():String
		{
			return _currentPhase;
		}
		
		override public function clone():Event
		{
			return new FileListOperateEvent(type,bubbles,cancelable,file,percent,prevState,currentState,prevPhase,currentPhase);
		}
	}
}