package de.rutscheschobel.shareyourfilter.util
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.BevelFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.graphics.codec.JPEGEncoder;
	
	public class BmpFilter
	{
		private var fileReference:FileReference = new FileReference();
		private var pattern:RegExp = /jpg|jpeg|JPG|gif|png/;
		private var bitmapData:BitmapData;
		private var loader:Loader = new Loader;
		private var image:Bitmap;
		var newPixel = 0x000000;
		
		public function BmpFilter()
		{
		}
		
		public function makeImageRed():void{
			var file:File = ApplicationManager.getInstance().getImageFile();
			if(file != null && pattern.test(file.extension)){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteRed);
				loader.load(new URLRequest(encodeURI(file.nativePath)));
			}
		}
		
		private function onCompleteRed(e:Event):void{
			image = Bitmap(loader.content); 
			var bitmap:BitmapData = image.bitmapData;
			for(var h:int = 0; h<bitmap.height; h++){
				for(var w:int = 0; w<bitmap.width; w++){
					var r:int = (bitmap.getPixel(w,h) & 0x00ff0000) >> 16;
					var g:int = (bitmap.getPixel(w,h) & 0x0000ff00) >> 8;
					var b:int = bitmap.getPixel(w,h) & 0x000000ff;
					var brightness:int = (r + g + b) / 3;
					var hex = brightness << 16 ^ brightness << 8 ^ brightness;
					bitmap.lock();
					bitmap.setPixel(w,h,hex);
					bitmap.unlock();
				}
			}
			saveImageAsJpg(bitmap);
		}
		
		private function saveImageAsJpg(bdata:BitmapData):void{
			
			//creates a bevel filter (parameters: distance,angle,highlightColor,highlightAlpha,shadowColor,shadowAlpha,blurX,blurY,strength,quality,type,knockout ) all as type number expect 'type' (as string) and 'knockout' (as boolean)
			var filter:BevelFilter = new BevelFilter(5, 45, 0xFFFF00, .8, 0x0000FF, .8, 20, 20, 1, 3, "inner", false);
			
			//apply the bevel filter to the bitmapdata
			bdata.applyFilter(bdata, bdata.rect, new Point(0, 0), filter);
			var bitmapData:BitmapData = new BitmapData(bdata.width, bdata.height);
			bitmapData.draw(bdata,new Matrix());
			var bitmap : Bitmap = new Bitmap(bitmapData);
			var jpg:JPEGEncoder = new JPEGEncoder();
			var ba:ByteArray = jpg.encode(bitmapData);
			fileReference.save(ba,'NewRenderedJPG.jpg');
		}	
		
	}
}