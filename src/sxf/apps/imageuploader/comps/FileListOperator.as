package sxf.apps.imageuploader.comps
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import sxf.apps.imageuploader.events.FileListOperateEvent;
	import sxf.apps.imageuploader.valueobjects.FileObject;
	
	public class FileListOperator implements IEventDispatcher
	{
		private var _eventDispatcher:EventDispatcher;
		protected var _fileList:Vector.<FileObject>;
		protected var _operatorList:Array;
		//protected var _freeOperatorList:Array;
		//protected var _buzyOperatorList:Array;
		//protected var _currentIndex:int;
		protected var _concurrentNum:uint;
		private var _currentConcurrentNum:uint;
		
		public function FileListOperator(concurrentNum:uint=0)
		{
			_eventDispatcher = new EventDispatcher(this);
			_concurrentNum = concurrentNum;
			_currentConcurrentNum = 0;
			//_currentIndex = 0;
			_fileList = new Vector.<FileObject>();
			_operatorList = new Array();
			//_freeOperatorList = new Array();
			//_buzyOperatorList = new Array();
		}
		
		public function operate(file:FileObject):void
		{
			if(!isFileExist(file))
			{
				putFileToFileList(file);
				var index:int = _fileList.indexOf(file);
				putOperatorToOperatorList(index);
				tryToOperate();
			}
		}
		
		public function removeFile(file:FileObject):void
		{
			var index:int = _fileList.indexOf(file);
			if(index>=0)
			{
				operatorCancel(index);
				operatorRemoveListener(index);
				removeOperatorFromOperatorList(index);
				removeFileFromFileList(index);
				_currentConcurrentNum -= 1;
				tryToOperate();
			}
		}
		
		protected function tryToOperate():void
		{
			if(_concurrentNum == 0 || _currentConcurrentNum<_concurrentNum)
			{
				var file:FileObject = getFirstUnoperatedFile();
				if(file)
				{
					doOperate(file);
				}
			}
			
		}
		
		protected function doOperate(file:FileObject):void{
			
			var index:int = _fileList.indexOf(file);
			operatorAddListener(index);
			operatorExecute(index);
			_currentConcurrentNum += 1;
			changeFilePhase(file,FileObject.OPERATE_DOING);
		}
		
		protected function getFirstUnoperatedFile():FileObject
		{
			var file:FileObject;
			for each(var fileObj:FileObject in _fileList)
			{
				if(fileObj.phase == FileObject.OPERATE_WAITTING)
				{
					file = fileObj;
					break;
				}
			}
			return file;
		}
		
		protected function changeFileState(file:FileObject,targetState:String):void
		{
			if(file.state != targetState)
			{
				var prevState:String = file.state;
				file.state = targetState;
				var currentState:String = file.state;
				dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_STATE_CHANGE,false,false,file,NaN,prevState,currentState));
			}
		}
		
		protected function changeFilePhase(file:FileObject,targetPhase:String):void
		{
			if(file.phase != targetPhase)
			{
				var prevPhase:String = file.phase;
				file.phase = targetPhase;
				var currentPhase:String = file.phase;
				dispatchEvent(new FileListOperateEvent(FileListOperateEvent.FILE_PHASE_CHANGE,false,false,file,NaN,null,null,prevPhase,currentPhase));
			}
			
		}
		
		protected function onOperateBegin(e:Event):void
		{
			// do stuff in Child class
		}
		
		
		protected function onOperateProgress(e:ProgressEvent):void
		{
			// do stuff in Child class
		}
		
		
		protected function onOperateComplete(e:Event):void
		{
			var index:int = _operatorList.indexOf(e.currentTarget);
			//operatorCancel(index);
			operatorRemoveListener(index);
			removeOperatorFromOperatorList(index);
			removeFileFromFileList(index);
			_currentConcurrentNum -= 1;
			tryToOperate();
			
		}
		
		protected function onOperateError(e:IOErrorEvent):void
		{
			var index:int = _operatorList.indexOf(e.currentTarget);
			//operatorCancel(index);
			operatorRemoveListener(index);
			removeOperatorFromOperatorList(index);
			removeFileFromFileList(index);
			_currentConcurrentNum -= 1;
			tryToOperate();
		}
		
		
		protected function get isFileGoodToOperate():Boolean{
			return false;
		}
		
		protected function isFileExist(file:FileObject):Boolean
		{
			var exist:Boolean;
			if(_fileList.indexOf(file) == -1)
			{
				exist = false;
			}
			else
			{
				exist = true;
			}			
			return exist;
		}
		
		protected function putFileToFileList(file:FileObject):void
		{
			_fileList.push(file);
			changeFilePhase(file,FileObject.OPERATE_WAITTING);
		}
		
		protected function putOperatorToOperatorList(index:int):void
		{
			//do stuffs in child class
		}
		
		protected function removeFileFromFileList(index:int):void
		{
			var file:FileObject = _fileList[index];
			_fileList.splice(index,1);
			changeFilePhase(file,FileObject.OPERATE_NOT);
		}
		
		protected function removeOperatorFromOperatorList(index:int):void
		{
			_operatorList.splice(index,1);
		}
		
		protected function operatorAddListener(index:int):void
		{
			var operator:IEventDispatcher = _operatorList.slice(index,index+1)[0];
			operator.addEventListener(Event.OPEN,onOperateBegin);
			operator.addEventListener(ProgressEvent.PROGRESS,onOperateProgress);
			operator.addEventListener(Event.COMPLETE,onOperateComplete);
			operator.addEventListener(IOErrorEvent.IO_ERROR,onOperateError);
		}
		
		protected function operatorRemoveListener(index:int):void
		{
			var operator:IEventDispatcher = _operatorList.slice(index,index+1)[0];
			operator.removeEventListener(Event.OPEN,onOperateBegin);
			operator.removeEventListener(ProgressEvent.PROGRESS,onOperateProgress);
			operator.removeEventListener(Event.COMPLETE,onOperateComplete);
			operator.removeEventListener(IOErrorEvent.IO_ERROR,onOperateError);
		}
		
		protected function operatorExecute(index:int):void
		{
			//do stuffs in child class
		}
		
		protected function operatorCancel(index:int):void
		{
			//do stuffs in child class
			tryToOperate();
		}
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}