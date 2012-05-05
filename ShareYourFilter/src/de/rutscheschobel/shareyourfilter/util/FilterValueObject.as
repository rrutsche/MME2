package de.rutscheschobel.shareyourfilter.util
{
	public class FilterValueObject
	{
		private var _brightness:Number ;
		private var _saturation:Number ;
		private var _contrast:Number;
		private var _red:Number;
		private var _green:Number;
		private var _blue:Number;
		private var _negative:Boolean ;
		private var _random:Array;
		
		public function FilterValueObject()
		{
			_brightness = 0;
			_saturation = 100;
			_contrast = 50;
			_red = 10;
			_blue = 10;
			_green = 10;
			_negative = false; 
		}
		
		
		public function get red():Number
		{
			return _red;
		}

		public function set red(value:Number):void
		{
			_red = value;
		}

		public function get green():Number
		{
			return _green;
		}

		public function set green(value:Number):void
		{
			_green = value;
		}

		public function get blue():Number
		{
			return _blue;
		}

		public function set blue(value:Number):void
		{
			_blue = value;
		}

		public function get brightness():Number
		{
			return _brightness;
		}

		public function set brightness(value:Number):void
		{
			_brightness = value;
		}

		public function get negative():Boolean
		{
			return _negative;
		}

		public function set negative(value:Boolean):void
		{
			_negative = value;
		}

		public function get contrast():Number
		{
			return _contrast;
		}

		public function set contrast(value:Number):void
		{
			_contrast = value;
		}

		public function get saturation():Number
		{
			return _saturation;
		}

		public function set saturation(value:Number):void
		{
			_saturation = value;
		}

		public function get random():Array
		{
			return _random;
		}

		public function set random(value:Array):void
		{
			_random = value;
		}

	}
}