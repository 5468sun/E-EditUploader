package sxf.apps.imageeditor.mvc.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.view.CropSelectorMediator;
	import sxf.apps.imageeditor.mvc.view.CropToolMediator;
	
	public class CropActivateCommand extends SimpleCommand
	{
		public function CropActivateCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var cropToolMediator:CropToolMediator = facade.retrieveMediator(CropToolMediator.NAME) as CropToolMediator;
			var cropselectorMediator:CropSelectorMediator = facade.retrieveMediator(CropSelectorMediator.NAME) as CropSelectorMediator;
			
			switch(notification.getName())
			{
				case ImageEditorFacade.ACTIVATE_CROPPER:
					cropselectorMediator.activateCropSelector();
					cropToolMediator.activateCropTool();
					break;
				
				case ImageEditorFacade.DEACTIVATE_CROPPER:
					cropselectorMediator.deActivateCropSelector();
					cropToolMediator.deActivateCropTool();
					break;
			}
		}
	}
} 