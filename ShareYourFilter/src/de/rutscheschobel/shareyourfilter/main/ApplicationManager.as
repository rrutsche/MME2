package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.controls.Alert;
	import mx.controls.Image;

	public class ApplicationManager{
		
		private var _imageWindow:ImageWindow;
		private var _imageFile:File;
		private var _bitmap:Bitmap;
		
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

		
	}
}