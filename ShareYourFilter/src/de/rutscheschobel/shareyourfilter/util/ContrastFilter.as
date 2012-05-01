package de.rutscheschobel.shareyourfilter.util
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	
	import flash.display.Bitmap;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;

	public class ContrastFilter
	{
		private var _bitmap:Bitmap;
		private var _ct:ColorTransform;
		
		public function ContrastFilter(){
		}
		
		public function setFilter(value:Number):void{
			
			_bitmap = ApplicationManager.getInstance().bitmap; 
			_ct = new ColorTransform();
			var factor:Number = value / 500;
			//Formula taken from the Actionscript 3 Cookbook by Joey Lott, Darron Schall and Keith Peters
			var a:Number = factor * 11;
			var b:Number = 63.5 - (factor * 698.5);
			var matrix:Array = new Array(a, 0, 0, 0, b, 0, a, 0, 0, b, 0, 0, a, 0, b, 0, 0, 0, 1, 0);
			var cmf:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			
			var filtersArray:Array = new Array();
			filtersArray.push(cmf);
			_bitmap.filters = filtersArray;

		}
	}
}