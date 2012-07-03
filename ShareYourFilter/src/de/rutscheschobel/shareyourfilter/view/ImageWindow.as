package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.view.components.CloseAlertComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class ImageWindow extends AbstractWindow{
		
		public var canvas:Canvas;
		public var filePath:String;
		public var _filename:String;
		private var _image:Image;
		private var _bitmap:Bitmap;
		private var _loader:Loader;
		private var size:Number;
		
		public function ImageWindow(filePath:String){
			this.filePath = filePath;
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
			this.closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
			this.parent.addEventListener(Event.RESIZE, onApplicationResize);
			addCanvas();
			addImage();	
		}
		
		private function addCanvas():void{
			canvas = new Canvas();
			this.addElement(canvas);
		}
		
		public function addImage():void{
			var file:File = ApplicationManager.getInstance().imageFile;
			_loader = new Loader();
			if(file != null){
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, setBitmapContent);
				_loader.load(new URLRequest(encodeURI(file.nativePath)));
			}
			_filename = file.name;
			this.title = _filename;			
		}
		
		private function setBitmapContent(e:Event):void{
			_bitmap = Bitmap(_loader.content); 
			ApplicationManager.getInstance().bitmap = _bitmap;
			_image = new Image();
			_image.source = _bitmap;
			setWindowSize();
			canvas.addChild(_image);
			PopUpManager.addPopUp(this, this.parent, false);
			PopUpManager.centerPopUp(this);
		}
		
		private function setWindowSize():void {
			
			var bitmap:Bitmap = ApplicationManager.getInstance().bitmap;
			if(bitmap.width > bitmap.height) {
				_image.width = parentApplication.width * 0.6;
				_image.height = (_image.width / bitmap.width ) * bitmap.height;
			} else {
				_image.height = parentApplication.height * 0.8;
				_image.width = (_image.height / bitmap.height) * bitmap.width;
			}
			this.title = _filename + " " + Math.round(_image.width / bitmap.width * 100)+"%";
			
		}
		
		private function onApplicationResize(event:Event):void {
			setWindowSize();
		}
		
		private function closeWindow(event:MouseEvent):void {
			var closeAlert:CloseAlertWindow = PopUpManager.createPopUp(this.parent, CloseAlertComponent, true) as CloseAlertComponent;
			PopUpManager.centerPopUp(closeAlert);
			ApplicationManager.getInstance().bitmap = null;
			this.visible = false;
		}
		
	}
}