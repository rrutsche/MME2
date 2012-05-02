package de.rutscheschobel.shareyourfilter.util{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	public class BrightnessFilter{
	
		public function BrightnessFilter(){
		
		}
		
		private var _bitmap:Bitmap;
		private var _colorTransform:ColorTransform;
		private var _fileReference:FileReference = new FileReference();
		
		public function setFilter(value:Number):void{
			_bitmap = ApplicationManager.getInstance().bitmap; 
			if(_bitmap != null){
				_colorTransform = new ColorTransform();
				_colorTransform.redOffset = value;
				_colorTransform.greenOffset = value;
				_colorTransform.blueOffset = value;
				_bitmap.transform.colorTransform = _colorTransform;
			}
		}
	}
}