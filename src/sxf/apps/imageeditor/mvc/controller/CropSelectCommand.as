package sxf.apps.imageeditor.mvc.controller
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.view.CropSelectorMediator;
	import sxf.apps.imageeditor.mvc.view.CropToolMediator;
	
	public class CropSelectCommand extends SimpleCommand implements ICommand
	{
		public function CropSelectCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var cropSelectorMediator:CropSelectorMediator = facade.retrieveMediator(CropSelectorMediator.NAME) as CropSelectorMediator;
			var cropToolMediator:CropToolMediator = facade.retrieveMediator(CropToolMediator.NAME) as CropToolMediator;
			
			switch(notification.getName())
			{
				case ImageEditorFacade.CROP_RESTRAIN_CHANGE:
					
					cropSelectorMediator.setRestrainRect(notification.getBody() as Rectangle);
					cropToolMediator.setRestrainRect(notification.getBody() as Rectangle);
					break;
				
				case ImageEditorFacade.CROP_RECTANGLE_CHANGE:
					cropSelectorMediator.setSelectRect(notification.getBody() as Rectangle);
					break;
				
				case ImageEditorFacade.SELECT_RECTANGLE_CHANGE:
					cropToolMediator.setSelectRect(notification.getBody() as Rectangle);
					break;
				
				case ImageEditorFacade.CROP_MOUSE_LOCATION:
					
					//
					break;
			}
		}
	}
}