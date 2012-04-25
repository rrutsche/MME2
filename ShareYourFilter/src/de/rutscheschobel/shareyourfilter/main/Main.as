package de.rutscheschobel.shareyourfilter.main
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.WindowedApplication;

	public class Main extends WindowedApplication{
		
		public var imageContainer:Canvas;
		public function Main()
		{
		}
		
		public function init():void{
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,onDragExit);
			addStageElements();
		}
		
		private function addStageElements():void{
			this.addChild(imageContainer);
		}
		
		public function onDragEnter(event:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}
		
		public function onDrop(event:NativeDragEvent):void{
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each (var file:File in dropfiles){
				switch (file.extension){ 
					case "png" :
						addImage(file.nativePath);
						break;
					case "jpg" :
						addImage(file.nativePath);
						break;
					case "jpeg" :
						addImage(file.nativePath);
						break;
					case "JPG" :
						addImage(file.nativePath);
						break;
					case "gif" :
						addImage(file.nativePath);
						break;
					default:
						Alert.show("Unmapped Extension");
				}
			} 
		}
		
		public function onDragExit(event:NativeDragEvent):void{
			trace("Drag exit event.");
		}
		
		private function addImage(nativePath:String):void{
			var img:Image = new Image();
			img.width = imageContainer.width;
			img.height = imageContainer.height;
			if(Capabilities.os.search("Mac") >= 0){
				img.source = "file://" + nativePath;
			} else {
				img.source = nativePath;
			}
			imageContainer.addChild(img);
		}
	}
}