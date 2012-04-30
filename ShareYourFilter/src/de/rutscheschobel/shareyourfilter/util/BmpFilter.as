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
	import flash.geom.Matrix;
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
		
		public function BmpFilter()
		{
		}
		
		public function makeImageBW():void{
			var file:File = ApplicationManager.getInstance().getImageFile();
			if(file != null && pattern.test(file.extension)){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteBW);
				loader.load(new URLRequest(encodeURI(file.nativePath)));
			}
		}
		
		private function onCompleteBW(e:Event):void{
			var rgb:Array;
			image = Bitmap(loader.content); 
			var bitmap:BitmapData = image.bitmapData;
//			bitmap.noise(2,127,199,7,false);
			bitmap.perlinNoise(97,87,6,17,true,true,2,false,null);
			for(var h:int = 0; h<bitmap.height; h++){
				for(var w:int = 0; w<bitmap.width; w++){
					
//					rgb = getRGB(bitmap.getPixel(w,h));
//					var brightness:int = (rgb[0] + rgb[1] + rgb[2]) / 3;
//					var hex = brightness << 16 ^ brightness << 8 ^ brightness;
//					bitmap.lock();
//					bitmap.setPixel(w,h,hex);
//					bitmap.unlock();
				}
			}
			saveImageAsJpg(bitmap);
		}
		
		private function saveImageAsJpg(bdata:BitmapData):void{
			var bitmapData:BitmapData = new BitmapData(bdata.width, bdata.height);
			bitmapData.draw(bdata,new Matrix());
			var bitmap : Bitmap = new Bitmap(bitmapData);
			var jpg:JPEGEncoder = new JPEGEncoder();
			var ba:ByteArray = jpg.encode(bitmapData);
			fileReference.save(ba,'NewRenderedJPG.jpg');
		}
		
		private function getRGB(pixel:int):Array{
			var back:Array = new Array;
			var r:int = (pixel & 0x00ff0000) >> 16;
			var g:int = (pixel & 0x0000ff00) >> 8;
			var b:int =  pixel & 0x000000ff;
			back[0] = r;
			back[1] = g;
			back[2] = b;
			return back;
		}
	}
}