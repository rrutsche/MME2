package de.rutscheschobel.shareyourfilter.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.FlexEvent;

	public class ImagePanel extends Panel{
		
		public var canvas:Canvas;
		public var filePath:String;
		
		public function ImagePanel(filePath:String){
			this.filePath = filePath;
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void{
			this.titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.titleBar.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMouseUp);
			addCanvas();
			addImage(filePath);			
		}
		
		private function onMouseDown(event:MouseEvent):void{
			this.startDragging(event);
		}
		
		private function onMouseUp(event:MouseEvent):void{
			this.stopDragging();
		}
		
		private function addCanvas():void{
			canvas = new Canvas();
			this.addChild(canvas);
		}
		
		public function addImage(nativePath:String):void{
			var img:Image = new Image();
			if(Capabilities.os.search("Mac") >= 0){
				img.source = "file://" + nativePath;
			} else {
				img.source = nativePath;
			}
			this.title = nativePath;
			this.width = 500;
			this.height = 500;
			canvas.width = this.getLayoutBoundsWidth();
			canvas.height = this.getLayoutBoundsHeight();
			img.width = canvas.width;
			img.height = canvas.height;
			canvas.addChild(img);
			this.setLayoutBoundsPosition(300,200,true);
		}
		
	}
}