package sxf.apps.imageuploader.mvc.model{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.valueobjects.UploadItem;
	import sxf.comps.uploader.SplitUploader;
	import sxf.comps.uploader.SplitUploaderEvent;
	
	public class ImgUploaderProxy extends Proxy implements IProxy{
		
		public static const NAME:String = "imgUploaderProxy";
		
		private var _fileList:ArrayList;
		private var _itemList:ArrayList;
		private var parserList:ArrayList;
		private var urlUpLoader:SplitUploader;
		private var UploadIndex:int;
		private var isUploading:Boolean;
		private var isUploadQueue:Boolean;
		private var itemStates:Object;
		
		public function ImgUploaderProxy(){
			
			super(NAME);
			
			_fileList = new ArrayList();
			_itemList = new ArrayList();
			parserList = new ArrayList();
			
			isUploading = false;
			isUploadQueue = false;
			
			itemStates = {
				lb:"loadBegin",
				lp:"loadProgress",
				lc:"loadComplete",
				le:"loadError",
				pb:"parseBegin",
				pp:"parseProgress",
				pc:"parseComplete",
				pe:"parseError",
				ep:"editProgress",
				ulw:"uploadWaiting",
				ulb:"uploadBegin",
				ulp:"uploadProgress",
				ulc:"uploadComplete",
				ula:"uploadAbort",
				ule:"uploadError",
				ult:"uploadTimeout"
			};
			
			urlUpLoader = new SplitUploader();
			
			urlUpLoader.addEventListener(SplitUploaderEvent.BEGIN, onUpLoadOpen);
			urlUpLoader.addEventListener(SplitUploaderEvent.PROGRESS, onUpLoadProgress);
			urlUpLoader.addEventListener(SplitUploaderEvent.COMPLETE, onUpLoadSuccess);
			urlUpLoader.addEventListener(SplitUploaderEvent.IO_ERROR, onUpLoadIOError);
			urlUpLoader.addEventListener(SplitUploaderEvent.SECURITY_ERROR, onUpLoadSecurityError);
			urlUpLoader.addEventListener(SplitUploaderEvent.TIMEOUT,onUpLoadTimeout);
			
		}
		
		////////////////////////////////////
		// getter setter functions
		//////////////////////////////////
		public function get dataLength():int{
		
			return fileList.length;
		
		}
		
		private function get fileList():ArrayList{
			
			return _fileList;
		}
		
		private function get itemList():ArrayList{
			
			return _itemList;
		}
		
		/////////////////////////////
		// public functions
		////////////////////////////
		
		public function addItemsAt(fileList:Array,index:int):void{
			
			var validFiles:Array = validateFileList(fileList);

			var items:ArrayList = new ArrayList();
			var files:ArrayList = new ArrayList();
			var parsers:ArrayList = new ArrayList();
			
			var name:String;
			var size:Number;
			var type:String;
			var createDate:Number;
			var modifyDate:Number;
			var data:ByteArray;
			var file:FileReference;
			var uploadItem:UploadItem;
			
			for(var i:int=0; i<validFiles.length; i++){
				
				file = FileReference(validFiles[i]);
				
				name = file.name;
				size = file.size;
				type = file.type;
				createDate = file.creationDate.getTime();
				modifyDate = file.modificationDate.getTime();
				data = file.data;
				
				uploadItem = new UploadItem(name,type,size,createDate,modifyDate,data);
				
				files.addItem(file);
				items.addItem(uploadItem);
				parsers.addItem(null);
				
			}
			
			this.itemList.addAllAt(items,index);
			this.fileList.addAllAt(files,index);
			this.parserList.addAllAt(parsers,index);
			
			sendNotification(UploaderFacade.DATA_ITEMS_ADDED,items);
		
		}
		
		public function removeItemAt(index:int):void{
			
			if(isUploading){
			
				removeUploadingItemAt(index);
			
			}else{
			
				removeLoadingOrParsingItemAt(index);
			
			}
			
			sendNotification(UploaderFacade.DATA_ITEM_REMOVED,index);
		
		}

		
		public function loadFiles(items:ArrayList):void{
			
			var item:Object;
			var index:int;
			
			for(var i:int=0; i<items.length; i++){
			
				item = items.getItemAt(i);
				index = itemList.getItemIndex(item);
				loadFileAt(index);
			
			}
		
		}
		
		
		
		public function reloadFileAt(index:int):void{
		
			var fileRef:FileReference = FileReference(this.fileList.getItemAt(index));
		
			fileRef.load();
		
		}
		
		
		public function setItemDataAt(data:ByteArray,index:int):void{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			uploadItem.data = data;
			sendNotification(UploaderFacade.DATA_ITEM_LOADED,{data:data,index:index});
			
			parseImage(data,index);
			
		}
		
		public function getItemDataAt(index:int):ByteArray{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			return uploadItem.data;
		
		}
		
		public function getCurrentStateAt(index:int):String{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			return uploadItem.currentState;
		
		}
		
		public function setCurrentStateAt(value:String,index:int):void{
			
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			if(value == uploadItem.currentState) return;
			uploadItem.previousState = uploadItem.currentState;
			uploadItem.currentState = value;
			sendNotification(UploaderFacade.DATA_ITEM_STATE_CHANGE,{index:index,currentState:uploadItem.currentState,previousState:uploadItem.previousState});
		
		}
		
		private function setLoadStateAt(value:Boolean,index:int):void{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			uploadItem.isLoaded = value;
			
		}
		
		private function getLoadStateAt(index:int):Boolean{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			return uploadItem.isLoaded;
			
		}
		
		private function setParseStateAt(value:Boolean,index:int):void{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			uploadItem.isParsed = value;
		
		}
		
		private function getParseStateAt(index:int):Boolean{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			return uploadItem.isParsed;
		
		}
		
		private function setUploadStateAt(value:Boolean,index:int):void{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			uploadItem.isUploaded = value;
			
		}
		
		private function getUploadStateAt(index:int):Boolean{
		
			var uploadItem:UploadItem = itemList.getItemAt(index) as UploadItem;
			return uploadItem.isUploaded;
			
		}
		
		
		public function uploadItems():void{

			if(itemList.length == 0 || isUploading) return;
			
			isUploadQueue = true;
			isUploading = true;
			UploadIndex = 0;
			
			
			prepareUpload();
			uploadItemAt(UploadIndex);
		}
		
		
		
		public function cancelUploadItemAt(index:int):void{
			
			urlUpLoader.closeCurrentUpload();
			sendNotification(UploaderFacade.UPLOAD_CANCEL,{index:index});
			tryUploadNextItem();
			
		}
		
		
		public function reUploadItemAt(index:int):void{
		
			uploadItemAt(index);
		
		}
		
		public function removeUploadedItem():void{
		
			trace("removeUploadedItem");
			if(isUploading || itemList.length==0) return;
			
			var item:UploadItem;
			for(var i:int=itemList.length-1; i>=0; i--){
				
				item = itemList.getItemAt(i) as UploadItem;
				if(item.isUploaded){
					
					removeItemAt(i);
				}
			}

		}
		
		/////////////////////////
		// util functions
		///////////////////////////
		
		private function validateFileList(dirtyFileList:Array):Array{
			
			var existFileRef:UploadItem;
			var dirtyFileRef:FileReference;
			
			if(this.fileList.length > 0){

				for(var i:int=dirtyFileList.length-1; i>=0; i--){
					
					dirtyFileRef = dirtyFileList[i];
					
					for(var j:int=0; j<fileList.length; j++){
						
						existFileRef = itemList.getItemAt(j) as UploadItem;
						if(dirtyFileRef.name == existFileRef.name && dirtyFileRef.creationDate.getTime() == existFileRef.createDate){

							dirtyFileList.splice(i,1);
							break;
							
						}
					}
					
				}
				
			}

			return dirtyFileList;
			
		}
		private function loadFileAt(index:int):void{
			
			var fileRef:FileReference = FileReference(this.fileList.getItemAt(index));
			fileRef.addEventListener(Event.OPEN,onFileLoadBegin);
			fileRef.addEventListener(ProgressEvent.PROGRESS,onFileLoadProgress);
			fileRef.addEventListener(Event.COMPLETE,onFileLoadComplete);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,onFileLoadError);
			fileRef.load();
			
		}
		private function uploadItemAt(index:int):void{
			
			var uploadItem:UploadItem = UploadItem(itemList.getItemAt(index));
			var isParsed:Boolean = uploadItem.isParsed;
			var isUploaded:Boolean = uploadItem.isUploaded;
			var data:ByteArray = uploadItem.data;
			var name:String = uploadItem.name;
			var id:Number =  uploadItem.uniqueID;
			
			if(isParsed  && !isUploaded){
				
				urlUpLoader.upload(data,name,id,"http://www.shoujih.com/filex/chunk.php",NaN,20);
				
			}else{
				
				tryUploadNextItem();
				
			}
			
		}
		private function prepareUpload():void{
			
			var uploadItem:UploadItem;
			for(var i:int=0; i<itemList.length; i++){
				
				uploadItem = itemList.getItemAt(i) as UploadItem;
				
				if(uploadItem.isParsed && !uploadItem.isUploaded){
					
					setCurrentStateAt(itemStates["ulw"],i);
					sendNotification(UploaderFacade.UPLOAD_WAIT,{index:i});
					
				}
			}
			
		}
		private function removeLoadHandlerAt(index:int):void{
			
			var fileRef:FileReference = FileReference(this.fileList.getItemAt(index));
			fileRef.removeEventListener(Event.OPEN,onFileLoadBegin);
			fileRef.removeEventListener(ProgressEvent.PROGRESS,onFileLoadProgress);
			fileRef.removeEventListener(Event.COMPLETE,onFileLoadComplete);
			fileRef.removeEventListener(IOErrorEvent.IO_ERROR,onFileLoadError);
			
		}
		
		private function removeParseHandlerAt(index:int):void{
		
			var loader:Loader = Loader(this.parserList.getItemAt(index));
			
			if(loader){
			
				loader.contentLoaderInfo.removeEventListener(Event.OPEN,onParseImgOpen);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onParseImgProgress);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onParseImgComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onParseImgError);
				
			}
			
		
		}
		
		private function parseImage(data:ByteArray,index:int):void{
		
			var loader:Loader = new Loader();
			parserList.removeItemAt(index);
			parserList.addItemAt(loader,index);
			loader.contentLoaderInfo.addEventListener(Event.OPEN,onParseImgOpen);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onParseImgProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onParseImgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onParseImgError);
			loader.loadBytes(data);
		
		}
		
		private function tryUploadNextItem():void{
		
			if(!isUploadQueue) return;
			
			if(UploadIndex+1<itemList.length){
				
				UploadIndex +=1;
				
				var timer:Timer = new Timer(300,1);
				timer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{uploadItemAt(UploadIndex)});
				timer.start();
				
				
				
			}else{
				
				isUploadQueue = false;
				isUploading = false;
				UploadIndex = NaN;
				
			}
			
		
		}
		
		
		private function removeLoadingOrParsingItemAt(index:int):void{
			
			removeLoadHandlerAt(index);
			removeParseHandlerAt(index);
			
			fileList.removeItemAt(index);
			itemList.removeItemAt(index);
			parserList.removeItemAt(index);
			
		}
		
		private function removeUploadingItemAt(index:int):void{
			
			if(index < UploadIndex){
				
				removeLoadHandlerAt(index);
				fileList.removeItemAt(index);
				itemList.removeItemAt(index);
				parserList.removeItemAt(index);
				UploadIndex -= 1;
				
				
			}else if(index == UploadIndex){
				
				urlUpLoader.closeCurrentUpload();
				removeLoadHandlerAt(index);
				fileList.removeItemAt(index);
				itemList.removeItemAt(index);
				parserList.removeItemAt(index);
				UploadIndex -= 1;
				tryUploadNextItem();
				
			}else{
				
				removeLoadHandlerAt(index);
				fileList.removeItemAt(index);
				itemList.removeItemAt(index);
				parserList.removeItemAt(index);
				
			}
			
		}
		
		////////////////////
		// event handlers
		//////////////////////
		
		private function onFileLoadBegin(e:Event):void{
			
			trace("onFileLoadBegin");
			var fileRef:FileReference = FileReference(e.target);
			var index:int = this.fileList.getItemIndex(fileRef);

			setLoadStateAt(false,index);
			setCurrentStateAt(itemStates["lb"],index);
			sendNotification(UploaderFacade.LOAD_LOCAL_FILE_BEGIN,{index:index,percent:0});
			
		}
		
		
		private function onFileLoadProgress(e:ProgressEvent):void{
			
			trace("onFileLoadProgress");
			var fileRef:FileReference = FileReference(e.target);
			var index:int = this.fileList.getItemIndex(fileRef);
			var percent:Number =  e.bytesLoaded/e.bytesTotal;
			setCurrentStateAt(itemStates["lp"],index);
			sendNotification(UploaderFacade.LOAD_LOCAL_FILE_PROGRESS,{index:index,percent:percent});
			
		}
		
		private function onFileLoadComplete(e:Event):void{
			
			trace("onFileLoadComplete");
			var fileRef:FileReference = FileReference(e.target);
			var index:int = this.fileList.getItemIndex(fileRef);

			setLoadStateAt(true,index);
			setCurrentStateAt(itemStates["lc"],index);
			setItemDataAt(fileRef.data,index);
			sendNotification(UploaderFacade.LOAD_LOCAL_FILE_COMPLETE,{index:index,percent:1});
			
			
		}
		
		private function onFileLoadError(e:IOErrorEvent):void{
			
			trace("onFileLoadError");
			var fileRef:FileReference = FileReference(e.target);
			var index:int = this.fileList.getItemIndex(fileRef);
			setLoadStateAt(false,index);
			setCurrentStateAt(itemStates["le"],index);
			sendNotification(UploaderFacade.LOAD_LOCAL_FILE_ERROR,{index:index});
			
		}
		
		private function onParseImgOpen(e:Event):void{
		
			trace("onParseImgOpen");
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			var index:int = parserList.getItemIndex(loader);
			setParseStateAt(false,index);
			setCurrentStateAt(itemStates["pb"],index);
			sendNotification(UploaderFacade.IMAGE_PARSE_BEGIN,{index:index});
		
		}
		
		private function onParseImgProgress(e:ProgressEvent):void{
			
			trace("onParseImgProgress");
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			var index:int = parserList.getItemIndex(loader);
			setCurrentStateAt(itemStates["pp"],index);
			sendNotification(UploaderFacade.IMAGE_PARSE_PROGRESS,{index:index});
		
		}
		private function onParseImgComplete(e:Event):void{
			
			trace("onParseImgComplete");
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			var index:int = parserList.getItemIndex(loader); 
			var bmpData:BitmapData = new BitmapData(loaderInfo.width,loaderInfo.height);
			bmpData.draw(loaderInfo.content);
			setParseStateAt(true,index);
			setCurrentStateAt(itemStates["pc"],index);
			sendNotification(UploaderFacade.IMAGE_PARSE_COMPLETE,{index:index,bmpData:bmpData});
			loader.unload();
		
		}
		private function onParseImgError(e:IOErrorEvent):void{
		
			trace("onParseImgError");
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			var index:int = parserList.getItemIndex(loader);
			setParseStateAt(false,index);
			setCurrentStateAt(itemStates["pe"],index);
			sendNotification(UploaderFacade.IMAGE_PARSE_ERROR,{index:index});
		
		}

		private function onUpLoadOpen(e:SplitUploaderEvent):void{
			
			trace("onUpLoadOpen");
			setUploadStateAt(false,UploadIndex);
			setCurrentStateAt(itemStates["ulb"],UploadIndex);
			sendNotification(UploaderFacade.UPLOAD_BEGIN,{index:UploadIndex,percent:e.percent});
			
		}

		private function onUpLoadProgress(e:SplitUploaderEvent):void{
			
			trace("onUpLoadProgress");
			setCurrentStateAt(itemStates["ulp"],UploadIndex);
			sendNotification(UploaderFacade.UPLOAD_PROGRESS,{index:UploadIndex,percent:e.percent});
		}
		
		private function onUpLoadSuccess(e:SplitUploaderEvent):void{
			
			trace("onUpLoadSuccess");
			setUploadStateAt(true,UploadIndex);
			setCurrentStateAt(itemStates["ulc"],UploadIndex);
			sendNotification(UploaderFacade.UPLOAD_COMPLETE,{index:UploadIndex,percent:e.percent});
			tryUploadNextItem();
			
		}
		
		private function onUpLoadIOError(e:SplitUploaderEvent):void{
			
			trace("onUpLoadIOError");
			setUploadStateAt(false,UploadIndex);
			setCurrentStateAt(itemStates["ule"],UploadIndex);
			sendNotification(UploaderFacade.UPLOAD_ERROR,{index:UploadIndex});
			tryUploadNextItem();
			
		}
		
		private function onUpLoadSecurityError(e:SplitUploaderEvent):void{
			
			trace("onUpLoadSecurityError");
			setUploadStateAt(false,UploadIndex);
			setCurrentStateAt(itemStates["ule"],UploadIndex);
			sendNotification(UploaderFacade.UPLOAD_ERROR,{index:UploadIndex});
			tryUploadNextItem();
			
		}
		
		private function onUpLoadTimeout(e:SplitUploaderEvent):void{
		
			trace("onUpLoadTimeout");
			setUploadStateAt(false,UploadIndex);
			setCurrentStateAt(itemStates["ult"],UploadIndex);
			sendNotification(UploaderFacade.UPLOAD_TIMEOUT,{index:UploadIndex});
			tryUploadNextItem();
		
		}
	}
}