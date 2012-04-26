package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.ImagePanel;
	
	import mx.controls.Alert;

	public class ApplicationManager{
		
		public var imagePanel:ImagePanel;
		public var application:Main;
		
		public function ApplicationManager(){
		}
		
		private static var instance:ApplicationManager = null;
		public static function getInstance():ApplicationManager {
			if (ApplicationManager.instance == null) {
				ApplicationManager.instance = new ApplicationManager();
			}
			return ApplicationManager.instance;
		}
		
		public function getImagePanel(filePath:String):ImagePanel{
			imagePanel = new ImagePanel(filePath);
			return imagePanel;
		}
	}
}