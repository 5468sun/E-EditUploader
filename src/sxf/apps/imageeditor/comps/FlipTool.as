package sxf.apps.imageeditor.comps
{
	import flash.events.MouseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import sxf.apps.imageeditor.events.FlipToolEvent;
	
	public class FlipTool extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var _flipHorizontalBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _flipVerticalBtn:SkinnableComponent;
		
		public function FlipTool()
		{
			super();
			deActivate();
		}
		
		public function activate():void
		{
			this.visible = true;
			this.includeInLayout = true;
		}
		
		public function deActivate():void
		{
			this.visible = false;
			this.includeInLayout = false;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			switch(instance)
			{
				
				case _flipHorizontalBtn:
					
					_flipHorizontalBtn.addEventListener(MouseEvent.CLICK,onClickFlipHorizontalBtn);
					break;
				
				case _flipVerticalBtn:
					
					_flipVerticalBtn.addEventListener(MouseEvent.CLICK,onClickFlipVerticalBtn);
					break;
				
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{
				
				case _flipHorizontalBtn:
				
				_flipHorizontalBtn.removeEventListener(MouseEvent.CLICK,onClickFlipHorizontalBtn);
				break;
				
				case _flipVerticalBtn:
				
				_flipVerticalBtn.removeEventListener(MouseEvent.CLICK,onClickFlipVerticalBtn);
				break;

			}
		}
		
		private function onClickFlipHorizontalBtn(e:MouseEvent):void
		{
			dispatchEvent(new FlipToolEvent(FlipToolEvent.FLIP_IMAGE_HORIZONTAL,false,false));
		}
		
		private function onClickFlipVerticalBtn(e:MouseEvent):void
		{
			dispatchEvent(new FlipToolEvent(FlipToolEvent.FLIP_IMAGE_VERICAL,false,false));
		}
		
	}
}
