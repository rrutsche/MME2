package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.util.BasicFilter;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.HSlider;

	public class BasicFilterControlWindow extends AbstractWindow
	{
		private var stepInHistory:int;
		public var filterRandomButtonBack:Button;
		public var filterRandomButton:Button;
		public var filterBlurSlider:HSlider;
		public var filterBrightnessSlider:HSlider;
		public var filterContrastSlider:HSlider;
		public var filterSaturationSlider:HSlider;
		public var filterNegativeCheckBox:CheckBox;
		public var filter:BasicFilter;
		public var history:ArrayList;
		public var oldValues:FilterValueObject;
		
		public function BasicFilterControlWindow(){
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
			history = new ArrayList();
			oldValues = new FilterValueObject();
			history.addItem(oldValues);
			stepInHistory = history.length - 1;
			
			filterRandomButtonBack.addEventListener(MouseEvent.CLICK, onRandomFilterBackControlChange);
			filterRandomButton.addEventListener(MouseEvent.CLICK, onRandomFilterControlChange);
			filterBlurSlider.addEventListener(Event.CHANGE, onBlurFilterControlChange);
			filterBrightnessSlider.addEventListener(Event.CHANGE, onBrightnessFilterControlChange);
			filterContrastSlider.addEventListener(Event.CHANGE, onContrastFilterControlChange);
			filterSaturationSlider.addEventListener(Event.CHANGE, onSaturationFilterControlChange);
			filterNegativeCheckBox.addEventListener(MouseEvent.CLICK, onNegativeFilterControlChange);
			filter = new BasicFilter();
		}
		
		/*
		* FILTER CONTROL
		*/
		private function onRandomFilterBackControlChange(event:Event):void{
			if(ApplicationManager.getInstance().bitmap == null) history.removeAll();
			if(history.length > 0 && stepInHistory > 0){
				var oldValue = history.getItemAt(stepInHistory-1);
				
				filter.setBrightness(FilterValueObject(oldValue).brightness);
				filter.setContrast(FilterValueObject(oldValue).contrast);
				filter.setSaturation(FilterValueObject(oldValue).saturation);
				filter.setNegative(FilterValueObject(oldValue).negative);
				filter.setRandom(FilterValueObject(oldValue).random);
				
				if(stepInHistory > 0){
					history.removeItemAt(stepInHistory);					
					stepInHistory--;
				} 
			}
			trace("history.length: "+history.length);
			trace("stepInHistory: "+stepInHistory);
		}
		
		private function onRandomFilterControlChange(event:Event):void{
			var randomArray:Array = filter.generateRandomNumberArray();
			var newFilterValueObject:FilterValueObject = new FilterValueObject();
			newFilterValueObject.random = randomArray;
			if(history.length > 9){
				history.removeItemAt(1);
				history.addItem(newFilterValueObject);
				stepInHistory = 9;
			}else{
				history.addItem(newFilterValueObject);
				stepInHistory++;
			}
			filter.setRandom(randomArray);
			trace("history.length: "+history.length);
			trace("stepInHistory: "+stepInHistory);
		}
		private function onBlurFilterControlChange(event:Event):void{
			filter.setBlur((event.target as HSlider).value);			
		}
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