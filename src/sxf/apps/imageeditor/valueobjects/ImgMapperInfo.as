package sxf.apps.imageeditor.valueobjects{
	
	public class ImgMapperInfo extends Object{
		
		private var _imgWidth:Number;
		private var _imgHeight:Number;
		private var _viewPortX:Number;
		private var _viewPortY:Number;
		private var _viewPortWidth:Number;
		private var _viewPortHeight:Number;
		
		public function ImgMapperInfo(imgWidth:Number,imgHeight:Number,viewPortX:Number,viewPortY:Number,viewPortWidth:Number,viewPortHeight:Number){
			
			super();
			
			this._imgWidth = imgWidth;
			this._imgHeight = imgHeight;
			this._viewPortX = viewPortX;
			this._viewPortY = viewPortY;
			this._viewPortWidth = viewPortWidth;
			this._viewPortHeight = viewPortHeight;

		}
		
		public function get imgWidth():Number{
		
			return this._imgWidth;
			
		}
		
		public function get imgHeight():Number{
			
			return this._imgHeight;
			
		}

		public function get viewPortX():Number{
			
			return this._viewPortX;
			
		}
		
		public function get viewPortY():Number{
			
			return this._viewPortY;
			
		}
		
		public function get viewPortWidth():Number{
			
			return this._viewPortWidth;
			
		}
		
		public function get viewPortHeight():Number{
			
			return this._viewPortHeight;
			
		}
	}
}