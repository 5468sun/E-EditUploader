package sxf.apps.imageeditor.mvc.view
{
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import sxf.apps.imageeditor.events.ImageEditorEvent;
	import sxf.apps.imageeditor.mvc.ImageEditorFacade;
	import sxf.apps.imageeditor.valueobjects.ImageObject;
	
	public class ImageEditorMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "imageEditorMediator";
		
		public function ImageEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			imageEditor.addEventListener(ImageEditorEvent.LOAD_IMAGE,loadImageHandler);
		}
		
		
		private function loadImageHandler(e:ImageEditorEvent):void
		{
			var url:String = e.url;
			sendNotification(ImageEditorFacade.LOAD_IMAGE,url);
		}
		
		protected function get imageEditor():ImageEditor
		{
			return viewComponent as ImageEditor;
		}
	}
}