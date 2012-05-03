package de.rutscheschobel.shareyourfilter.view{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	
	public class FileWindow extends AbstractWindow{
		
		public var fileOpenOK:Button;
		public var fileOpenCancel:Button;
		
		
		public function FileWindow(){
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
			//fileOpenCancel.addEventListener(MouseEvent.CLICK, closeWindow);
		}
		
		private function closeWindow(event:MouseEvent):void{
			this.visible = false;
		}
	}
}