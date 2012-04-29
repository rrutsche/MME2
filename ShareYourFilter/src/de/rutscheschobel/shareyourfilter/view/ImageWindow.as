package de.rutscheschobel.shareyourfilter.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.FlexEvent;

	public class ImageWindow extends AbstractWindow{
		
		public var canvas:Canvas;
		public var filePath:String;
		private var image:Image;
		
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
			var img:Image = new Image();
			image = img;
			if(Capabilities.os.search("Mac") >= 0){
				img.source = "file://" + nativePath;
			} else {
				img.source = nativePath;
			}
			this.title = nativePath;
			img.maxWidth = 500;
			img.maxHeight = 500;
			
			canvas.addChild(img);
			this.setLayoutBoundsPosition(300,200,true);
		}
		
		public function getImage():Image{
			if(image != null){
				return image;
			}		
			return null;
		}
		
	}
}