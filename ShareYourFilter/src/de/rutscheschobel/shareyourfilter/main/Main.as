package de.rutscheschobel.shareyourfilter.main{
	import de.rutscheschobel.shareyourfilter.util.*;
	import de.rutscheschobel.shareyourfilter.view.*;
	import de.rutscheschobel.shareyourfilter.view.components.BasicFilterControlWindow;
	import de.rutscheschobel.shareyourfilter.view.components.ProgressBox;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.controls.FileSystemTree;
	import mx.controls.MenuBar;
	import mx.core.WindowedApplication;
	import mx.events.FileEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;

	public class Main extends WindowedApplication{
		
		public var imageWindow:ImageWindow;
		public var fileWindow:FileWindow;
		public var menuBar:MenuBar;
		public var fileTree:FileSystemTree;
		public var progressBox:ProgressBox;
		
		public function Main(){
			
		}
		
		public function init():void{
			fileTree.addEventListener(FileEvent.FILE_CHOOSE, onFileClick);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragEnter);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			menuBar.addEventListener(MenuEvent.ITEM_CLICK, menuItemClickHandler);
		}
		
		
		private function menuItemClickHandler(event:MenuEvent):void{
			if(event.item.@id == "menuOpen"){
				fileWindow.visible = true;
			}else if(event.item.@id == "menuSave"){
				ApplicationManager.getInstance().saveImage();
				setProgressBox();
			}
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
			}	
		}
		
		private function setProgressBox():void{
			progressBox = PopUpManager.createPopUp(this, ProgressBox) as ProgressBox;
			PopUpManager.centerPopUp(progressBox);
			ApplicationManager.getInstance().encoder.addEventListener(ProgressEvent.PROGRESS, encodeProgress);
		}
		
		private function encodeProgress(event:ProgressEvent):void {
			progressBox.progBar.setProgress(event.bytesLoaded, event.bytesTotal);
			progressBox.progBar.label = (event.bytesLoaded / event.bytesTotal * 100).toFixed() + "%" + " Complete";
			if(event.bytesLoaded / event.bytesTotal * 100 >= 100){
				PopUpManager.removePopUp(progressBox);
			}
		}
	}
		
}
