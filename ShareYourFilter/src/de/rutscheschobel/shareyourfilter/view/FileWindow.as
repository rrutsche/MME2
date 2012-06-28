package de.rutscheschobel.shareyourfilter.view{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.controls.FileSystemTree;
	import mx.controls.List;
	import mx.events.FileEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	
	public class FileWindow extends AbstractWindow{
		
		public var fileOpenOK:Button;
		public var fileOpenCancel:Button;
		public var fileTree:FileSystemTree;
		private var file:File;
		
		
		public function FileWindow(){
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
			fileOpenCancel.addEventListener(MouseEvent.CLICK, closeWindow);
			fileOpenOK.addEventListener(MouseEvent.CLICK, openFile);
			fileTree.addEventListener(FileEvent.FILE_CHOOSE, onFileClick);
			fileTree.addEventListener(Event.CHANGE, onChange);
		}
		
		/*
		*	opens a file
		*/
		public function onFileClick(event:FileEvent):void{
			PopUpManager.removePopUp(this);
			if(event.file != null){
				file = event.file;
				ApplicationManager.getInstance().setImage(event.file);
			}
		}
		
		private function closeWindow(event:MouseEvent):void{
			PopUpManager.removePopUp(this);
		}
		
		private function openFile(event:MouseEvent):void {
			if (file != null) {
				ApplicationManager.getInstance().setImage(file);
				PopUpManager.removePopUp(this);
			}
		}
		
		private function onChange(e:Event):void {
			file = List(e.currentTarget).selectedItem as File;
		}
	}
}