package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class ImageWindow extends AbstractWindow{
		
		public var canvas:Canvas;
		public var filePath:String;
		private var _image:Image;
		private var _bitmap:Bitmap;
		private var _loader:Loader;
		
		public function ImageWindow(filePath:String){
			this.filePath = filePath;
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
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
			this.title = file.name;			
		}
		
		private function setBitmapContent(e:Event):void{
			_bitmap = Bitmap(_loader.content); 
			ApplicationManager.getInstance().bitmap = _bitmap;
			_image = new Image();
			_image.source = _bitmap;
			setWindowSize(_bitmap);
			canvas.addChild(_image);
			
			PopUpManager.addPopUp(this, this.parent, false);
			PopUpManager.centerPopUp(this);
		}
		
		private function setWindowSize(bitmap:Bitmap):void {
			
			if(bitmap.width > bitmap.height) {
				_image.width = parent.width * 0.6;
				_image.height = (_image.width / bitmap.width ) * bitmap.height;
			} else {
				_image.height = parent.height * 0.8;
				_image.width = (_image.height / bitmap.height) * bitmap.width;
			}
		}
		
		private function onApplicationResize(event:Event):void {
			setWindowSize(ApplicationManager.getInstance().bitmap);
		}
		
	}
}