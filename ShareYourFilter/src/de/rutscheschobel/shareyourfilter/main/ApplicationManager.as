package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.event.JPEGAsyncCompleteEvent;
	import de.rutscheschobel.shareyourfilter.util.JPEGAsyncEncoder;
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	import de.rutscheschobel.shareyourfilter.view.components.ProgressBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;

	public class ApplicationManager{
		
		private var _imageWindow:ImageWindow;
		private var _imageFile:File;
		private var _bitmap:Bitmap;
		private var _colorTransform:ColorTransform;
		private var _fileReference:FileReference = new FileReference();
		private var progress:ProgressBox;
		private var encoder:JPEGAsyncEncoder;
		
		public function ApplicationManager(){
		}
		
		private static var instance:ApplicationManager = null;
		public static function getInstance():ApplicationManager {
			if (ApplicationManager.instance == null) {
				ApplicationManager.instance = new ApplicationManager();
			}
			return ApplicationManager.instance;
		}
		
		public function get imageWindow():ImageWindow{
			if(_imageFile != null){
				_imageWindow = new ImageWindow(_imageFile.nativePath);	
			}			
			return _imageWindow;
		}

		public function get bitmap():Bitmap{
			return _bitmap;
		}

		public function set bitmap(value:Bitmap):void{
			_bitmap = value;
		}

		public function get imageFile():File{
			return _imageFile;
		}

		public function set imageFile(value:File):void{
			_imageFile = value;
		}
		
		public function get colorTransform():ColorTransform	{
			return _colorTransform;
		}
		
		public function set colorTransform(value:ColorTransform):void {
			_colorTransform = value;
		}

		public function saveImage():void{
			var bitmapData:BitmapData = new BitmapData(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
			bitmapData.draw(_bitmap,new Matrix(), _bitmap.transform.colorTransform);
			var bitmap : Bitmap = new Bitmap(bitmapData);
			encoder = new JPEGAsyncEncoder(90);

			encoder.PixelsPerIteration = 600;
			encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onEncodeDone);
			encoder.addEventListener(ProgressEvent.PROGRESS, encodeProgress);
			encoder.encode(bitmapData);
			//var png:PNGEncoder = new PNGEncoder();
			//var jpg:JPEGEncoder = new JPEGEncoder();
			//var ba:ByteArray = png.encode(bitmapData);
			//_fileReference.save(ba,"untitled.png");
		}
		
		private function encodeProgress(event:ProgressEvent):void {
			var percentage:String = ((event.bytesLoaded / event.bytesTotal)*100) + "%";
		}
		
		private function onEncodeDone(event:JPEGAsyncCompleteEvent):void {
			trace("encoding complete");
			var ba:ByteArray = event.ImageData;
			_fileReference.save(ba,"untitled.jpg");
		}

		

	}
}