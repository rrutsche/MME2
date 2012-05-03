package de.rutscheschobel.shareyourfilter.util{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	public class BasicFilter{
		
		private var _bitmap:Bitmap;
		private var _colorTransform:ColorTransform;
		private var _filtersArray:Array;
		private var _brightnessArray:Array;
		private var _blur:BlurFilter;
		private var randomBack:Array;		
		private var cmfContrast:ColorMatrixFilter;
		private var cmfSaturation:ColorMatrixFilter;
		private var cmfNegative:ColorMatrixFilter;
		private var cmfRandom:ColorMatrixFilter;
		private var cmfBlur:ColorMatrixFilter;
		
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
			
		public function setBlur(value:Number):void{
			_bitmap = ApplicationManager.getInstance().bitmap;
			var blurArray:Array = new Array();
			if(_bitmap != null){
				_blur = new BlurFilter();
				_blur.blurX = value/10;
				_blur.blurY = value/10;
				blurArray.push([_blur]);
				cmfBlur = new ColorMatrixFilter(blurArray);
				applyFilter();
			}
		}
		
		public function setRandom(random:Array):void{
			_bitmap = ApplicationManager.getInstance().bitmap;
			if(_bitmap != null){
				cmfRandom = new ColorMatrixFilter(random);
				applyFilter();
			}
		}
		
		public function setNegative(value:Boolean):void{
			_bitmap = ApplicationManager.getInstance().bitmap;
			if(value){
				trace("true");
				cmfNegative = new ColorMatrixFilter([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]);	
			}else{
				trace("false");
				cmfNegative = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);	
			}
			applyFilter();
		}
		
		private function applyFilter():void{
			_filtersArray = new Array();
			if(cmfSaturation != null){
				_filtersArray.push(cmfSaturation);
			}
			if(cmfContrast != null){
				_filtersArray.push(cmfContrast);
			}
			if(cmfNegative != null){
				_filtersArray.push(cmfNegative);
			}
			if(cmfRandom != null){
				_filtersArray.push(cmfRandom);
			}
			if(_blur != null){
				_filtersArray.push(cmfBlur);
			}
			_bitmap.filters = _filtersArray;
		}
		
		public function generateRandomNumberArray():Array{
			var random:Array = [Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), 
								Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), 
								Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), 
								Math.random(), Math.random(), Math.random(), Math.random(), Math.random()];
			return random;
		}
		
	}
}