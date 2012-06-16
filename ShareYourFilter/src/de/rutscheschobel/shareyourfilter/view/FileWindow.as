package de.rutscheschobel.shareyourfilter.view{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.FileSystemTree;
	import mx.events.FileEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	
	public class FileWindow extends AbstractWindow{
		
		public var fileOpenOK:Button;
		public var fileOpenCancel:Button;
		public var fileTree:FileSystemTree;
		
		
		public function FileWindow(){
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
			fileOpenCancel.addEventListener(MouseEvent.CLICK, closeWindow);
			fileTree.addEventListener(FileEvent.FILE_CHOOSE, onFileClick);
		}
		
		/*
		*	opens a file
		*/
		public function onFileClick(event:FileEvent):void{
			PopUpManager.removePopUp(this);
			if(event.file != null){
				ApplicationManager.getInstance().setImage(event.file);
			}
		}
		
		private function closeWindow(event:MouseEvent):void{
			PopUpManager.removePopUp(this);
		}
	}
}