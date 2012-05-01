package de.rutscheschobel.shareyourfilter.util{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	
	public class BrightnessFilter{
	
		public function BrightnessFilter(){
		
		}
		
		private var _bitmap:Bitmap;
		private var _colorTransform:ColorTransform;
		
		public function setFilter(value:Number):void{
			_bitmap = ApplicationManager.getInstance().bitmap; 
			if(_bitmap != null){
				_colorTransform = new ColorTransform();
				_colorTransform.redOffset = value;
				_colorTransform.greenOffset = value;
				_colorTransform.blueOffset = value;
				_bitmap.transform.colorTransform = _colorTransform;
				ApplicationManager.getInstance().bitmap = _bitmap; 
			}
		}
	}
}