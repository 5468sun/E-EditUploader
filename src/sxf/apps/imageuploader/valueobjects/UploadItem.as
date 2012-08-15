package sxf.apps.imageuploader.valueobjects{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class UploadItem extends Object{
		
		private static var uniqueSuffix:int = 0;
		
		private var _name:String;
		private var _size:Number;
		private var _type:String;
		private var _createDate:Number;
		private var _modifyDate:Number;
		private var _data:ByteArray;
		//private var _loadPercent:Number;
		//private var _uploadPercent:Number;
		//private var _loadState:Boolean;
		//private var _uploadState:Boolean;
		private var _isLoaded:Boolean;
		private var _isParsed:Boolean;
		private var _isUploaded:Boolean;
		private var _currentState:String;
		private var _previousState:String;
		private var _uniqueID:Number;
		

		
		public function UploadItem(name:String,type:String,size:Number,createDate:Number,modifyDate:Number,data:ByteArray=null){
			
			this._name = name;
			this._size = size;
			this._type = type;
			this._createDate = createDate;
			this._modifyDate = modifyDate;
			this._data = data;
			
			this._isLoaded = false;
			this._isParsed = false;
			this._isUploaded = false;
			this._currentState = null;
			this._previousState = null;
			
			uniqueID = new Date().getTime()+uniqueSuffix;
			
			uniqueSuffix +=1;
			
			trace("mediaFile created, uniqueID is " + uniqueID);
			
		}

		
		public function get name():String{
			
			return _name;
		}
		
		private function set name(value:String):void{
			
			_name = value;
		}
		

		public function get size():Number{
			
			return _size;
		}
		
		private function set size(value:Number):void{
			
			_size = value;
		}
		
		public function get type():String{
			
			return _type;
		}
		
		private function set type(value:String):void{
			
			_type = value;
		}
		

		public function get createDate():Number
		{
			return _createDate;
		}
		
		public function set createDate(value:Number):void
		{
			_createDate = value;
		}
		
		
		
		public function get modifyDate():Number
		{
			return _modifyDate;
		}
		
		public function set modifyDate(value:Number):void
		{
			_modifyDate = value;
		}


		public function set data(value:ByteArray):void{
		
			this._data = value;
		
		}


		public function get data():ByteArray{
			
			return _data;
		}
		

		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		public function set isLoaded(value:Boolean):void
		{
			_isLoaded = value;
		}
		
		public function get isParsed():Boolean
		{
			return _isParsed;
		}
		
		public function set isParsed(value:Boolean):void
		{
			_isParsed = value;
		}
		
		public function get isUploaded():Boolean
		{
			return _isUploaded;
		}
		
		public function set isUploaded(value:Boolean):void
		{
			_isUploaded = value;
		}
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			_currentState = value;
		}
		public function get previousState():String
		{
			return _previousState;
		}
		
		public function set previousState(value:String):void
		{
			_previousState = value;
		}
		public function get uniqueID():Number
		{
			return _uniqueID;
		}
		
		public function set uniqueID(value:Number):void
		{
			_uniqueID = value;
		}
		
		/*public function get isError():Boolean
		{
			return _isError;
		}
		
		public function set isError(value:Boolean):void
		{
			_isError = value;
		}*/
		
		

		/*public function get loadState():Boolean{
			
			return _loadState;
		}
		public function set loadState(value:Boolean):void{
		
			this._loadState = value;
		
		}
		

		public function get uploadState():Boolean{
			
			return _uploadState;
		}
		public function set uploadState(value:Boolean):void{
			
			this._uploadState = value;
			
		}*/
		
		

	}
}