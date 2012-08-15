package sxf.apps.imageuploader.mvc.controller{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class UploadCommand extends SimpleCommand implements ICommand{
		
		public function UploadCommand(){
			
			super();
		}
		
		override public function execute(notification:INotification):void{
		
		
			switch (notification.getName()){
				
				case UploaderFacade.UPLOAD_WAIT:
					
					onUploadWait(notification);
					break;
				case UploaderFacade.UPLOAD_BEGIN:
					
					onUploadBegin(notification);
					break;
				
				case UploaderFacade.UPLOAD_PROGRESS:
					
					onUploadProgress(notification);
					break;
				
				case UploaderFacade.UPLOAD_COMPLETE:
					
					onUploadComplete(notification);
					break;
				
				case UploaderFacade.UPLOAD_CANCEL:
					
					onUploadCancel(notification);
					break;
				
				case UploaderFacade.UPLOAD_ERROR:
					
					onUploadError(notification);
					break;
				
				case UploaderFacade.UPLOAD_TIMEOUT:
					
					onUploadTimeout(notification);
					break;
			
			}
		
		}
		
		private function onUploadWait(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadWait(index);
		}
		
		private function onUploadBegin(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var percent:Number = Number(notification.getBody().percent);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadBegin(percent,index);
		
		}
		
		private function onUploadProgress(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var percent:Number = Number(notification.getBody().percent);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadProgress(percent,index);
		
		}
		
		private function onUploadCancel(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadCancel(index);
		
		}
		
		private function onUploadComplete(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var percent:Number = Number(notification.getBody().percent);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadComplete(percent,index);
		
		}
		
		private function onUploadError(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadError(index);
		
		}
		
		private function onUploadTimeout(notification:INotification):void{
		
			var index:int = int(notification.getBody().index);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.onItemUploadTimeout(index);
		
		}
	}
}