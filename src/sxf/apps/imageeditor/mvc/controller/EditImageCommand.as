package sxf.apps.imageeditor.mvc.controller
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.mvc.model.ImageEditorProxy;
	import sxf.apps.imageeditor.mvc.view.CropSelectorMediator;
	import sxf.apps.imageeditor.mvc.view.ImageStageMediator;
	import sxf.apps.imageeditor.mvc.view.ZoomToolMediator;
	
	public class EditImageCommand extends SimpleCommand implements ICommand
	{
		private var imageStageMediator:ImageStageMediator;
		private var imageEditorProxy:ImageEditorProxy;
		private var cropSelectorMediator:CropSelectorMediator;
		private var zoomToolMediator:ZoomToolMediator;
		
		public function EditImageCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			imageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageStageMediator = facade.retrieveMediator(ImageStageMediator.NAME) as ImageStageMediator;
			cropSelectorMediator = facade.retrieveMediator(CropSelectorMediator.NAME) as CropSelectorMediator;
			zoomToolMediator = facade.retrieveMediator(ZoomToolMediator.NAME) as ZoomToolMediator;

			switch (notification.getName())
			{
				case ImageEditorFacade.IMAGE_INIT:
					imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				
				case ImageEditorFacade.IMAGE_ZOOM:
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					zoomToolMediator.setZoomValue(Number(notification.getBody()));
					break;
				
				case ImageEditorFacade.IMAGE_FLIP:
					//imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				
				case ImageEditorFacade.IMAGE_ROTATE:
					//imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				case ImageEditorFacade.IMAGE_CROP:
					//imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				case ImageEditorFacade.IMAGE_RESIZE:
					imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				
				case ImageEditorFacade.IMAGE_RESET:
					imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				
				case ImageEditorFacade.IMAGE_DRAG:
					
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				
				case ImageEditorFacade.IMAGE_CENTER:
					
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
			}
		}
		
	}
}