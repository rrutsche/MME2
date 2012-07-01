package de.rutscheschobel.shareyourfilter.util {
	
	import de.rutscheschobel.shareyourfilter.event.JPEGAsyncCompleteEvent;
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.view.components.ProgressBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;

	public class ImageSaveHelper {
		
		private var _fileName:String;
		private var _encoder:JPEGAsyncEncoder;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _batchBitmaps:Array;
		private var _folder:File;
		private var _file:File;
		
		public var progressBox:ProgressBox;
		
		
		public function ImageSaveHelper() {	
			_bitmap = ApplicationManager.getInstance().bitmap;
		}
		
		/**
		 * Saves the bitmapData as jpeg File
		 * @param name Name of the File, daefault = untitled
		 * @param bitmapData 
		 */
		public function saveImage(name:String = "untitled.jpg", bitmapData:BitmapData = null):void {
			trace("saveImage");
			_bitmapData = processScaling(bitmapData);
			if (_bitmapData == null) {
				Alert.show("no file selected");
				return;
			}
			_fileName = name;
			_file = new File();
			_file.addEventListener(Event.SELECT, onFileSelected);
			_file.browseForSave("Choose a directoy to save the image");
		}
		
		private function onFileSelected(e:Event):void {
			_fileName = (e.target as File).nativePath;
			_encoder = new JPEGAsyncEncoder(90);
			_encoder.PixelsPerIteration = 1500;
			_encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onEncodeDone);
			_encoder.encode(_bitmapData);
			setProgressBox();
		}
		
		/**
		 * Opens a dialog when the encoding is done
		 * @param event
		 */
		private function onEncodeDone(event:JPEGAsyncCompleteEvent):void {
			var ba:ByteArray = event.ImageData;
			var fl:File = _file.resolvePath(_fileName+".jpg");
			var fs:FileStream = new FileStream();
			try{
				fs.open(fl,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		/**
		 * Saves multiple bitmaps as jpeg files
		 * @param array
		 */
		public function batchSave(array:Array):void {
			_batchBitmaps = array;
			_folder = new File();
			_folder.addEventListener(Event.SELECT, onFolderSelected);
			_folder.browseForDirectory("Choose a Directory");
		}
		
		/**
		 * Starts the batch process when the target folder was clicked
		 * @param e
		 */
		private function onFolderSelected(e:Event):void {
			processBatchEncoding();
		}
		
		private function processBatchEncoding():void {
			_bitmap = _batchBitmaps.pop();
			var bitmapData:BitmapData = new BitmapData(_bitmap.width, _bitmap.height);
			bitmapData = processScaling(bitmapData);
			_fileName = "batch"+_batchBitmaps.length;
			_encoder = new JPEGAsyncEncoder(90);
			_encoder.PixelsPerIteration = 1500;
			_encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onBatchEncodeDone);
			_encoder.encode(bitmapData);
			setProgressBox();
		}
		
		/**
		 * Resizes the given bitmapData
		 * @param bitmapData
		 * @return scaled bitmapData
		 * 
		 */
		private function processScaling(bitmapData:BitmapData):BitmapData {
			if (bitmapData == null) {
				if (_bitmap == null) {
					return null;
				}
				bitmapData = new BitmapData(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
			}
			var scaleFactor:Number = bitmapData.width / _bitmap.bitmapData.width;
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleFactor, scaleFactor);
			bitmapData.draw(_bitmap,matrix, _bitmap.transform.colorTransform);
			return bitmapData;
		}
		
		/**
		 * 
		 * @param event
		 */
		private function onBatchEncodeDone(event:JPEGAsyncCompleteEvent):void {
			var ba:ByteArray = event.ImageData;
			var fl:File = _folder.resolvePath(_fileName+"_resized.jpg");
			var fs:FileStream = new FileStream();
			try{
				fs.open(fl,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
			if (_batchBitmaps.length > 0) {
				processBatchEncoding();
			}
		}
		
		/**
		 * 
		 */
		private function setProgressBox():void{
			progressBox = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, ProgressBox) as ProgressBox;
			PopUpManager.centerPopUp(progressBox);
			_encoder.addEventListener(ProgressEvent.PROGRESS, encodeProgress);
		}
		
		/**
		 * 
		 * @param event
		 */
		private function encodeProgress(event:ProgressEvent):void {
			progressBox.progBar.setProgress(event.bytesLoaded, event.bytesTotal);
			progressBox.progBar.label = (event.bytesLoaded / event.bytesTotal * 100).toFixed() + "%" + " Complete";
			if(event.bytesLoaded / event.bytesTotal * 100 >= 100){
				PopUpManager.removePopUp(progressBox);
			}
		}
	}
}