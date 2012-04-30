package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import flash.filesystem.File;
	
	import mx.controls.Alert;

	public class ApplicationManager{
		
		private var imagePanel:ImageWindow;
		private var filterWindow:FileWindow;
		private var imageFile:File;
		
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
		
		public function getFilterWindow():FileWindow{
			if(filterWindow == null){
				filterWindow = new FileWindow();
			}
			return filterWindow; 
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
	}
}