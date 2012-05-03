package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.util.BasicFilter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.HSlider;

	public class BasicFilterControlWindow extends AbstractWindow
	{
		
		public var filterBrightnessSlider:HSlider;
		public var filterContrastSlider:HSlider;
		public var filterSaturationSlider:HSlider;
		public var filterNegativeCheckBox:CheckBox;
		public var filter:BasicFilter;
		
		public function BasicFilterControlWindow(){
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
			filterBrightnessSlider.addEventListener(Event.CHANGE, onBrightnessFilterControlChange);
			filterContrastSlider.addEventListener(Event.CHANGE, onContrastFilterControlChange);
			filterSaturationSlider.addEventListener(Event.CHANGE, onSaturationFilterControlChange);
			filterNegativeCheckBox.addEventListener(MouseEvent.CLICK, onNegativeFilterControlChange);
			filter = new BasicFilter();
		}
		
		/*
		* FILTER CONTROL
		*/
		private function onBrightnessFilterControlChange(event:Event):void{
			filter.setBrightness((event.target as HSlider).value);
		}
		private function onContrastFilterControlChange(event:Event):void{
			filter.setContrast((event.target as HSlider).value);
		}
		private function onSaturationFilterControlChange(event:Event):void{
			filter.setSaturation((event.target as HSlider).value);
		}
		private function onNegativeFilterControlChange(event:MouseEvent):void{
			filter.setNegative(filterNegativeCheckBox.selected);
		}
	}
}