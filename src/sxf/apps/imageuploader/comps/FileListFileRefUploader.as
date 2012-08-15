package sxf.apps.imageuploader.comps
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import sxf.apps.imageuploader.events.FileListOperateEvent;
	import sxf.apps.imageuploader.valueobjects.FileObject;

	public class FileListFileRefUploader extends FileListOperator
	{
		public static const SERVER_PATH:String = "http://127.0.0.1/F-FileUploader/php/uploader_fileRef.php";
		//http://www.youtowork.com/sunxingfei/imageuploader/uploader_fileRef.php
		//http://127.0.0.1/F-FileUploader/php/uploader_fileRef.php
		
		public function FileListFileRefUploader(concurrentNum:uint=0)
		{
			super(concurrentNum);
		}
		
		public function cancelUploadFile(file:FileObject):void
		{
			var index:int = _fileList.indexOf(file);
			operatorCancel(index);
		}
		
		override protected function operatorExecute(index:int):void
		{
			super.operatorExecute(index);
			var operator:FileReference = _operatorList[index] as FileReference;
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = SERVER_PATH;
			//urlRequest.method = URLRequestMethod.POST;
			//urlRequest.contentType = "application/octet-stream";
			operator.upload(urlRequest);
		}
		
		override protected function operatorCancel(index:int):void
		{
			super.operatorCancel(index);
			var operator:FileReference = _operatorList[index] as FileReference;
			operator.cancel();
		}
		
		override protected function putOperatorToOperatorList(index:int):void
		{
			_operatorList[index] = _fileList[index].fileRef;
		}
		
		override protected function onOperateBegin(e:Event):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_BEGIN);
			trace(file.name+":onUploadBegin");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_BEGIN,false,false,file));
			super.onOperateBegin(e);
		}
		
		
		override protected function onOperateProgress(e:ProgressEvent):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			var percent:Number = e.bytesLoaded/e.bytesTotal;
			changeFileState(file,FileObject.UPLOAD_PROGRESS);
			trace(file.name+":onUploadProgress");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_PROGRESS,false,false,file,percent));
			super.onOperateProgress(e);
		}
		
		override protected function onOperateComplete(e:Event):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_COMPLETE);
			trace(file.name+":onUploadComplete");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_COMPLETE,false,false,file,1));
			super.onOperateComplete(e);
		}
		
		override protected function onOperateError(e:IOErrorEvent):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_ERROR);
			trace(file.name+":onUploadError");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_ERROR,false,false,file));
			super.onOperateError(e);
		}
	}
}