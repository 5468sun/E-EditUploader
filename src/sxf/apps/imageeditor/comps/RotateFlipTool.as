package sxf.apps.imageeditor.comps
{
	import flash.events.MouseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import sxf.apps.imageeditor.events.RotateFlipToolEvent;
	
	public class RotateFlipTool extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var _rotateLeftBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _rotateRightBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _flipHorizontalBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _flipVerticalBtn:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var _cancelBtn:SkinnableComponent;
		
		public function RotateFlipTool()
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
				
				case _flipHorizontalBtn:
					
					_flipHorizontalBtn.addEventListener(MouseEvent.CLICK,onClickFlipHorizontalBtn);
					break;
				
				case _flipVerticalBtn:
					
					_flipVerticalBtn.addEventListener(MouseEvent.CLICK,onClickFlipVerticalBtn);
					break;
				
				case _cancelBtn:
					
					_cancelBtn.addEventListener(MouseEvent.CLICK,onCancelBtn);
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
				
				case _flipHorizontalBtn:
				
				_flipHorizontalBtn.removeEventListener(MouseEvent.CLICK,onClickFlipHorizontalBtn);
				break;
				
				case _flipVerticalBtn:
				
				_flipVerticalBtn.removeEventListener(MouseEvent.CLICK,onClickFlipVerticalBtn);
				break;
				
				case _cancelBtn:
				
				_cancelBtn.removeEventListener(MouseEvent.CLICK,onCancelBtn);
				break;
			}
		}
		
		private function onClickRotateLeftBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateFlipToolEvent(RotateFlipToolEvent.ROTATE_IMAGE,false,false,-Math.PI/4));
		}
		
		private function onClickRotateRightBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateFlipToolEvent(RotateFlipToolEvent.ROTATE_IMAGE,false,false,Math.PI/4));
		}
		
		private function onClickFlipHorizontalBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateFlipToolEvent(RotateFlipToolEvent.FLIP_IMAGE_HORIZONTAL,false,false));
		}
		
		private function onClickFlipVerticalBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateFlipToolEvent(RotateFlipToolEvent.FLIP_IMAGE_VERICAL,false,false));
		}
		
		private function onCancelBtn(e:MouseEvent):void
		{
			dispatchEvent(new RotateFlipToolEvent(RotateFlipToolEvent.ROTATE_FLIP_CANCEL,false,false));
		}
	}
}
