package sxf.apps.imageuploader.comps{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.core.FlexGlobals;
	
	import sxf.apps.imageuploader.events.FileListOperateEvent;
	import sxf.apps.imageuploader.valueobjects.FileObject;
	
	public class FileListUploader extends FileListOperator{

		private var _uploadURL:String = "http://127.0.0.1/F-FileUploader/php/uploader.php";
		//http://www.youtowork.com/sunxingfei/imageuploader/uploader.php
		//http://127.0.0.1/F-FileUploader/php/uploader.php
		public function FileListUploader(concurrentNum:uint=0){
			
			super(concurrentNum);
		}
		
		public function cancelUploadFile(file:FileObject):void
		{
			var index:int = _fileList.indexOf(file);
			operatorCancel(index);
		}
		
		override protected function operatorAddListener(index:int):void
		{
			super.operatorAddListener(index);
			var operator:IEventDispatcher = _operatorList.slice(index,index+1)[0];
			operator.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onOperateSecurityError);
		}
		
		override protected function operatorRemoveListener(index:int):void
		{
			super.operatorRemoveListener(index);
			var operator:IEventDispatcher = _operatorList.slice(index,index+1)[0];
			operator.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onOperateSecurityError);
		}
		
		override protected function operatorExecute(index:int):void
		{
			super.operatorExecute(index);
			var operator:URLLoader = _operatorList[index] as URLLoader;
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = (FlexGlobals.topLevelApplication.parameters.uploadURL || _uploadURL) +"?imgName="+_fileList[index].name;
			urlRequest.data = _fileList[index].data;
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.contentType = "application/octet-stream";
			
			operator.load(urlRequest);
		}
		
		override protected function operatorCancel(index:int):void
		{
			
			var operator:URLLoader = _operatorList[index] as URLLoader;
			operator.close();
			var delRequest:URLRequest = new URLRequest();
			//send request to delete unfinished file.
			super.operatorCancel(index);
		}
		
		override protected function putOperatorToOperatorList(index:int):void
		{
			var operator:URLLoader = new URLLoader();
			_operatorList[index] = operator;
		}

		
		override protected function onOperateBegin(e:Event):void
		{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			var index:int = _operatorList.indexOf(urlLoader);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_BEGIN);
			trace(file.name+":onUploadBegin");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_BEGIN,false,false,file));
			super.onOperateBegin(e);
		}
		
		override protected function onOperateProgress(e:ProgressEvent):void
		{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			var index:int = _operatorList.indexOf(urlLoader);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_PROGRESS);
			trace(file.name+":onUploadProgress");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_PROGRESS,false,false,file,0));
			super.onOperateProgress(e);
		}
		
		override protected function onOperateComplete(e:Event):void
		{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			var index:int = _operatorList.indexOf(urlLoader);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_COMPLETE);
			trace(file.name+":onUploadComplete");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_COMPLETE,false,false,file,1));
			super.onOperateComplete(e);
		}
		
		override protected function onOperateError(e:IOErrorEvent):void
		{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			var index:int = _operatorList.indexOf(urlLoader);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_ERROR);
			trace(file.name+":onUploadError");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_ERROR,false,false,file));
			super.onOperateError(e);
		}
		
		protected function onOperateSecurityError(e:SecurityErrorEvent):void
		{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			var index:int = _operatorList.indexOf(urlLoader);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.UPLOAD_ERROR);
			trace(file.name+":onUploadError");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_UPLOAD_ERROR,false,false,file));
		}
	}
}  