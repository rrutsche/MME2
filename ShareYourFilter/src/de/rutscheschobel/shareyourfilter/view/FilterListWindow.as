package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterListEvent;
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import spark.components.Button;
	import spark.components.List;

	public class FilterListWindow extends AbstractWindow {
		
		[Bindable]
		public var filterCollection:ArrayCollection = new ArrayCollection();
		public var update:Button;
		public var filterList:List;
		private var dispatcher:CustomEventDispatcher;
		
		public function FilterListWindow() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void {
			dispatcher = CustomEventDispatcher.getInstance();
			dispatcher.addEventListener(FilterListEvent.FILTERLIST_CHANGED, onFilterListChange);
			update.addEventListener(MouseEvent.CLICK, updateFilterList);
			filterList.addEventListener(Event.CHANGE, onFilterClick);
		}
		
		public function updateFilterList(event:Event):void {
			ServiceManager.getInstance().updateFilterList();
		}
		
		private function onFilterClick(event:Event):void {
			var filter:FilterValueObject = List(event.currentTarget).selectedItem;
			ApplicationManager.getInstance().basicFilter.setFilterValueObject(filter);
			var dispatcher:CustomEventDispatcher = CustomEventDispatcher.getInstance();
			dispatcher.dispatchFilterValuesChangedEvent(new FilterValuesChangedEvent(filter));
		}
		
		private function onFilterListChange(event:FilterListEvent):void {
			filterCollection = event.filters;
		}
	}
}