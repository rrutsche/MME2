package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import mx.controls.Alert;

	public class ApplicationManager{
		
		private var imagePanel:ImageWindow;
		private var filterWindow:FileWindow;
		
		public function ApplicationManager(){
		}
		
		private static var instance:ApplicationManager = null;
		public static function getInstance():ApplicationManager {
			if (ApplicationManager.instance == null) {
				ApplicationManager.instance = new ApplicationManager();
			}
			return ApplicationManager.instance;
		}
		
		public function getImagePanel(filePath:String):ImageWindow{
			imagePanel = new ImageWindow(filePath);
			return imagePanel;
		}
		
		public function getFilterWindow():FileWindow{
			if(filterWindow == null){
				filterWindow = new FileWindow();
			}
			return filterWindow; 
		}
	}
}