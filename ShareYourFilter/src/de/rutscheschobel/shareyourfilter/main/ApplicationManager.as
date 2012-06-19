package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.event.JPEGAsyncCompleteEvent;
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	import de.rutscheschobel.shareyourfilter.util.BasicFilter;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	import de.rutscheschobel.shareyourfilter.util.JPEGAsyncEncoder;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class ApplicationManager{
		
		private var _imageWindow:ImageWindow;
		private var _imageFile:File;
		private var _bitmap:Bitmap;
		private var _basicFilter:BasicFilter = new BasicFilter();
		private var _colorTransform:ColorTransform;
		private var _fileReference:FileReference = new FileReference();
		private var _batchFiles:ArrayCollection;
		private var _encoder:JPEGAsyncEncoder;
		private var _dispatcher:CustomEventDispatcher;
		private var _fileName:String;
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
				PopUpManager.removePopUp(_imageWindow);
				_imageWindow = new ImageWindow(_imageFile.nativePath);	
			}			
			_dispatcher = CustomEventDispatcher.getInstance();
			_dispatcher.dispatchEvent(new FilterValuesChangedEvent(new FilterValueObject));
			return _imageWindow;
		}
		
		public function saveImage(name:String = "untitled.jpg", bitmapData:BitmapData = null):void {
			
			bitmapData = processScaling(bitmapData);
			_fileName = name;
			_encoder = new JPEGAsyncEncoder(90);
			_encoder.PixelsPerIteration = 1500;
			_encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onEncodeDone);
			_encoder.encode(bitmapData);
			
		}
		
		public function batchSave(name:String = "untitled.jpg", bitmapData:BitmapData = null):void {
			bitmapData = processScaling(bitmapData);
			_fileName = name;
			_encoder = new JPEGAsyncEncoder(90);
			_encoder.PixelsPerIteration = 1500;
			_encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onBatchEncodeDone);
			_encoder.encode(bitmapData);
		}
		
		private function processScaling(bitmapData:BitmapData):BitmapData {
			if (bitmapData == null) {
				bitmapData = new BitmapData(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
			}
			var scaleFactor:Number = bitmapData.width / _bitmap.bitmapData.width;
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleFactor, scaleFactor);
			bitmapData.draw(_bitmap,matrix, _bitmap.transform.colorTransform);
			return bitmapData;
		}

		private function onEncodeDone(event:JPEGAsyncCompleteEvent):void {
			var ba:ByteArray = event.ImageData;
			_fileReference.save(ba,_fileName);
		}
		
		private function onBatchEncodeDone(event:JPEGAsyncCompleteEvent):void {
			var ba:ByteArray = event.ImageData;
			var fl:File = File.desktopDirectory.resolvePath(_fileName+"_resized.jpg");
			var fs:FileStream = new FileStream();
			try{
				fs.open(fl,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		/*
		creates a new imagewindow with an image
		*/
		public function setImage(file:File):void{
			_imageFile = file;
			if(imageWindow != null){
				FlexGlobals.topLevelApplication.addChild(imageWindow);
				ServiceManager.getInstance().updateFilterList();
			}	
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
		
		public function get encoder():JPEGAsyncEncoder {
			return _encoder;
		}
		public function get basicFilter():BasicFilter {
			return _basicFilter;
		}

		public function get batchFiles():ArrayCollection {
			return _batchFiles;
		}

		public function set batchFiles(value:ArrayCollection):void {
			_batchFiles = value;
		}

	}
}