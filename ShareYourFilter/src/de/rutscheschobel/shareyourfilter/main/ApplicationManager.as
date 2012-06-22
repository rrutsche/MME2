package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.util.BasicFilter;
	import de.rutscheschobel.shareyourfilter.util.ImageSaveHelperClass;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class ApplicationManager {
		
		private var _imageWindow:ImageWindow;
		private var _imageFile:File;
		private var _bitmap:Bitmap;
		private var _basicFilter:BasicFilter = new BasicFilter();
		private var _batchFiles:ArrayCollection;
		private var _dispatcher:CustomEventDispatcher;
		
		public function ApplicationManager(){
		}
		
		private static var instance:ApplicationManager = null;
		public static function getInstance():ApplicationManager {
			if (ApplicationManager.instance == null) {
				ApplicationManager.instance = new ApplicationManager();
			}
			return ApplicationManager.instance;
		}
		
		/**
		 * Returns the active imageWindow, creates a new when its null
		 * @return  ImageWindow
		 * 
		 */		
		public function get imageWindow():ImageWindow {
			if(_imageFile != null){
				PopUpManager.removePopUp(_imageWindow);
				_imageWindow = new ImageWindow(_imageFile.nativePath);	
			}			
			_dispatcher = CustomEventDispatcher.getInstance();
			_dispatcher.dispatchEvent(new FilterValuesChangedEvent());
			return _imageWindow;
		}
		
		/**
		 * 
		 * @param name name of the file (optional)
		 * @param bitmapData (optional)
		 * 
		 */
		public function saveImage(name:String = "untitled.jpg", bitmapData:BitmapData = null):void {
			var imageSaver:ImageSaveHelperClass = new ImageSaveHelperClass();
			imageSaver.saveImage(name,bitmapData);
		}
		
		/**
		 * Starts the batch saving process 
		 * @param array bitmap files
		 * 
		 */
		public function batchSave(array:Array):void {
			var imageSaver:ImageSaveHelperClass = new ImageSaveHelperClass();
			imageSaver.batchSave(array);
		}
		
		/**
		 * creates a new imagewindow with an image
		 * @param file
		 * 
		 */
		public function setImage(file:File):void{
			_imageFile = file;
			if(imageWindow != null){
				FlexGlobals.topLevelApplication.addChild(imageWindow);
			}	
		}
		
		/**
		 * Getter and Setter
		 */	
		
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