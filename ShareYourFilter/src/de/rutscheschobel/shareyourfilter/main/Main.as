package de.rutscheschobel.shareyourfilter.main
{
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.ImageWindow;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.MouseEvent;
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
	import mx.events.MenuEvent;
	
	import spark.components.TitleWindow;

	public class Main extends WindowedApplication{
		
		public var imageWindow:ImageWindow;
		public var fileWindow:FileWindow;
		public var menuBar:MenuBar;
		
		public function Main(){
			
		}
		
		public function init():void{
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			menuBar.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
		}
		
		private function menuItemClickHandler(event:MenuEvent):void{
			if(event.item.@id == "menuOpen"){
				fileWindow.visible = true;
			}
		}
		
		public function onDragEnter(event:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}
		
		public function onDrop(event:NativeDragEvent):void{
			
			var pattern:RegExp = /jpg|jpeg|JPG|gif|png/;
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if(pattern.test(dropfiles[0].extension)){
				if(imageWindow != null){
					this.removeChild(imageWindow);
				}
				imageWindow = ApplicationManager.getInstance().getImagePanel(dropfiles[0].nativePath);
				
				this.addChild(imageWindow);
			}
		}
		
	}
}