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
	import sxf.apps.imageeditor.mvc.view.TopInfoMediator;
	
	public class EditImageCommand extends SimpleCommand implements ICommand
	{
		private var imageStageMediator:ImageStageMediator;
		private var imageEditorProxy:ImageEditorProxy;
		private var cropSelectorMediator:CropSelectorMediator;
		private var topInfoMediator:TopInfoMediator;
		public function EditImageCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			imageEditorProxy = facade.retrieveProxy(ImageEditorProxy.NAME) as ImageEditorProxy;
			imageStageMediator = facade.retrieveMediator(ImageStageMediator.NAME) as ImageStageMediator;
			cropSelectorMediator = facade.retrieveMediator(CropSelectorMediator.NAME) as CropSelectorMediator;
			topInfoMediator = facade.retrieveMediator(TopInfoMediator.NAME) as TopInfoMediator;
			
			switch (notification.getName())
			{
				case ImageEditorFacade.IMAGE_INIT:
					imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					topInfoMediator.setName(imageEditorProxy.imageName);
					topInfoMediator.setType(imageEditorProxy.imageType);
					topInfoMediator.setSize(imageEditorProxy.bmpDataWidth +" * " + imageEditorProxy.bmpDataHeight);
					break;
				
				case ImageEditorFacade.IMAGE_ZOOM:
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					var zoomValue:Number = Number(notification.getBody());
					topInfoMediator.setZoom(zoomValue);
					break;
				
				case ImageEditorFacade.IMAGE_FLIP:
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					break;
				
				case ImageEditorFacade.IMAGE_ROTATE:
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					topInfoMediator.setSize(imageEditorProxy.bmpDataNoScaleBoundary.width +" * " + imageEditorProxy.bmpDataNoScaleBoundary.height);
					break;
				case ImageEditorFacade.IMAGE_CROP:
					imageStageMediator.updateImageBmpData(imageEditorProxy.bmpData);
					imageStageMediator.applyMatrix(imageEditorProxy.matrix.clone());
					topInfoMediator.setSize(imageEditorProxy.bmpDataWidth +" * " + imageEditorProxy.bmpDataHeight);
					sendNotification(ImageEditorFacade.DEACTIVATE_CROPPER);
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
			}
		}
		
	}
}