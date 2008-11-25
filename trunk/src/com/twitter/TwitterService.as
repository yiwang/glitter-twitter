package com.twitter
{
	import com.adobe.serialization.json.JSON;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class TwitterService extends HTTPService
	{
		public var tw:Twitter;
		public var dest:String;
		
		public function TwitterService(credentials:String, tw:Twitter, dest:String, type:String)
		{
			this.tw = tw;
			this.dest = "_"+dest;
			//super("http://twitter.com/statuses/", dest+ ".json");
			super();
			this.url = "http://twitter.com/"+ type + "/"+ dest+ ".json";
			//this.url = "http://twitter.com/statuses/user_timeline.json";
			this.headers = {Authorization: "Basic " + credentials};	
			this.resultFormat = "text";
			this.showBusyCursor= false;
			this.addEventListener("fault", onFault);
			this.addEventListener("result", onResult);	
			
		}
		
		private function onFault(event:FaultEvent):void
		{
			trace("TwitterService fault: " + event.headers + " _" + dest);
		}
					
		private function onResult(event:ResultEvent):void
		{
			var rawData:String = String( event.result );
			var a:Array = JSON.decode( rawData ) as Array; 
			var obj:Object = JSON.decode( rawData ) as Object;
			if (dest=="_rate_limit_status") 
			{
				tw[dest] = obj;
			}
			else
			{
				tw[dest] = a;
			}
			
		}		
	}
}