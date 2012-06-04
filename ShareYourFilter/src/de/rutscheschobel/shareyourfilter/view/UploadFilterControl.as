package de.rutscheschobel.shareyourfilter.view
{
	
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.TextInput;
	
	public class UploadFilterControl extends AbstractWindow
	{
		public var uploadFilterButton:Button;
		public var uploadFilterName:spark.components.TextInput;
		public var filterValue:FilterValueObject;
		
		public function UploadFilterControl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
			uploadFilterButton.addEventListener(MouseEvent.CLICK, onShareButtonClicked);
		}
		
		public function onShareButtonClicked(event:Event):void{
			filterValue.name = uploadFilterName.text;
			ServiceManager.getInstance().createFilter(filterValue);
		}
		
		public function setFilterObject(ob:FilterValueObject):void{
			filterValue = ob;
		}
	}
}