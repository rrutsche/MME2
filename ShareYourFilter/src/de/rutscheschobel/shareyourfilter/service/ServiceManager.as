package de.rutscheschobel.shareyourfilter.service {
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
		}
		
		private static var instance:ServiceManager = null;
		public static function getInstance():ServiceManager {
			if (ServiceManager.instance == null) {
				ServiceManager.instance = new ServiceManager();
			}
			return ServiceManager.instance;
		}
		
		public function updateFilterList():ArrayCollection {
			_service = new HttpRESTService(_uri);
			_service.readAll();
			return filterList;
		}
		
		public function createFilter(name:String):void {
			_filterValueObject.name = name;
			_service = new HttpRESTService(_uri);
			_service.createFilter(_filterValueObject);
		}

		public function get filterList():ArrayCollection {
			return _filterList;
		}

		public function set filterList(value:ArrayCollection):void {
			_filterList = value;
		}

		public function set filterValueObject(value:FilterValueObject):void {
			_filterValueObject = value;
		}
		
		

		
	}
}