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
			//this.parent.addEventListener(Event.RESIZE, onApplicationResize);
			addCanvas();
			addImage(filePath);	
		}
		
		private function addCanvas():void{
			canvas = new Canvas();
			this.addElement(canvas);
		}
		
		public function addImage(nativePath:String):void{
			var file:File = ApplicationManager.getInstance().imageFile;
			_loader = new Loader();
			if(file != null){
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, setBitmapContent);
				_loader.load(new URLRequest(encodeURI(file.nativePath)));
			}
			this.title = nativePath;			
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
			var ratioX:Number = 1;
			var ratioY:Number = 1;
			var maxValue:int;
			if(_bitmap.width > _bitmap.height){
				ratioY = _bitmap.width / _bitmap.height;
				maxValue =  this.parent.width * .6;
			}else{
				ratioX =  _bitmap.height / _bitmap.width;
				maxValue =  this.parent.height * .8;
			}
			_image.width = maxValue / ratioX;
			_image.height = maxValue / ratioY;
			this.width = _image.width;
			this.height = _image.height;
		}
		
		private function onApplicationResize(event:Event):void {
			setWindowSize();
		}
		
	}
}