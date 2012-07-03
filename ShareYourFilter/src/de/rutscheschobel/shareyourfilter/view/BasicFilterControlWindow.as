package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	import de.rutscheschobel.shareyourfilter.util.BasicFilter;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	import de.rutscheschobel.shareyourfilter.view.components.ResizeComponent;
	import de.rutscheschobel.shareyourfilter.view.components.UploadFilter;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
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
		public var resizeButtonControlWindow:Button;
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
		private var oldValues:FilterValueObject;
		private var defaultValues:FilterValueObject;
		private var dispatcher:CustomEventDispatcher;
		public var randomArray:Array
		public var resizeWindow:ResizeWindow; 
		public var filterValuesResize:FilterValueObject;
		
		public function BasicFilterControlWindow(){
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
			dispatcher = CustomEventDispatcher.getInstance();
			history = new ArrayList();
			oldValues = new FilterValueObject();
			defaultValues = new FilterValueObject();
			history.addItem(oldValues);
			stepInHistory = history.length - 1;
			resizeWindow = new ResizeWindow();
			
			resizeButtonControlWindow.addEventListener(MouseEvent.CLICK, onResizeButtonChange);
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
			dispatcher.addEventListener(FilterValuesChangedEvent.ON_COMPLETE, onFilterValuesChanged);
			filter = ApplicationManager.getInstance().basicFilter;
		}
		
		/*
		* FILTER CONTROL
		*/
		private function onDefaultChange(event:Event):void{
			if(history.length == 0) return;
			var oldValue:FilterValueObject = history.getItemAt(0) as FilterValueObject;
			filter.setFilterValueObject(oldValue);
			updateSliderPositions(defaultValues);
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
		
		private function onResizeButtonChange(event:Event):void{
			resizeWindow = PopUpManager.createPopUp(this.parent, ResizeComponent, true) as ResizeComponent;
			resizeWindow.setFilterValueObject(getFilterValueObjectResize());
			PopUpManager.centerPopUp(resizeWindow);
		}
		
		private function onFilterValuesChanged(event:FilterValuesChangedEvent):void {
			filter = ApplicationManager.getInstance().basicFilter;
			updateSliderPositions(event.filter);
		}
		
		private function updateSliderPositions(filter:FilterValueObject):void {
			filterBrightnessSlider.value = filter.brightness;
			filterContrastSlider.value = filter.contrast;
			filterSaturationSlider.value = filter.saturation;
			filterRedSlider.value = filter.red;
			filterGreenSlider.value = filter.green;
			filterBlueSlider.value = filter.blue;
			filterNegativeCheckBox.selected = filter.negative;
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
				ServiceManager.getInstance().filterValueObject = newFilter;
				var uploadFilter:UploadFilter = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, 
					UploadFilter, true) as UploadFilter;
				PopUpManager.centerPopUp(uploadFilter);
		}
		
		public function getFilterValueObjectResize():FilterValueObject{
			var filterValuesResize:FilterValueObject = new FilterValueObject();
			filterValuesResize.brightness = filterBrightnessSlider.value;
			filterValuesResize.saturation = filterSaturationSlider.value;
			filterValuesResize.contrast = filterContrastSlider.value;
			filterValuesResize.red = filterRedSlider.value;
			filterValuesResize.green = filterGreenSlider.value;
			filterValuesResize.blue = filterBlueSlider.value;
			filterValuesResize.negative = filterNegativeCheckBox.selected;
			filterValuesResize.random = randomArray;
			return filterValuesResize;
		}
		
		private function onRandomFilterBackControlChange(event:Event):void{
			if(ApplicationManager.getInstance().bitmap == null) history.removeAll();
			if(history.length > 0 && stepInHistory > 0){
				var oldValue:Object = history.getItemAt(stepInHistory-1);
				
				filter.setBrightness(FilterValueObject(oldValue).brightness);
				filter.setContrast(FilterValueObject(oldValue).contrast);
				filter.setSaturation(FilterValueObject(oldValue).saturation);
				filter.setNegative(FilterValueObject(oldValue).negative);
				filter.setBlue(FilterValueObject(oldValue).blue);
				filter.setGreen(FilterValueObject(oldValue).green);
				filter.setRed(FilterValueObject(oldValue).red);
				
				if(stepInHistory > 0){
					history.removeItemAt(stepInHistory);					
					stepInHistory--;
				} 
			}
			trace("onRandomFilterBackControlChange... history.length: "+history.length);
		}
		
		private function onRandomFilterControlChange(event:Event):void{
			filter.setRandomFilter();
			var historyValueObject:FilterValueObject = filter.getFilterValueObject();
			
			if(history.length > 9){
				history.removeItemAt(1);
				history.addItem(historyValueObject);
				stepInHistory = 9;
			}else{
				history.addItem(historyValueObject);
				stepInHistory++;
			}
			trace("onRandomFilterControlChange... history.length: "+history.length);
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