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
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;

	public class ImageSaveHelperClass {
		
		private var _fileName:String;
		private var _encoder:JPEGAsyncEncoder;
		private var _bitmap:Bitmap;
		private var _batchBitmaps:Array;
		private var _folder:File;
		
		public var progressBox:ProgressBox;
		
		
		public function ImageSaveHelperClass() {	
			_bitmap = ApplicationManager.getInstance().bitmap;
		}
		
		/**
		 * Saves the bitmapData as jpeg File
		 * @param name Name of the File, daefault = untitled
		 * @param bitmapData 
		 */
		public function saveImage(name:String = "untitled.jpg", bitmapData:BitmapData = null):void {
			bitmapData = processScaling(bitmapData);
			_fileName = name;
			_encoder = new JPEGAsyncEncoder(90);
			_encoder.PixelsPerIteration = 1500;
			_encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onEncodeDone);
			_encoder.encode(bitmapData);
			setProgressBox();
		}
		
		/**
		 * Opens a dialog when the encoding is done
		 * @param event
		 */
		private function onEncodeDone(event:JPEGAsyncCompleteEvent):void {
			var ba:ByteArray = event.ImageData;
			var fileReference:FileReference = new FileReference();
			fileReference.save(ba,_fileName);
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