package sxf.utils.image{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class ImageFlipper extends Object{
		
		private static const FLIP_TYPE_VERTICAL:String = "flipTypeVertical";
		private static const FLIP_TYPE_HORIZONTAL:String = "flipTypeHorizontal";
		
		private var flipMatrix:Matrix;
		
		public function ImageFlipper(){
			super();
		}
		public static function flipVertical(bmpData:BitmapData):BitmapData{
			
			return flip(bmpData,FLIP_TYPE_VERTICAL);
			
			
		}
		
		public static function flipHorizontal(bmpData:BitmapData):BitmapData{
		
			return flip(bmpData,FLIP_TYPE_HORIZONTAL);
		
		}
		
		private static function flip(bmpData:BitmapData,type:String):BitmapData{
			
			var flippedBmpData:BitmapData = new BitmapData(bmpData.width,bmpData.height);
			var flipMatrix:Matrix = new Matrix();
			switch (type){
			
				case FLIP_TYPE_HORIZONTAL:

					flipMatrix.scale(-1,1);
					flipMatrix.translate(bmpData.width,0);
					break;
				
				case FLIP_TYPE_VERTICAL:
					
					flipMatrix.scale(1,-1);
					flipMatrix.translate(0,bmpData.height);
					
					break;
			
			}
			
			flippedBmpData.draw(bmpData,flipMatrix);
			
			return flippedBmpData;
		
		}
	}
}

