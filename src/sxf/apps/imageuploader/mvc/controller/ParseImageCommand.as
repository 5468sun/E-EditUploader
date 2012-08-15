package sxf.apps.imageuploader.mvc.controller{
	
	import flash.display.BitmapData;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.comps.UploadFileListItemRenderer;
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class ParseImageCommand extends SimpleCommand implements ICommand{
		
		
		
		public function ParseImageCommand(){
			
			super();
		}
		
		override public function execute(notification:INotification):void{
		
			
			switch (notification.getName()){
			
				case UploaderFacade.IMAGE_PARSE_BEGIN:
					
					onImageParseBegin(notification);
					break;
				
				case UploaderFacade.IMAGE_PARSE_PROGRESS:
					
					onImageParseProgress(notification);
					break;
				
				case UploaderFacade.IMAGE_PARSE_COMPLETE:
					
					onImageParseComplete(notification);
					break;
				
				case UploaderFacade.IMAGE_PARSE_ERROR:
					
					onImageParseError(notification);
					break;
			
			}
		
		}
		
		
		private function onImageParseBegin(notification:INotification):void{
		
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var index:int = int(notification.getBody().index);
			listMediator.onImageParseBegin(index);
		
		}
		
		private function onImageParseProgress(notification:INotification):void{
		
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var index:int = int(notification.getBody().index);
			listMediator.onImageParseProgress(index);
		
		}
		
		private function onImageParseComplete(notification:INotification):void{
		
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var index:int = int(notification.getBody().index);
			var bmpData:BitmapData = BitmapData(notification.getBody().bmpData);
			listMediator.onImageParseComplete(bmpData,index);
		
		}
		
		private function onImageParseError(notification:INotification):void{
		
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var index:int = int(notification.getBody().index);
			listMediator.onImageParseError(index);
		
		}
		
	}
}