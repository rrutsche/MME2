package de.rutscheschobel.shareyourfilter.service
{
	import com.adobe.net.URI;
	
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.httpclient.HttpClient;
	import org.httpclient.HttpResponse;
	import org.httpclient.events.HttpDataEvent;
	import org.httpclient.events.HttpErrorEvent;
	import org.httpclient.events.HttpListener;
	import org.httpclient.events.HttpRequestEvent;
	import org.httpclient.events.HttpResponseEvent;
	import org.httpclient.events.HttpStatusEvent;
	import org.httpclient.io.*;
	
	public class HttpRESTService {
		
		private var _uri:String = "http://localhost:8080/de.rutscheschobel.syf.rest/rest/filters/";
		private var client:HttpClient;
		
		public function HttpRESTService(uri:String) {
			_uri = uri;
			client = new HttpClient();
			client.addEventListener("ERROR", onError);
			client.addEventListener("COMPLETE", onComplete);
			client.addEventListener("STATUS", onStatus);
		}
		
		public function readAll() : void {

			var filters:ArrayCollection = new ArrayCollection();
			client.listener.onData = function(event:HttpDataEvent):void {
				// For string data
				var stringData:String = event.readUTFBytes();
				var message: Object = JSON.parse( stringData );
				
				for( var s:String in message.filters ) {
					var f:Object = message.filters[s] ;
					var filter:FilterValueObject = new FilterValueObject(f.name, f.id,  f.brightness, f.saturation, 
						f.contrast, f.red, f.blue, f.green, f.negative, f.random);
					filters.addItem( filter );
				}
				ServiceManager.getInstance().filterList = filters;
			};
			
			var uri:URI = new URI(uri);
			client.get(uri);
		}
		
		public function read(id:int) : void {
			client.listener.onData = function(event:HttpDataEvent):void {
				// For string data
				var stringData:String = event.readUTFBytes();
				var message: Object = JSON.parse( stringData );
				var f:Object = message.filter;
				var filter:FilterValueObject = new FilterValueObject(f.name, f.id,  f.brightness, f.saturation, 
					f.contrast, f.red, f.blue, f.green, f.negative, f.random);
			};
			var uri:URI = new URI(uri+id);
			client.get(uri);
		}
		
		public function createFilter(filter:FilterValueObject):void {
			
			var json:String = JSON.stringify( filter );
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( json );
			bytes.position = 0;
			client.put(new URI(uri), bytes, "application/json");
			readAll();
		}
		
		public function updateFilter(filter:FilterValueObject):void {
			
			var json:String = JSON.stringify( filter );
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( json );
			bytes.position = 0;
			client.post(new URI(uri), bytes, "application/json");
		}
		
		public function deleteFilter(filter:FilterValueObject):void {
			
			client.addEventListener(HttpResponseEvent.COMPLETE, function(event:HttpResponseEvent):void {
				trace(event.response.toString());
			});
			client.del(new URI(uri+filter.id));
		}
		
		
		private function onError(event:ErrorEvent):void {
			var errorMessage:String = event.text;
			trace(errorMessage);
		}
		
		private function onComplete(event:HttpResponseEvent):void {
			trace("onComplete");
		}
		
		private function onStatus(event:HttpStatusEvent):void {
			trace("onStatus: "+event.response.toString());
		}
		
		public function get uri():String {
			return _uri;
		}
		
		public function set uri(value:String):void {
			_uri = value;
		}
	}
}