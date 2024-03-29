package glitter.twitter
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class TwitterSearch extends HTTPService
	{
		private static var TWITTER_SEARCH_URL:String = "http://search.twitter.com/search.json";		
		private var resultCallback:Function;
		private var terms:String;
		private var fromUser:String;
		private var toUser:String;
		private var referencingUser:String;
		private var hashTag:String;
		private var hasPhoto:Boolean;

		public function TwitterSearch(credentials:String, resultCallback:Function, terms:String, fromUser:String, toUser:String, referencingUser:String, hashTag:String, hasPhoto:Boolean) {
			super();
			this.resultCallback = resultCallback;
			this.url = TWITTER_SEARCH_URL;
			this.terms = terms;
			this.fromUser = fromUser;
			this.toUser = toUser;
			this.referencingUser = referencingUser;
			this.hashTag = hashTag;
			this.hasPhoto = hasPhoto;

			this.headers = {Authorization: "Basic " + credentials};
			this.resultFormat = "text";
			this.showBusyCursor = false;
			this.addEventListener(ResultEvent.RESULT, onResult);
			this.addEventListener(FaultEvent.FAULT, onFault);
		}
		
		public function performGet():void {
			this.request = constructParams();
			this.send();
		}
		
		private function constructParams():Object {
			var queries:ArrayCollection = new ArrayCollection();
			if (terms != null && terms != "") {
				queries.addItem(terms);
			}
			if (fromUser != null && fromUser != "") {
				queries.addItem("from:" + fromUser);
			} 
			if (toUser != null && toUser != "") {
				queries.addItem("to:" + toUser);
			}
			if (referencingUser != null && referencingUser != "") {
				queries.addItem("@" + referencingUser);
			}
			if (hashTag != null && hashTag != "") {
				queries.addItem("#" + hashTag);
			}
			if(hasPhoto) {
				queries.addItem("twitpic.com -\"http://twitpic.com\"");
			}
			return {"q": queries.toArray().join("+")};
		}
		
		private function onResult(event:ResultEvent):void {
			trace(String(event.result));
			resultCallback.apply(this, [JSON.decode(String(event.result))]);
		}

		private function onFault(event:FaultEvent):void
		{
			trace("TwitterService fault: " + event.headers);
		}
	}
}
