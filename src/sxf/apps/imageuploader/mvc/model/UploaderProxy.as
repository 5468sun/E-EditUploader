package sxf.apps.imageuploader.mvc.model
{
	import flash.net.FileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import sxf.apps.imageuploader.comps.FileListFileRefUploader;
	import sxf.apps.imageuploader.comps.FileListLoader;
	import sxf.apps.imageuploader.comps.FileListParser;
	import sxf.apps.imageuploader.comps.FileListUploader;
	import sxf.apps.imageuploader.events.FileListOperateEvent;
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.valueobjects.FileObject;
	
	public class UploaderProxy extends Proxy
	{
		public static const NAME:String = "uploadProxy";
		
		private var _fileList:Vector.<FileObject>;
		private var _fileListLoader:FileListLoader;
		private var _fileListParser:FileListParser;
		private var _fileListUploader:FileListFileRefUploader;
		
		public function UploaderProxy(data:Object=null)
		{
			super(NAME, data);
			_fileList = new Vector.<FileObject>();
			
			initFileListLoader();
			initFileListParser();
			initFileListUploader();
		}
		
		public function addFileAt(file:FileObject,index:int):void
		{
			_fileList.splice(index,0,file);
			loadFile(file);
		}
		
		public function removeFileAt(index:int):void
		{
			var file:FileObject = _fileList[index];
			_fileListLoader.removeFile(file);
			_fileListParser.removeFile(file);
			_fileListUploader.removeFile(file);
			_fileList.splice(index,1);
		}
		
		public function addFilesAt(files:Vector.<FileObject>,index:int):void
		{
			for(var i:int=files.length-1; i>=0; i--)
			{
				addFileAt(files[i],index);
			}
		}
		
		public function removeFilesAt(indexs:Array):void
		{
			for(var i:int=indexs.length-1; i>=0; i--)
			{
				removeFileAt(indexs[i]);
			}
		}
		
		public function reloadFileAt(index:int):void
		{
			var file:FileObject = _fileList[index];
			_fileListLoader.operate(file);

		}
		
		public function addFileRefs(fileRefs:Array):void
		{
			var fileRefExist:Boolean;
			for each(var fileRef:FileReference in fileRefs)
			{
				fileRefExist = false;
				for each(var fileObj:FileObject in _fileList)
				{
					if(compareFileRef(fileRef,fileObj.fileRef))
					{
						fileRefExist = true;
						break;
					}
				}
				if(!fileRefExist)
				{
					var fileObject:FileObject = new FileObject();
					fileObject.fileRef = fileRef;
					sendNotification(UploaderFacade.FILE_ADDED_TO_LIST,{file:fileObject,index:_fileList.length});
				}
			}
		}
		
		public function uploadFileAt(index:int):void
		{
			var file:FileObject = _fileList[index];
			uploadFile(file);
		}
		
		public function uploadFileList():void
		{
			for each(var file:FileObject in _fileList)
			{
				if(file.state == FileObject.PARSE_COMPLETE)
				{
					uploadFile(file);
				}
			}
		}
		
		public function clearFileListUploaded():void
		{
			var file:FileObject;
			for(var index:int=_fileList.length-1;index>=0;index--)
			{
				file = _fileList[index];
				if(file.state == FileObject.UPLOAD_COMPLETE)
				{
					sendNotification(UploaderFacade.FILE_REMOVED_FROM_LIST,index);
				}
			}
		}
		
		public function clearFileListErrored():void
		{
			var file:FileObject;
			for(var index:int=_fileList.length-1;index>=0;index--)
			{
				file = _fileList[index];
				if(file.state == FileObject.LOAD_ERROR || file.state == FileObject.PARSE_ERROR || file.state == FileObject.UPLOAD_ERROR)
				{
					sendNotification(UploaderFacade.FILE_REMOVED_FROM_LIST,index);
				}
			}
		}
		
		public function cancelUploadAt(index:int):void
		{
			var file:FileObject = _fileList[index];
			cancelUploadFile(file);
		}

		private function compareFileRef(fileRef1:FileReference,fileRef2:FileReference):Boolean
		{
			return(fileRef1.name == fileRef2.name && fileRef1.size == fileRef2.size && fileRef1.type == fileRef2.type && fileRef1.creationDate.getTime() == fileRef2.creationDate.getTime());
		}
		
		/*private function changeFileState(file:FileObject,targetState:String):void
		{
			var prevState:String = file.state;
			file.state = targetState;
			var currentState:String = file.state;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_STATE_CHANGE,{index:index,prevState:prevState,currentState:currentState});
		}
		
		private function changeFilePhase(file:FileObject,targetPhase:String):void
		{
			var prevPhase:String = file.phase;
			file.phase = targetPhase;
			var currentPhase:String = file.phase;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_PHASE_CHANGE,{index:index,prevPhase:prevPhase,currentPhase:currentPhase});
		}*/
		
		private function initFileListLoader():void
		{
			_fileListLoader = new FileListLoader();
			_fileListLoader.addEventListener(FileListOperateEvent.FILE_LOAD_BEGIN,onLoadBegin);
			_fileListLoader.addEventListener(FileListOperateEvent.FILE_LOAD_PROGRESS,onLoadProgress);
			_fileListLoader.addEventListener(FileListOperateEvent.FILE_LOAD_COMPLETE,onLoadComplete);
			_fileListLoader.addEventListener(FileListOperateEvent.FILE_LOAD_ERROR,onLoadError);
			
			_fileListLoader.addEventListener(FileListOperateEvent.FILE_STATE_CHANGE,onStateChange);
			_fileListLoader.addEventListener(FileListOperateEvent.FILE_PHASE_CHANGE,onPhaseChange);
		}
		
		private function initFileListParser():void
		{
			_fileListParser = new FileListParser();
			_fileListParser.addEventListener(FileListOperateEvent.FILE_PARSE_BEGIN,onParseBegin);
			_fileListParser.addEventListener(FileListOperateEvent.FILE_PARSE_PROGRESS,onParseProgress);
			_fileListParser.addEventListener(FileListOperateEvent.FILE_PARSE_COMPLETE,onParseComplete);
			_fileListParser.addEventListener(FileListOperateEvent.FILE_PARSE_ERROR,onParseError);
			
			_fileListParser.addEventListener(FileListOperateEvent.FILE_STATE_CHANGE,onStateChange);
			_fileListParser.addEventListener(FileListOperateEvent.FILE_PHASE_CHANGE,onPhaseChange);
		}
		
		private function initFileListUploader():void
		{
			//_fileListUploader = new FileListUploader(2);
			_fileListUploader = new FileListFileRefUploader(2);
			_fileListUploader.addEventListener(FileListOperateEvent.FILE_UPLOAD_BEGIN,onUploadBegin);
			_fileListUploader.addEventListener(FileListOperateEvent.FILE_UPLOAD_PROGRESS,onUploadProgress);
			_fileListUploader.addEventListener(FileListOperateEvent.FILE_UPLOAD_COMPLETE,onUploadComplete);
			_fileListUploader.addEventListener(FileListOperateEvent.FILE_UPLOAD_ERROR,onUploadError);
			
			_fileListUploader.addEventListener(FileListOperateEvent.FILE_STATE_CHANGE,onStateChange);
			_fileListUploader.addEventListener(FileListOperateEvent.FILE_PHASE_CHANGE,onPhaseChange);
		}
		
		private function loadFile(file:FileObject):void
		{
			_fileListLoader.operate(file);
		}
		
		private function parseFile(file:FileObject):void
		{
			_fileListParser.operate(file);
		}
		
		private function uploadFile(file:FileObject):void
		{
			_fileListUploader.operate(file);
		}
		
		private function cancelUploadFile(file:FileObject):void
		{
			_fileListUploader.cancelUploadFile(file);
		}
		
		private function onLoadBegin(e:FileListOperateEvent):void
		{
			
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_LOAD_BEGIN,{index:index});
		}
		
		private function onLoadProgress(e:FileListOperateEvent):void
		{
			
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_LOAD_PROGRESS,{index:index,percent:e.percent});
		}
		
		private function onLoadComplete(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_LOAD_COMPLETE,{index:index,percent:e.percent});
			parseFile(file);
		}
		
		
		private function onLoadError(e:FileListOperateEvent):void
		{
			
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_LOAD_ERROR,{index:index});
		}
		
		private function onParseBegin(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_PARSE_BEGIN,{index:index});
		}
		
		private function onParseProgress(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_PARSE_PROGRESS,{index:index,percent:e.percent});
		}
		
		private function onParseComplete(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_PARSE_COMPLETE,{bmpData:file.bmpData,index:index,percent:e.percent});
		}
		
		private function onParseError(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_PARSE_ERROR,{index:index});
		}
		
		private function onUploadBegin(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_UPLOAD_BEGIN,{index:index});
		}
		
		private function onUploadProgress(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_UPLOAD_PROGRESS,{index:index,percent:e.percent});
		}
		
		private function onUploadComplete(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_UPLOAD_COMPLETE,{index:index,percent:e.percent});
		}
		
		private function onUploadError(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			sendNotification(UploaderFacade.FILE_UPLOAD_ERROR,{index:index});
		}
		
		private function onStateChange(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			var prevState:String = e.prevState;
			var currentState:String = e.currentState;
			sendNotification(UploaderFacade.FILE_STATE_CHANGE,{index:index,prevState:prevState,currentState:currentState});
		}
		
		private function onPhaseChange(e:FileListOperateEvent):void
		{
			var file:FileObject = e.file;
			var index:int = _fileList.indexOf(file);
			var prevPhase:String = e.prevPhase;
			var currentPhase:String = e.currentPhase;
			sendNotification(UploaderFacade.FILE_PHASE_CHANGE,{index:index,prevPhase:prevPhase,currentPhase:currentPhase});
		}
	}
}