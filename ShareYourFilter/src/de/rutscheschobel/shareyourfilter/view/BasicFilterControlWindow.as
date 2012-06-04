package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.service.HttpRESTService;
	import de.rutscheschobel.shareyourfilter.util.BasicFilter;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	import de.rutscheschobel.shareyourfilter.view.components.UploadFilter;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	
	import mx.collections.ArrayList;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.FlexBitmap;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.HSlider;

	public class BasicFilterControlWindow extends AbstractWindow
	{
		private var stepInHistory:int;
		public var filterDefaultButton:Button;
		public var filterRandomButtonBack:Button;
		public var filterRandomButton:Button;
		public var filterButtonShare:Button;
		public var filterBlurSlider:HSlider;
		public var filterBrightnessSlider:HSlider;
		public var filterContrastSlider:HSlider;
		public var filterSaturationSlider:HSlider;
		public var filterRedSlider:HSlider;
		public var filterGreenSlider:HSlider;
		public var filterBlueSlider:HSlider;
		public var filterNegativeCheckBox:CheckBox;
		public var filter:BasicFilter;
		public var history:ArrayList;
		public var oldValues:FilterValueObject;
		public var randomArray:Array
		
		public function BasicFilterControlWindow(){
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
			history = new ArrayList();
			oldValues = new FilterValueObject();
			history.addItem(oldValues);
			stepInHistory = history.length - 1;
			
			filterButtonShare.addEventListener(MouseEvent.CLICK, onFilterButtonShare);
			filterRandomButtonBack.addEventListener(MouseEvent.CLICK, onRandomFilterBackControlChange);
			filterRandomButton.addEventListener(MouseEvent.CLICK, onRandomFilterControlChange);
			filterBrightnessSlider.addEventListener(Event.CHANGE, onBrightnessFilterControlChange);
			filterContrastSlider.addEventListener(Event.CHANGE, onContrastFilterControlChange);
			filterSaturationSlider.addEventListener(Event.CHANGE, onSaturationFilterControlChange);
			filterRedSlider.addEventListener(Event.CHANGE, onRedFilterControlChange);
			filterGreenSlider.addEventListener(Event.CHANGE, onGreenFilterControlChange);
			filterBlueSlider.addEventListener(Event.CHANGE, onBlueFilterControlChange);
			filterNegativeCheckBox.addEventListener(MouseEvent.CLICK, onNegativeFilterControlChange);
			filterDefaultButton.addEventListener(MouseEvent.CLICK, onDefaultChange);
			this.addEventListener(FilterValuesChangedEvent.ON_COMPLETE, onFilterValuesChanged);
			filter = ApplicationManager.getInstance().basicFilter;
		}
		
		/*
		* FILTER CONTROL
		*/
		private function onDefaultChange(event:Event):void{
			var oldValue:FilterValueObject = history.getItemAt(0) as FilterValueObject;
			filter.setFilterValueObject(oldValue);
			filterBrightnessSlider.value = 0;
			filterContrastSlider.value = 50;
			filterSaturationSlider.value = 100;
			filterRedSlider.value = 10;
			filterGreenSlider.value = 10;
			filterBlueSlider.value = 10;
			filterNegativeCheckBox.selected = false;
			if(history.length > 0){
				var index:int = history.length-1;
				while(history.length > 1){
					trace("lenght of history is: "+history.length);
					history.removeItemAt(index);
					index--;
				}
				stepInHistory = 0;
			}
			trace("onDefaultChange... history.length: "+history.length);
		}
		
		private function onFilterValuesChanged(event:FilterValuesChangedEvent):void {
//			Alert.show("event");
		}
		
		private function onFilterButtonShare(event:Event):void{
			var newFilter:FilterValueObject = new FilterValueObject();
				newFilter.brightness = filterBrightnessSlider.value;
				newFilter.saturation = filterSaturationSlider.value;
				newFilter.contrast = filterContrastSlider.value;
				newFilter.red = filterRedSlider.value;
				newFilter.green = filterGreenSlider.value;
				newFilter.blue = filterBlueSlider.value;
				newFilter.negative = filterNegativeCheckBox.selected;
				newFilter.random = randomArray;
				var uploadFilterControl:UploadFilter = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, UploadFilter, true) as UploadFilter;
				PopUpManager.centerPopUp(uploadFilterControl);
				uploadFilterControl.setFilterObject(newFilter);
		}
		
		private function onRandomFilterBackControlChange(event:Event):void{
			if(ApplicationManager.getInstance().bitmap == null) history.removeAll();
			if(history.length > 0 && stepInHistory > 0){
				var oldValue:Object = history.getItemAt(stepInHistory-1);
				
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
			trace("onRandomFilterBackControlChange... history.length: "+history.length);
//			trace("history.length: "+history.length);
//			trace("stepInHistory: "+stepInHistory);
		}
		
		private function onRandomFilterControlChange(event:Event):void{
			randomArray = filter.generateRandomNumberArray();
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
			trace("onRandomFilterControlChange... history.length: "+history.length);
//			trace("history.length: "+history.length);
//			trace("stepInHistory: "+stepInHistory);
		}
		private function onRedFilterControlChange(event:Event):void{
			filter.setRed((event.target as HSlider).value);
		}
		private function onGreenFilterControlChange(event:Event):void{
			filter.setGreen((event.target as HSlider).value);
		}
		private function onBlueFilterControlChange(event:Event):void{
			filter.setBlue((event.target as HSlider).value);
		}
		private function onBlueSliderSetDefault(event:NativeDragEvent):void{
			trace("BLUE");
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