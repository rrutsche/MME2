package de.rutscheschobel.shareyourfilter.view
{
	
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.TextInput;
	
	public class UploadFilterControl extends AbstractWindow
	{
		public var uploadFilterButton:Button;
		public var uploadFilterName:spark.components.TextInput;
		
		public function UploadFilterControl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
			uploadFilterButton.addEventListener(MouseEvent.CLICK, onShareButtonClicked);
		}
		
		public function onShareButtonClicked(event:Event):void{
			var name:String = uploadFilterName.text;
			ServiceManager.getInstance().createFilter(name);
			PopUpManager.removePopUp(this);
		}
	}
}