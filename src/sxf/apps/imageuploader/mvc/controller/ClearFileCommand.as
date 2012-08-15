package sxf.apps.imageuploader.mvc.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.model.ImgUploaderProxy;
	
	public class ClearFileCommand extends SimpleCommand implements ICommand
	{
		public function ClearFileCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void{
			
			var proxy:ImgUploaderProxy = facade.retrieveProxy(ImgUploaderProxy.NAME) as ImgUploaderProxy;
			proxy.removeUploadedItem();
			
		}
	}
}