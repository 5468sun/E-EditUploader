package sxf.apps.imageuploader.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import sxf.apps.imageuploader.events.FileListOperateEvent;
	import sxf.apps.imageuploader.valueobjects.FileObject;

	public class FileListParser extends FileListOperator
	{
		public function FileListParser(concurrentNum:uint=0)
		{
			super(concurrentNum);
		}
		
		override protected function operatorExecute(index:int):void
		{
			super.operatorExecute(index);
			var fileObject:FileObject = _fileList[index];
			var loaderInfo:LoaderInfo = _operatorList[index] as LoaderInfo;
			var operator:Loader = loaderInfo.loader;
			operator.loadBytes(fileObject.data);
		}
		
		override protected function operatorCancel(index:int):void
		{
			super.operatorCancel(index);
			var loaderInfo:LoaderInfo = _operatorList[index] as LoaderInfo;
			var operator:Loader = loaderInfo.loader;
			operator.unload();
		}
		
		override protected function putOperatorToOperatorList(index:int):void
		{
			var operator:Loader = new Loader();
			_operatorList[index] = operator.contentLoaderInfo;
		}
		
		override protected function onOperateBegin(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			var index:int = _operatorList.indexOf(loader);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.PARSE_BEGIN);
			trace(file.name+":onParseBegin");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_PARSE_BEGIN,false,false,file));
			super.onOperateBegin(e);
		}
		
		override protected function onOperateProgress(e:ProgressEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var index:int = _operatorList.indexOf(loaderInfo);
			var file:FileObject = _fileList[index];
			var percent:Number = e.bytesLoaded/e.bytesTotal;
			changeFileState(file,FileObject.PARSE_PROGRESS);
			trace(file.name+":onParseProgress");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_PARSE_PROGRESS,false,false,file,percent));
			super.onOperateProgress(e);
		}
		override protected function onOperateComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var index:int = _operatorList.indexOf(loaderInfo);
			var file:FileObject = _fileList[index];
			//file.bmp = Bitmap(loaderInfo.content);
			//var bmpData:BitmapData = new BitmapData(loaderInfo.width,loaderInfo.height);
			//bmpData.draw(loaderInfo.content);
			//var bmpData:BitmapData = Bitmap(loaderInfo.content).bitmapData;
			
			file.bmpData = Bitmap(loaderInfo.content).bitmapData;
			file.width = file.bmpData.width;
			file.height = file.bmpData.height;
			changeFileState(file,FileObject.PARSE_COMPLETE);
			trace(file.name+":onParseComplete");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_PARSE_COMPLETE,false,false,file,1));
			super.onOperateComplete(e);
		}
		override protected function onOperateError(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var index:int = _operatorList.indexOf(loaderInfo);
			var file:FileObject = _fileList[index];
			changeFileState(file,FileObject.PARSE_ERROR);
			trace(file.name+":onParseError");
			dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_PARSE_ERROR,false,false,file));
			super.onOperateError(e);
		}
	}
}