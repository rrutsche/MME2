package de.rutscheschobel.shareyourfilter.util{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	public class BasicFilter{
		
		private var _bitmap:Bitmap;
		private var _colorTransform:ColorTransform;
		private var _filtersArray:Array;
		private var _brightnessArray:Array; // = new Array();
		private var cmfContrast:ColorMatrixFilter;
		private var cmfSaturation:ColorMatrixFilter;
		
		public function BasicFilter(){
		}
		
		public function setBrightness(value:Number):void{
			_bitmap = ApplicationManager.getInstance().bitmap;
			if(_bitmap != null){
				_colorTransform = new ColorTransform();
				_colorTransform.redOffset = value;
				_colorTransform.greenOffset = value;
				_colorTransform.blueOffset = value;
				_bitmap.transform.colorTransform = _colorTransform;
			}
		}
		
		public function setContrast(value:Number):void {
			_bitmap = ApplicationManager.getInstance().bitmap;
			var factor:Number = value / 500;
			//Formula taken from the Actionscript 3 Cookbook by Joey Lott, Darron Schall and Keith Peters
			if(_bitmap != null){
				var a:Number = factor * 11;
				var b:Number = 63.5 - (factor * 698.5);
				cmfContrast = new ColorMatrixFilter([a, 0, 0, 0, b, 0, a, 0, 0, b, 0, 0, a, 0, b, 0, 0, 0, 1, 0]);
				applyFilter();
			}
		}
		
		public function setSaturation(value:Number):void{
			var contrast_factor:Number = value / 100;
			_bitmap = ApplicationManager.getInstance().bitmap;
			if(_bitmap != null){
				var red:Number = 0.3086; // luminance contrast value for red
				var green:Number = 0.694; // luminance contrast value for green
				var blue:Number = 0.0820; // luminance contrast value for blue
				var a:Number = (1-contrast_factor) * red + contrast_factor;
				var b:Number = (1-contrast_factor) * green;
				var c:Number = (1-contrast_factor) * blue;
				var d:Number = (1-contrast_factor) * red;
				var e:Number = (1-contrast_factor) * green + contrast_factor;
				var f:Number = (1-contrast_factor) * blue;
				var g:Number = (1-contrast_factor) * red ;
				var h:Number = (1-contrast_factor) * green;
				var i:Number = (1-contrast_factor) * blue + contrast_factor;
				cmfSaturation = new ColorMatrixFilter([a, b, c, 0, 0, d, e, f, 0, 0, g, h, i, 0 ,0, 0, 0, 0, 1, 0]);
				applyFilter();
			}
		}
		
		private function applyFilter():void{
			_filtersArray = new Array();
			if(cmfSaturation != null){
				_filtersArray.push(cmfSaturation);
			}
			if(cmfContrast != null){
				_filtersArray.push(cmfContrast);
			}
			_bitmap.filters = _filtersArray;
			
		}
		
	}
}