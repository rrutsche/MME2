package de.rutscheschobel.shareyourfilter.service
{
	import com.adobe.net.URI;
	
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.httpclient.HttpClient;
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
			
			client.listener.onData = function(event:HttpDataEvent):void {
				// For string data
				var stringData:String = event.readUTFBytes();
				var message: Object = JSON.parse( stringData );
				var filters:Array = new Array();
				
				for( var s:String in message.filters ) {
					var filter:FilterValueObject = new FilterValueObject();
					filter.id = message.filters[s].id;
					filter.name = message.filters[s].name;
					filter.brightness = message.filters[s].brightness;
					filter.saturation = message.filters[s].saturation;
					filter.contrast = message.filters[s].contrast;
					filter.red = message.filters[s].red;
					filter.green = message.filters[s].green;
					filter.blue = message.filters[s].blue;
					filter.negative = message.filters[s].negative;
					filter.random = message.filters[s].random;
					filters.push(filter);
					trace(filter.toString());
				}
			};
			var uri:URI = new URI(uri);
			client.get(uri);
		}
		
		public function read(id:int) : void {
			client.listener.onData = function(event:HttpDataEvent):void {
				// For string data
				var stringData:String = event.readUTFBytes();
				var message: Object = JSON.parse( stringData );
				var filter:FilterValueObject = new FilterValueObject();
				filter.id = message.filter.id;
				filter.name = message.filter.name;
				filter.brightness = message.filter.brightness;
				filter.saturation = message.filter.saturation;
				filter.contrast = message.filter.contrast;
				filter.red = message.filter.red;
				filter.green = message.filter.green;
				filter.blue = message.filter.blue;
				filter.negative = message.filter.negative;
				filter.random = message.filter.random;
				trace(filter.toString());
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