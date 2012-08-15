package sxf.apps.imageuploader.mvc.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class DataItemsStateChangeCommand extends SimpleCommand implements ICommand
	{
		public function DataItemsStateChangeCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void{
			
			var index:int = int(notification.getBody().index);
			var prevState:String = String(notification.getBody().previousState);
			var currentState:String = String(notification.getBody().currentState);
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			listMediator.setCurrentStateAt(currentState,index);
		
		}
	}
}