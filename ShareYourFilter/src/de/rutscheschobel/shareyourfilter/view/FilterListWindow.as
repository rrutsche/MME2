package de.rutscheschobel.shareyourfilter.view
{
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.Button;

	public class FilterListWindow extends AbstractWindow {
		
		[Bindable]
		public var filterList:ArrayCollection = new ArrayCollection();
		public var update:Button;
		
		public function FilterListWindow() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void {
			update.addEventListener(MouseEvent.CLICK, updateFilterList);
		}
		
		public function updateFilterList(event:MouseEvent):void {
			filterList = ServiceManager.getInstance().updateFilterList();
		}
	}
}