package sxf.apps.imageeditor.valueobjects
{
	import flash.display.BitmapData;

	public class ImageObject
	{
		private var _name:String;
		private var _type:String;
		private var _orgBmpData:BitmapData;
		private var _bmpData:BitmapData;

		public function ImageObject(imageName:String,imageType:String,imageBmpData:BitmapData)
		{
			_name = imageName;
			_type = imageType;
			_orgBmpData = imageBmpData;
			_bmpData = _orgBmpData.clone();
		}
		
		public function get name():String
		{
			return _name;
		}

		public function get type():String
		{
			return _type;
		}
		
		public function get orgBmpData():BitmapData
		{
			return _orgBmpData;
		}
		
		public function get bmpData():BitmapData
		{
			return _bmpData;
		}
		
		public function set bmpData(value:BitmapData):void
		{
			_bmpData = value;
		}
		
		public function get width():Number
		{
			return _bmpData.width
		}
		
		public function get height():Number
		{
			return _bmpData.height
		}
	}
}