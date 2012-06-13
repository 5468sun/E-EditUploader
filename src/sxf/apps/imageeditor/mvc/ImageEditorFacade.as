package sxf.apps.imageeditor.mvc
{
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	
	public class ImageEditorFacade extends Facade implements IFacade
	{
		public static const NAME:String = "imageEditorFacade";
		
		//public static const LOAD_IMAGE:String = "LOAD_IMAGE";
		public static const IMAGE_LOADED:String = "IMAGE_LOADED";
		
		public static const ZOOM_IN_IMAGE:String = "ZOOM_IN_IMAGE";
		public static const ZOOM_OUT_IMAGE:String = "ZOOM_OUT_IMAGE";
		
		public static const ROTATE_IMAGE_CLOCKWISE:String = "ROTATE_IMAGE_CLOCKWISE";
		public static const ROTATE_IMAGE_COUNTER_CLOCKWISE:String = "ROTATE_IMAGE_COUNTER_CLOCKWISE";
		
		//public static const FLIP_IMAGE_HORIZONTAL:String = "FLIP_IMAGE_HORIZONTAL";
	//	public static const FLIP_IMAGE_VERTICAL:String = "FLIP_IMAGE_VERTICAL";
		
		public static const TOOL_ROTATE_BEGIN:String = "TOOL_ROTATE_BEGIN";
		public static const TOOL_ROTATE_CANCEL:String = "TOOL_ROTATE_CANCEL";
		
		public static const TOOL_CROP_BEGIN:String = "TOOL_CROP_BEGIN";
		public static const TOOL_CROP_CANCEL:String = "TOOL_CROP_CANCEL";
		public static const TOOL_CROP_CONFIRM:String = "TOOL_CROP_CONFIRM";
		public static const TOOL_CROP_RATIO_STATUS_CHANGE:String = "TOOL_CROP_RATIO_STATUS_CHANGE";
		public static const TOOL_CROP_RECTANGLE_CHANGE:String = "TOOL_CROP_RECTANGLE_CHANGE";
		
		public static const TOOL_RESIZE_BEGIN:String = "TOOL_RESIZE_BEGIN";
		public static const TOOL_RESIZE_CANCEL:String = "TOOL_RESIZE_CANCEL";
		public static const TOOL_RESIZE:String = "TOOL_RESIZE";
		
		public static const TOOL_RECOVER_IMAGE:String = "TOOL_RECOVER_IMAGE";
		public static const TOOL_EDIT_DONE:String = "TOOL_EDIT_DONE";
		
		public static const IMAGE_DISPLAY_INITED:String = "IMAGE_DISPLAY_INITED";
		public static const IMAGE_DISPLAY_ZOOMED:String = "IMAGE_DISPLAY_ZOOMED";
		public static const IMAGE_DISPLAY_MAPPER_MOVED:String = "IMAGE_DISPLAY_MAPPER_MOVED";
		public static const IMAGE_DISPLAY_DRAG_MOVED:String = "IMAGE_DISPLAY_DRAG_MOVED";
		public static const IMAGE_DISPLAY_FLIPPED:String = "IMAGE_DISPLAY_FLIPPED";
		public static const IMAGE_DISPLAY_ROTATED:String = "IMAGE_DISPLAY_ROTATED";
		public static const IMAGE_DISPLAY_RESIZED:String = "IMAGE_DISPLAY_RESIZED";
		public static const IMAGE_DISPLAY_RECOVERED:String = "IMAGE_DISPLAY_RECOVERED";
		
		public static const IMAGE_MAPPER_UPDATED:String = "IMAGE_MAPPER_UPDATED";
		
		public static const ANTLINE_SELECT_INIT:String = "ANTLINE_SELECT_INIT";
		public static const ANTLINE_SELECT_INIT_END:String = "ANTLINE_SELECT_INIT_END";
		public static const ANTLINE_SELECT_BEGIN:String = "ANTLINE_SELECT_BEGIN";
		public static const ANTLINE_SELECT_PROCCESS:String = "ANTLINE_SELECT_PROCCESS";
		public static const ANTLINE_SELECT_FINISH:String = "ANTLINE_SELECT_FINISH";
		public static const ANTLINE_SELECT_CANCEL:String = "ANTLINE_SELECT_CANCEL";
		
		public static const CROPPER_SELECTION_CHANGE:String = "CROPPER_SELECTION_CHANGE";
		
		//////////////////////////////////////////NEW
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
		public static const IMAGE_CENTER:String = "imageCentered";
		
		public static const CROP_RESTRAIN_CHANGE:String = "cropRestrainChange";
		public static const CROP_RECTANGLE_CHANGE:String = "cropRectangleChange";
		public static const CROP_MOUSE_LOCATION:String = "cropMouseLocation";
		public static const SELECT_RECTANGLE_CHANGE:String = "selectRectangleChange";
		
		public static const ROTATE_IMAGE:String = "rotateImage";
		public static const FLIP_IMAGE_HORIZONTAL:String = "flipImageHorizontal";
		public static const FLIP_IMAGE_VERICAL:String = "flipImageVertical";
		public static const ROTATE_FLIP_CANCEL:String = "rotateFlipCancel";
		
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