package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.ImagePanel;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.WindowedApplication;

	public class Main extends WindowedApplication{
		
		public var imagePanel:ImagePanel;
		
		public function Main(){
			
		}
		
		public function init():void{
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,onDragExit);
		}
		
		private function addImagePanel(filePath:String):void{
			imagePanel = new ImagePanel(filePath);
			this.addChild(imagePanel);
		}
		
		public function onDragEnter(event:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}
		
		public function onDrop(event:NativeDragEvent):void{
			
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each (var file:File in dropfiles){
				switch (file.extension){ 
					case "png" :
						addImagePanel(file.nativePath);
						break;
					case "jpg" :
						addImagePanel(file.nativePath);
						break;
					case "jpeg" :
						addImagePanel(file.nativePath);
						break;
					case "JPG" :
						addImagePanel(file.nativePath);
						break;
					case "gif" :
						addImagePanel(file.nativePath);
						break;
					default:
						Alert.show("Unmapped Extension");
				}
			} 
		}
		
		public function onDragExit(event:NativeDragEvent):void{
			trace("Drag exit event.");
		}
		
		
	}
}