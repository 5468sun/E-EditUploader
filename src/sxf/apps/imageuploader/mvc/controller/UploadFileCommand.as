package sxf.apps.imageuploader.mvc.controller{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.model.ImgUploaderProxy;
	import sxf.apps.imageuploader.mvc.view.UploadFileListMediator;
	
	public class UploadFileCommand extends SimpleCommand implements ICommand{
		
		public function UploadFileCommand(){
			
			super();
		}
		override public function execute(notification:INotification):void{
			
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			proxy.uploadItems();
		
		}
			
	}
}