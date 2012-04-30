package de.rutscheschobel.shareyourfilter.main{
	import de.rutscheschobel.shareyourfilter.util.BmpFilter;
	import de.rutscheschobel.shareyourfilter.view.FileWindow;
	import de.rutscheschobel.shareyourfilter.view.HistogramWindow;
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
	import mx.controls.FileSystemTree;
	import mx.controls.Image;
	import mx.controls.MenuBar;
	import mx.core.Application;
	import mx.core.WindowedApplication;
	import mx.core.mx_internal;
	import mx.events.FileEvent;
	import mx.events.MenuEvent;
	
	import spark.components.Button;
	import spark.components.TitleWindow;

	public class Main extends WindowedApplication{
		
		public var imageWindow:ImageWindow;
		public var histogram:HistogramWindow;
		public var fileWindow:FileWindow;
		public var menuBar:MenuBar;
		public var bmp:BmpFilter; 
		public var obj:Object;
		public var fileTree:FileSystemTree;
		
		public function Main(){
			
		}
		
		public function init():void{
			fileTree.addEventListener(FileEvent.FILE_CHOOSE, onFileClick);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			menuBar.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
			bmp = new BmpFilter();
		}
		
		private function menuItemClickHandler(event:MenuEvent):void{
			if(event.item.@id == "menuOpen"){
				fileWindow.visible = true;
			}else if(event.item.@id == "menuSave" && obj != null){
				bmp.makeImageRed();
			}
		}
		
		public function onDragEnter(event:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}
		
		public function onDrop(event:NativeDragEvent):void{
			
			var pattern:RegExp = /jpg|jpeg|JPG|gif|png/;
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if(pattern.test(dropfiles[0].extension)){
				setImage(dropfiles[0]);
			}else{
				Alert.show("File format not supported.");
			}
		}
		
		public function onFileClick(event:FileEvent):void{
			trace(event.file.nativePath);
			fileWindow.visible = false;
			setImage(event.file);
		}
		
		private function setImage(file:File):void{
			if(imageWindow != null){
				this.removeChild(imageWindow);
			}
			ApplicationManager.getInstance().setImageFile(file.nativePath);
			imageWindow = ApplicationManager.getInstance().getImagePanel();
			//histogram.addImage(ApplicationManager.getInstance().getImageFile().nativePath);
			if(imageWindow != null){
				this.addChild(imageWindow);
				obj = file;	
			}	
		}
	}
		
}
