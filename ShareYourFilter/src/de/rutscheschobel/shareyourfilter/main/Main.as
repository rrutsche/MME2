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
	import mx.controls.MenuBar;
	import mx.core.Application;
	import mx.core.WindowedApplication;

	public class Main extends WindowedApplication{
		
		public var imagePanel:ImagePanel;
		public var menuBar:MenuBar;
		
		public function Main(){
			
		}
		
		public function init():void{
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,onDragExit);
			addStageElements();
		}
		
		private function addStageElements():void{
			menuBar = new MenuBar();
		}
		
		
		
		public function onDragEnter(event:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}
		
		public function onDrop(event:NativeDragEvent):void{
			
			var pattern:RegExp = /jpg|jpeg|JPG|gif|png/;
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if(pattern.test(dropfiles[0].extension)){
				if(imagePanel != null){
					this.removeChild(imagePanel);
				}
				imagePanel = ApplicationManager.getInstance().getImagePanel(dropfiles[0].nativePath);
				
				this.addChild(imagePanel);
			}
		}
		
		public function onDragExit(event:NativeDragEvent):void{
			trace("Drag exit event.");
		}
		
		
	}
}