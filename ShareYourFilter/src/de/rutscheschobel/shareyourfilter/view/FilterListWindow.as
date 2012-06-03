package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	
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
		
		public function FilterListWindow() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void {
			update.addEventListener(MouseEvent.CLICK, updateFilterList);
			filterList.addEventListener(Event.CHANGE, onFilterClick);
		}
		
		public function updateFilterList(event:Event):void {
			filterCollection = ServiceManager.getInstance().updateFilterList();
		}
		
		private function onFilterClick(event:Event):void {
			trace(List(event.currentTarget).selectedItem);
		}
	}
}