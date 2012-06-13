package sxf.apps.imageeditor.valueobjects{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class ImageDisplayInfo extends Object{
		
		private var _imgWidth:Number;
		private var _imgHeight:Number;
		private var _prevImgX:Number;
		private var _prevImgY:Number;
		private var _imgX:Number;
		private var _imgY:Number;
		private var _prevZoomValue:Number;
		private var _currentZoomValue:Number;
		private var _viewPortWidth:Number;
		private var _viewPortHeight:Number;
		private var _bmpData:BitmapData;
		private var _imgSelection:Rectangle;
		
		public function ImageDisplayInfo(imgWidth:Number=NaN,imgHeight:Number=NaN,prevImgX:Number=NaN,prevImgY:Number=NaN,imgX:Number=NaN,imgY:Number=NaN,prevZoomValue:Number=NaN,currentZoomValue:Number=NaN,viewPortWidth:Number=NaN,viewPortHeight:Number=NaN,bmpData:BitmapData=null,selection:Rectangle=null){
			
			super();
			this._imgWidth = imgWidth;
			this._imgHeight = imgHeight;
			this._prevImgX = prevImgX;
			this._prevImgY = prevImgY;
			this._imgX = imgX;
			this._imgY = imgY;
			this._prevZoomValue = prevZoomValue;
			this._currentZoomValue = currentZoomValue;
			this._viewPortWidth = viewPortWidth;
			this._viewPortHeight = viewPortHeight;
			this._bmpData = bmpData;
			this._imgSelection = selection;
		}
		
		public function get imgWidth():Number{
			
			return _imgWidth;
		}
		
		public function get imgHeight():Number{
			
			return _imgHeight;
		}
		
		public function get prevImgX():Number{
			
			return _prevImgX;
		}
		
		public function get prevImgY():Number{
			
			return _prevImgY;
		}
		
		public function get imgX():Number{
			
			return _imgX;
		}
		
		public function get imgY():Number{
			
			return _imgY;
		}
		
		public function get prevZoomValue():Number{
			
			return _prevZoomValue;
		}
		
		public function get currentZoomValue():Number{
			
			return _currentZoomValue;
		}
		
		public function get viewPortWidth():Number{
			
			return _viewPortWidth;
		}
		
		public function get viewPortHeight():Number{
			
			return _viewPortHeight;
		}
		public function get bmpData():BitmapData{
			
			return _bmpData;
		}
		
		public function get imgSelection():Rectangle{
			
			return _imgSelection;
		}
	}
}