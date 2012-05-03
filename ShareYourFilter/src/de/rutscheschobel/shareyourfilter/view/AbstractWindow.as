package de.rutscheschobel.shareyourfilter.view{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.TitleWindow;
	import spark.events.TitleWindowBoundsEvent;

	public class AbstractWindow extends TitleWindow{
		
		public function AbstractWindow(){
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);			
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			this.isPopUp = true;
			this.maintainProjectionCenter = true;
			this.closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
		}

		private function closeWindow(event:MouseEvent):void{
			this.visible = false;
		}
		
	}
}