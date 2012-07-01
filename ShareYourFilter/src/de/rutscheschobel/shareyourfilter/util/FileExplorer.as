package de.rutscheschobel.shareyourfilter.util
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;

	public class FileExplorer
	{
		private var file:File;
		private var imageFileFilter:FileFilter;
		private var fileFilters:Array;
		
		public function FileExplorer()
		{
			init();
		}
		private function init():void {
			imageFileFilter = new FileFilter("Images", "*.jpg;*.jpeg;*.JPG;*.gif;*.png");
			fileFilters = new Array();
			fileFilters.push(imageFileFilter);
		}
		
		public function openFile():void {
			file = new File();
			file.addEventListener(Event.SELECT, onFileClick);
			file.browse(fileFilters);
		}
		
		private function onFileClick(event:Event):void {
			ApplicationManager.getInstance().setImage(event.target as File);
		}
		
		public function saveFile(name:String, bitmapData:BitmapData):void {
			var imageSaver:ImageSaveHelper = new ImageSaveHelper();
			imageSaver.saveImage(name,bitmapData);
		}
		
		/**
		 * 
		 * @param array
		 * 
		 */
		public function batchSave(array:Array):void {
			var imageSaver:ImageSaveHelper = new ImageSaveHelper();
			imageSaver.batchSave(array);
		}
	}
}