package de.rutscheschobel.shareyourfilter.util{
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	public class BasicFilter{
		
		private var _bitmap:Bitmap;
		private var _colorTransform:ColorTransform;
		private var _filtersArray:Array;
		private var _brightnessArray:Array;
		private var randomBack:Array;		
		private var cmfContrast:ColorMatrixFilter;
		private var cmfSaturation:ColorMatrixFilter;
		private var cmfNegative:ColorMatrixFilter;
		private var cmfRandom:ColorMatrixFilter;
		private var cmfRed:ColorMatrixFilter;
		private var cmfGreen:ColorMatrixFilter;
		private var cmfBlue:ColorMatrixFilter;
		private var _filterValueObject:FilterValueObject;
		private var dispatcher:CustomEventDispatcher;
		
		public function BasicFilter(){
		}
		
		
		public function setBrightness(value:Number, bitmap:Bitmap = null):void{
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
			if(_bitmap != null){
				_colorTransform = new ColorTransform();
				_colorTransform.redOffset = value;
				_colorTransform.greenOffset = value;
				_colorTransform.blueOffset = value;
				_bitmap.transform.colorTransform = _colorTransform;
			}
		}
		
		public function setContrast(value:Number, bitmap:Bitmap = null):void {
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
			var factor:Number = value / 500;
			//Formula taken from the Actionscript 3 Cookbook by Joey Lott, Darron Schall and Keith Peters
			if(_bitmap != null){
				var a:Number = factor * 11;
				var b:Number = 63.5 - (factor * 698.5);
				cmfContrast = new ColorMatrixFilter([a, 0, 0, 0, b, 0, a, 0, 0, b, 0, 0, a, 0, b, 0, 0, 0, 1, 0]);
				applyFilter();
			}
		}
		
		public function setSaturation(value:Number, bitmap:Bitmap = null):void{
			var contrast_factor:Number = value / 100;
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
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
			
		public function setRandom(random:Array, bitmap:Bitmap = null):void{
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
			if(_bitmap != null){
				cmfRandom = new ColorMatrixFilter(random);
				applyFilter();
			}
		}
		
		public function setRed(value:Number, bitmap:Bitmap = null):void{
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
			if(_bitmap != null){
				cmfRed = new ColorMatrixFilter([value/10, 0, 0, 0, 0, 
												0, 1, 0, 0, 0, 
												0, 0, 1, 0, 0, 
												0, 0, 0, 1, 0]);
			}
			applyFilter();
		}
		
		public function setGreen(value:Number, bitmap:Bitmap = null):void{
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
			if(_bitmap != null){
				cmfGreen = new ColorMatrixFilter([1, 0, 0, 0, 0, 
												0, value/10, 0, 0, 0, 
												0, 0, 1, 0, 0, 
												0, 0, 0, 1, 0]);
			}
			applyFilter();
		}
		
		public function setBlue(value:Number, bitmap:Bitmap = null):void{
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
			if(_bitmap != null){
				cmfBlue = new ColorMatrixFilter([1, 0, 0, 0, 0, 
												0, 1, 0, 0, 0, 
												0, 0, value/10, 0, 0, 
												0, 0, 0, 1, 0]);
			}
			applyFilter();
		}
		
		public function setNegative(value:Boolean, bitmap:Bitmap = null):void{
			if(bitmap == null){
				_bitmap = ApplicationManager.getInstance().bitmap;
			}else{
				_bitmap = bitmap;
			}
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
			if(cmfRed != null){
				_filtersArray.push(cmfRed);
			}
			if(cmfGreen != null){
				_filtersArray.push(cmfGreen);
			}
			if(cmfBlue != null){
				_filtersArray.push(cmfBlue);
			}
			if( _bitmap != null ) {
				_bitmap.filters = _filtersArray;
			}
			
		}
		
		
		public function setRandomFilter():void {
			var randomFilter:FilterValueObject = new FilterValueObject();
			randomFilter.brightness = Math.random() * 200 - 100;
			randomFilter.contrast = Math.random() * 100;
			randomFilter.saturation = Math.random() * 300;
			randomFilter.red = Math.random() * 20;
			randomFilter.green = Math.random() * 20;
			randomFilter.blue = Math.random() * 20;
			if(0.5 <= Math.random()){
				randomFilter.negative = true;
			}
			ApplicationManager.getInstance().basicFilter.setFilterValueObject(randomFilter);
			dispatcher = CustomEventDispatcher.getInstance();
			dispatcher.dispatchEvent(new FilterValuesChangedEvent(randomFilter));
		}
		
		public function setFilterValueObject(filterValues:FilterValueObject, bitmap:Bitmap = null):BasicFilter {
			setBrightness(filterValues.brightness, bitmap);
			setContrast(filterValues.contrast, bitmap);
			setSaturation(filterValues.saturation, bitmap);
			setRandom(filterValues.random, bitmap);
			setRed(filterValues.red, bitmap);
			setGreen(filterValues.green, bitmap);
			setBlue(filterValues.blue, bitmap);
			setNegative(filterValues.negative, bitmap);
			_filterValueObject = filterValues;
			return this;
		}
		
		public function getFilterValueObject():FilterValueObject{
			return _filterValueObject;
		}
		
	}
}