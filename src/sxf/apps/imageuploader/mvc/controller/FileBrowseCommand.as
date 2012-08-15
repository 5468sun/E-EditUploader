package sxf.apps.imageuploader.mvc.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageuploader.mvc.UploaderFacade;
	import sxf.apps.imageuploader.mvc.model.UploaderProxy;
	import sxf.apps.imageuploader.mvc.view.LocalFileBrowserMediator;
	import sxf.comps.localfileloader.LocalFileBrowseType;
	
	public class FileBrowseCommand extends SimpleCommand implements ICommand
	{
		
		public function FileBrowseCommand()
		{
			
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var uploadProxy:UploaderProxy = facade.retrieveProxy(UploaderProxy.NAME) as UploaderProxy;
			
			switch(notification.getName())
			{
				case UploaderFacade.BROWSE_FILE_INIT:
					trace("Browse file init.");
					break;
				
				case UploaderFacade.BROWSE_FILE_SELECT:
					trace("Browse file selected.");
					var fileRefs:Array = notification.getBody() as Array;
					uploadProxy.addFileRefs(fileRefs);
					break;
				
				case UploaderFacade.BROWSE_FILE_CANCEL:
					trace("Browse file cancel.");
					break;
			}
		}
	}
}