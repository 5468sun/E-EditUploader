package sxf.apps.imageuploader.mvc.controller
{
	import flash.display.BitmapData;
	
	import org.osmf.elements.ImageLoader;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.view.ImageUploaderMediator;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class FileOperateCommand extends SimpleCommand
	{
		public function FileOperateCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			switch(notification.getName())
			{
				case UploaderFacade.FILE_STATE_CHANGE:
					updateState(notification);
					break;
				
				case UploaderFacade.FILE_PHASE_CHANGE:
					updatePhase(notification);
					break;
				
				case UploaderFacade.FILE_LOAD_BEGIN:
					break;
				
				case UploaderFacade.FILE_LOAD_PROGRESS:
					updateProgressBar(notification);
					break;
				
				case UploaderFacade.FILE_LOAD_COMPLETE:
					break;
				
				case UploaderFacade.FILE_LOAD_ERROR:
					break;
				
				
				
				
				case UploaderFacade.FILE_PARSE_BEGIN:
					break;
				
				case UploaderFacade.FILE_PARSE_PROGRESS:
					updateProgressBar(notification);
					break;
				
				case UploaderFacade.FILE_PARSE_COMPLETE:
					break;
				
				case UploaderFacade.FILE_PARSE_ERROR:
					break;
				
				
				
				
				case UploaderFacade.FILE_UPLOAD_BEGIN:
					break;
				
				case UploaderFacade.FILE_UPLOAD_PROGRESS:
					updateProgressBar(notification);
					break;
				
				case UploaderFacade.FILE_UPLOAD_COMPLETE:
					break;
				
				case UploaderFacade.FILE_UPLOAD_ERROR:
					break;
				
			}
		}
			
		private function updateState(notification:INotification):void
		{
			var uploadFileListMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var data:Object = notification.getBody();
			var state:String = data.currentState;
			var index:int = data.index;
			uploadFileListMediator.updateStateAt(state,index);
		}
		
		private function updatePhase(notification:INotification):void
		{
			var uploadFileListMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var data:Object = notification.getBody();
			var phase:String = data.currentPhase;
			var index:int = data.index;
			uploadFileListMediator.updatePhaseAt(phase,index);
		}
		
		
		private function updateProgressBar(notification:INotification):void
		{
			var uploadFileListMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var data:Object = notification.getBody();
			var index:int = data.index;
			var percent:Number = data.percent;
			uploadFileListMediator.updateProgressBarAt(percent,index);
		}
	}
}