package sxf.apps.imageeditor.mvc
{
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	
	public class ImageEditorFacade extends Facade implements IFacade
	{
		public static const NAME:String = "imageEditorFacade";
		
		public static const PADDING_CHANGE:String = "paddingChange";
		public static const INIT_IMAGE_DRAG:String = "initImageDrag";
		public static const DESTROY_IMAGE_DRAG:String = "destroyImageDrag";
		
		public static const LOAD_IMAGE:String = "loadImage";
		public static const LOAD_IMAGE_BEGIN:String = "loadImageBegin";
		public static const LOAD_IMAGE_PROGRESS:String = "loadImageProgress";
		public static const LOAD_IMAGE_FINISH:String = "loadImageFinish";
		public static const LOAD_IMAGE_UNLOAD:String = "loadImageUnload";
		public static const LOAD_IMAGE_ERROR:String = "loadImageError";
		
		public static const IMAGE_INIT:String = "imageInit";
		public static const IMAGE_ZOOM:String = "imageZoom";
		public static const IMAGE_FLIP:String = "imageFlip";
		public static const IMAGE_ROTATE:String = "imageRotate";
		public static const IMAGE_CROP:String = "imageCrop";
		public static const IMAGE_RESIZE:String = "imageResize";
		public static const IMAGE_RESET:String = "imageReset";
		public static const IMAGE_DRAG:String = "imageDraged";
		
		public static const CROP_RESTRAIN_CHANGE:String = "cropRestrainChange";
		public static const STEPPER_RESTRAIN_CHANGE:String = "stepperRestrainChange";
		public static const CROP_RECTANGLE_CHANGE:String = "cropRectangleChange";
		public static const REAL_CROP_RECTANGLE_CHANGE:String = "realCropRectangleChange";
		public static const CROP_MOUSE_LOCATION:String = "cropMouseLocation";
		
		public static const ROTATE_IMAGE:String = "rotateImage";
		public static const FLIP_IMAGE_HORIZONTAL:String = "flipImageHorizontal";
		public static const FLIP_IMAGE_VERICAL:String = "flipImageVertical";
		
		public static const ACTIVATE_CROPPER:String = "activateCropper";
		public static const DEACTIVATE_CROPPER:String = "deActivateCropper";
		public function ImageEditorFacade()
		{
			super();
		}
		
		public static function getInstance():ImageEditorFacade
		{
			if(instance == null){
				instance = new ImageEditorFacade();
			}
			return instance as ImageEditorFacade;
		}

	}
}