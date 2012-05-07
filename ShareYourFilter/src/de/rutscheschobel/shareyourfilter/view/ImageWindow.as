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
		private var image:Image;
		private var bitmap:Bitmap;
		private var loader:Loader;
		
		public function ImageWindow(filePath:String){
			this.filePath = filePath;
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
			addCanvas();
			addImage(filePath);	
		}
		
		private function addCanvas():void{
			canvas = new Canvas();
			this.addElement(canvas);
		}
		
		public function addImage(nativePath:String):void{
			var file:File = ApplicationManager.getInstance().imageFile;
			loader = new Loader();
			if(file != null){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, setBitmapContent);
				loader.load(new URLRequest(encodeURI(file.nativePath)));
			}
			this.title = nativePath;			
		}
		
		private function setBitmapContent(e:Event):void{
			bitmap = Bitmap(loader.content); 
			ApplicationManager.getInstance().bitmap = bitmap;
			image = new Image();
			var ratioX:Number = 1;
			var ratioY:Number = 1;
			var maxValue:int;
			if(bitmap.width > bitmap.height){
				ratioY = bitmap.width / bitmap.height;
				maxValue =  this.parent.width * .6;
			}else{
				ratioX =  bitmap.height / bitmap.width;
				maxValue =  this.parent.height * .8;
			}
			
			image.width = maxValue / ratioX;
			image.height = maxValue / ratioY;
			image.source = bitmap;
			this.width = image.width;
			this.height = image.height;
			canvas.addChild(image);
			PopUpManager.addPopUp(this, this.parent, false);
			PopUpManager.centerPopUp(this);
		}
		
	}
}