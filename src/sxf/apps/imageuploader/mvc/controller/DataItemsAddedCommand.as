package sxf.apps.imageuploader.mvc.controller{
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.model.ImgUploaderProxy;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class DataItemsAddedCommand extends SimpleCommand implements ICommand{
		
		public function DataItemsAddedCommand(){
			
			super();
		}
		
		override public function execute(notification:INotification):void{
		
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			var listMediator:UploadFileListMediator = facade.retrieveMediator(UploadFileListMediator.NAME) as UploadFileListMediator;
			var items:ArrayList = notification.getBody() as ArrayList;
			
			proxy.loadFiles(items);
			listMediator.addItemsAt(items,listMediator.getListLength());
			
		}
	}
}