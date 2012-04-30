package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.controls.Alert;
	import mx.controls.Image;

	public class ApplicationManager{
		
		private var imagePanel:ImageWindow;
		private var imageFile:File;
		private var imageBitmapData:BitmapData;
		
		public function ApplicationManager(){
		}
		
		private static var instance:ApplicationManager = null;
		public static function getInstance():ApplicationManager {
			if (ApplicationManager.instance == null) {
				ApplicationManager.instance = new ApplicationManager();
			}
			return ApplicationManager.instance;
		}
		
		public function getImagePanel():ImageWindow{
			if(imageFile != null){
				imagePanel = new ImageWindow(imageFile.nativePath);	
			}			
			return imagePanel;
		}
		
		public function setImageFile(filePath:String):void{
			if(imageFile == null){
				imageFile = new File();
			}
			imageFile = new File(filePath);
		}
		
		public function getImageFile():File{
			return imageFile;
		}
		
		public function getImageBitmapData():BitmapData{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				
			});
			loader.load(new URLRequest(encodeURI(imageFile.nativePath)));
			return imageBitmapData;
		}
	}
}