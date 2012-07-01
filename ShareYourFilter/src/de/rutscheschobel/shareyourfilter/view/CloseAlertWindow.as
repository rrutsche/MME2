package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Panel;

	public class CloseAlertWindow extends Panel
	{
		public var saveButton:Button;
		public var closeButton:Button;
		
		public function CloseAlertWindow() {
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void {
			saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function onSaveClick(event:MouseEvent):void {
			ApplicationManager.getInstance().saveImage();
			PopUpManager.removePopUp(this);
		}
		
		private function onCloseClick(event:MouseEvent):void {
			PopUpManager.removePopUp(this);
		}
	}
}