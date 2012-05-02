package de.rutscheschobel.shareyourfilter.main{
	import de.rutscheschobel.shareyourfilter.util.*;
	import de.rutscheschobel.shareyourfilter.view.*;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
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
	import mx.events.SliderEvent;
	
	import spark.components.Button;
	import spark.components.HSlider;
	import spark.components.TitleWindow;

	public class Main extends WindowedApplication{
		
		public var imageWindow:ImageWindow;
		public var fileWindow:FileWindow;
		public var menuBar:MenuBar;
		public var bmp:BmpFilter; 
		public var obj:Object;
		public var fileTree:FileSystemTree;
		public var filterControlWindow:FilterControlWindow;
		public var filterBrightnessSlider:HSlider;
		public var filterContrastSlider:HSlider;
		public var filter:BasicFilter;
		
		public function Main(){
			
		}
		
		public function init():void{
			fileTree.addEventListener(FileEvent.FILE_CHOOSE, onFileClick);
			filterBrightnessSlider.addEventListener(Event.CHANGE, onBrightnessFilterControlChange);
			filterContrastSlider.addEventListener(Event.CHANGE, onContrastFilterControlChange);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			menuBar.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
			bmp = new BmpFilter();
			filter = new BasicFilter();
		}
		
		private function menuItemClickHandler(event:MenuEvent):void{
			if(event.item.@id == "menuOpen"){
				fileWindow.visible = true;
			}else if(event.item.@id == "menuSave" && obj != null){
				ApplicationManager.getInstance().saveImage();
			}
		}
		/*
		 * FILTER CONTROL
		 */
		private function onBrightnessFilterControlChange(event:Event):void{
			filter.setBrightness((event.target as HSlider).value);
		}
		private function onContrastFilterControlChange(event:Event):void{
			filter.setContrast((event.target as HSlider).value);
		}
		
		/*
		 * FILE OPEN
		 */
		public function onDragEnter(event:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}
		public function onDrop(event:NativeDragEvent):void{
			
			var pattern:RegExp = /jpg|jpeg|JPG|gif|png/;
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if(dropfiles[0] != null && pattern.test(dropfiles[0].extension)){
				setImage(dropfiles[0]);
			}else{
				Alert.show("File format not supported.");
			}
		}
		/*
		 *	opens a file via menubar
		 */
		public function onFileClick(event:FileEvent):void{
			fileWindow.visible = false;
			if(event.file != null){
				setImage(event.file);
			}
		}
		/*
			creates a new imagewindow with an image
		*/
		private function setImage(file:File):void{
			if(imageWindow != null){
				this.removeChild(imageWindow);
			}
			ApplicationManager.getInstance().imageFile = file;
			imageWindow = ApplicationManager.getInstance().imageWindow;
			if(imageWindow != null){
				this.addChild(imageWindow);
				obj = file;	
			}	
		}
	}
		
}
