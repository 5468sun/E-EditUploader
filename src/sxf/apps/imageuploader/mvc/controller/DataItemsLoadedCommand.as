package sxf.apps.imageuploader.mvc.controller{
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class DataItemsLoadedCommand extends SimpleCommand implements ICommand{
		
		public function DataItemsLoadedCommand(){
			
			super();
		}
		
		override public function execute(notification:INotification):void{
		
			trace("DataItemsLoadedCommand");
			/*var index:int = int(notification.getBody().index);
			var data:ByteArray = ByteArray(notification.getBody().data);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;*/
			
			
		}
	}
}