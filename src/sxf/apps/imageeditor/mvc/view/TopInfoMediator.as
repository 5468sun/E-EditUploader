package sxf.apps.imageeditor.mvc.view
{
	import mx.controls.Label;
	import mx.core.IVisualElement;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	
	import sxf.apps.imageeditor.comps.TopInfo;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageObject;
	
	public class TopInfoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "topInfoMediator";
		
		public function TopInfoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ImageEditorFacade.LOAD_IMAGE_FINISH:	
					var imageObject:ImageObject = ImageObject(notification.getBody());
					topInfo.updateName(imageObject.name);
					topInfo.updateType(imageObject.type);
					topInfo.updateSize(imageObject.width +" X "+imageObject.height);
					break;
				
				/*case ImageEditorFacade.CROP_IMAGE:
					showFileSize(notification.getBody() as ImageObject);
					break;*/
			}
		}
		
		protected function get topInfo():TopInfo
		{
			return viewComponent as TopInfo;
		}
		
	}
}