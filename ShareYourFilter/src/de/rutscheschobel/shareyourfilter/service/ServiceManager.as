package de.rutscheschobel.shareyourfilter.service {
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterListEvent;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import mx.collections.ArrayCollection;

	public class ServiceManager {
		
		[Bindable]
		private var _filterList:ArrayCollection = new ArrayCollection();
		private var _service:HttpRESTService;
		private var _filterValueObject:FilterValueObject;
		private static const _uri:String = "http://localhost:8080/de.rutscheschobel.syf.rest/rest/filters/";
		
		public function ServiceManager() {
			_filterValueObject = new FilterValueObject();
			_service = new HttpRESTService(_uri);
		}
		
		private static var instance:ServiceManager = null;
		public static function getInstance():ServiceManager {
			if (ServiceManager.instance == null) {
				ServiceManager.instance = new ServiceManager();
			}
			return ServiceManager.instance;
		}
		
		public function updateFilterList():void {
			_service.readAll();
		}
		
		public function createFilter(name:String):void {
			_filterValueObject.name = name;
			_service.createFilter(_filterValueObject);
		}

		public function get filterList():ArrayCollection {
			return _filterList;
		}

		public function set filterList(filters:ArrayCollection):void {
			_filterList = filters;
			var dispatcher:CustomEventDispatcher = CustomEventDispatcher.getInstance();
			dispatcher.dispatchEvent(new FilterListEvent(filters));
		}

		public function set filterValueObject(value:FilterValueObject):void {
			_filterValueObject = value;
		}
		
		

		
	}
}