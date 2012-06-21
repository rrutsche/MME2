package de.rutscheschobel.shareyourfilter.view
{
	
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.main.Main;
	import de.rutscheschobel.shareyourfilter.view.components.ProgressBox;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class ResizeWindow extends AbstractWindow
	{
		public function ResizeWindow()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public var resizeButton:Button;
		public var resizeHeight:TextInput;
		public var resizeWidth:TextInput;
		private var _bitmap:Bitmap;
		private var _loader:Loader;
		private var _scaleFactor:Number;
		public var progressBox:ProgressBox;
		private var _batchBitmaps:Array;
		
		private function init(event:FlexEvent):void{
			_batchBitmaps = new Array();
			resizeButton.addEventListener(MouseEvent.CLICK, onResizeButtonChange);
		}
		
		private function onResizeButtonChange(event:Event):void{
			trace("mein name ist otter");
			if(ApplicationManager.getInstance().bitmap != null){
				processBitmap();
				PopUpManager.removePopUp(this);
			}
		}
		
		private function processBitmap():void {
			_bitmap = ApplicationManager.getInstance().bitmap;
			var width:int = int(resizeWidth.text);
			var height:int = int(resizeHeight.text);
			var isLandscape:Boolean = _bitmap.width >= _bitmap.height;
			if (width < _bitmap.width && isLandscape) {
				_scaleFactor = _bitmap.width / width;
				_bitmap.width = width;
				_bitmap.height = _bitmap.height / _scaleFactor;
			} else {
				_scaleFactor = _bitmap.bitmapData.height / height;
				_bitmap.width = _bitmap.width / _scaleFactor;
				_bitmap.height =height;
			}
			_batchBitmaps.push(_bitmap);
			ApplicationManager.getInstance().batchSave(_batchBitmaps);
		}
	}
}