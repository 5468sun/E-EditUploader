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
		
		public function setName(value:String):void
		{
			topInfo.updateName(value);
		}
		
		public function setType(value:String):void
		{
			topInfo.updateType(value);
		}
		
		public function setSize(value:String):void
		{
			topInfo.updateSize(value);
		}
		
		public function setZoom(value:Number):void
		{
			topInfo.updateZoom(value);
		}
		
		protected function get topInfo():TopInfo
		{
			return viewComponent as TopInfo;
		}
		
	}
}