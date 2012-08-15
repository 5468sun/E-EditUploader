package sxf.apps.imageuploader.comps
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	
	import sxf.apps.imageuploader.events.FileListOperateEvent;
	import sxf.apps.imageuploader.valueobjects.FileObject;

	public class FileListLoader extends FileListOperator
	{
		public function FileListLoader(concurrentNum:uint=0)
		{
			super(concurrentNum);
		}
		
		override protected function operatorExecute(index:int):void
		{
			super.operatorExecute(index);
			var operator:FileReference = _operatorList[index] as FileReference;
			operator.load();
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
			changeFileState(file,FileObject.LOAD_BEGIN);
			trace(file.name+":onLoadBegin");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_LOAD_BEGIN,false,false,file));
			super.onOperateBegin(e);
		}
		
		
		override protected function onOperateProgress(e:ProgressEvent):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			var percent:Number = e.bytesLoaded/e.bytesTotal;
			changeFileState(file,FileObject.LOAD_PROGRESS);
			trace(file.name+":onLoadProgress");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_LOAD_PROGRESS,false,false,file,percent));
			super.onOperateProgress(e);
		}
		
		override protected function onOperateComplete(e:Event):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			file.data = fileRef.data;
			changeFileState(file,FileObject.LOAD_COMPLETE);
			trace(file.name+":onLoadComplete");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_LOAD_COMPLETE,false,false,file,1));
			super.onOperateComplete(e);
		}
		
		override protected function onOperateError(e:IOErrorEvent):void
		{
			var fileRef:FileReference = e.currentTarget as FileReference;
			var index:int = _operatorList.indexOf(fileRef);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.LOAD_ERROR);
			trace(file.name+":onLoadError");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_LOAD_ERROR,false,false,file));
			super.onOperateError(e);
		}
	}
}