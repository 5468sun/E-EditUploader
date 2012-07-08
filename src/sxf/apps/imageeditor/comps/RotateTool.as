package sxf.apps.imageeditor.comps
{
	import flash.events.MouseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import sxf.apps.imageeditor.events.RotateToolEvent;
	
	public class RotateTool extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var _rotateLeftBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _rotateRightBtn:SkinnableComponent;
		
		public function RotateTool()
		{
			super();
		}
		override protected function partAdded(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case _rotateLeftBtn:
					
					_rotateLeftBtn.addEventListener(MouseEvent.CLICK,onClickRotateLeftBtn);
					break;
				
				case _rotateRightBtn:
					
					_rotateRightBtn.addEventListener(MouseEvent.CLICK,onClickRotateRightBtn);
					break;
				
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case _rotateLeftBtn:
					
					_rotateLeftBtn.removeEventListener(MouseEvent.CLICK,onClickRotateLeftBtn);
					break;
				
				case _rotateRightBtn:
					
					_rotateRightBtn.removeEventListener(MouseEvent.CLICK,onClickRotateRightBtn);
					break;

			}
		}
		
		private function onClickRotateLeftBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateToolEvent(RotateToolEvent.ROTATE_IMAGE,false,false,-Math.PI/18));
		}
		
		private function onClickRotateRightBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateToolEvent(RotateToolEvent.ROTATE_IMAGE,false,false,Math.PI/18));
		}
		

	}
}