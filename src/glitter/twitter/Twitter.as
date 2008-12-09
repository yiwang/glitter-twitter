package glitter.twitter
{
	import com.hurlant.util.Base64;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import glitter.ApplicationController;
	import glitter.Status;
	
	import mx.collections.ArrayCollection;

	public class Twitter
	{
		private var username:String;
		private var password:String;
		private var credentials:String;
		
		// callback functions
		private var userCallback:Function;
		private var rateLimitCallback:Function;
		private var verifyCredentialsCallback:Function;
		private var timelineCallback:Function;
		
		private var controller:ApplicationController;
		/**
		 * This public var is the the current array of tweets displayed.  
		 */
		public var currentTimeLine:ArrayCollection;
		
		public function Twitter(username:String, password:String, controller:ApplicationController=null)
		{
			// obtain the controller
			this.controller = controller;
			
			this.username = username;
			this.password = password;
			this.credentials = Base64.encode(username + ":" + password);
		}
		
		public function verifyCredentials(callback:Function):void {
			this.verifyCredentialsCallback = callback;
			var ts:TwitterService = new TwitterService(credentials, parseVerifyCredentials, "account", "verify_credentials");
			ts.performGet();
		}		
		
		private function parseVerifyCredentials(o:Object):void {
			this.verifyCredentialsCallback.apply(this);
		}
		
		public function getRateLimit(callback:Function):void {
			this.rateLimitCallback = callback;
			var ts:TwitterService = new TwitterService(credentials, parseRateLimit, "account", "rate_limit_status");
			ts.performGet();
		}
		private function parseRateLimit(rateLimit:Object):void {
			rateLimitCallback.apply(this, [String(rateLimit.remaining_hits)]);
		}
		
		public function getTwitterUser(userCallback:Function, u:String = ""):void {
			this.userCallback = userCallback;
			u = u == "" ? this.username : u;
			var ts:TwitterService = new TwitterService(credentials, parseTwitterUser, "users", "show", u);
			ts.performGet();
		}
		
		private function parseTwitterUser(user:Object):void {
			userCallback.apply(this, [user]);
		}
		
		public function search(terms:String, callback:Function):void {
			this.timelineCallback = callback;
			var ts:TwitterSearch = new TwitterSearch(credentials, parseSearchResults, "twitter");
			ts.performGet();
		}
		
		/**
		 * timeline operations
		 */
		public function getFriendsTimeline(callback:Function):void {
			this.timelineCallback = callback;
			var ts:TwitterService = new TwitterService(credentials, parseGetTimeline, "statuses", "friends_timeline");
			ts.performGet({since_id:controller.get_lastid()});
		} 
		
		public function getUserTimeline(callback:Function, u:String = ""):void {
			this.timelineCallback = callback;
			u = u == "" ? this.username : u;
			var ts:TwitterService = new TwitterService(credentials, parseGetTimeline, "statuses", "user_timeline", u);
			ts.performGet({since_id:controller.get_lastid()});
		}
		
		public function getReplies(callback:Function):void {
			this.timelineCallback = callback;
			var ts:TwitterService = new TwitterService(credentials, parseGetTimeline, "statuses", "replies");
			ts.performGet({since_id:controller.get_lastid()});
		} 
		
		//////////////////////////////
//		public function search(callback:Function, key:String = ""):void {
//			this.timelineCallback = callback;
//			var ts:TwitterService = new TwitterService(credentials, parseSearch, "statuses", "user_timeline", key);
//			//var ts:TwitterSearch = new TwitterSearch(credentials, parseGetTimeline, key);
//			ts.performGet({since_id:controller.get_lastid()});
//		} 
		
		private function parseSearch(statuses:Array):void{
			this.timelineCallback.apply(this, [statuses]);
			//this.timelineCallback.apply(this, [statuses.map(function(o:Object, i:int, a:Array):Status {return new Status(o);})]);
		}
		///////////////////////////////
	
		/**
		 * update the data
		 */
		private function parseGetTimeline(statuses:Array):void{
			//this.timelineCallback.apply(this, [statuses]);
			this.timelineCallback.apply(this, [statuses.map(function(o:Object, i:int, a:Array):Status {return new Status(o);})]);
		}
		
		private function parseSearchResults(result:Object):void {
			trace('parsing search results');
			var results:Array = result.results;
			var statuses:ArrayCollection = new ArrayCollection();
			for each (var r:Object in results) {
				statuses.addItem(new Status({
					"user": {
						"id": r.from_user_id,
						"screen_name": r.from_user,
						"profile_image_url": r.profile_image_url
					},
					"text": r.text,
					"created_at": r.created_at,
					"in_reply_to_status_id": "",
					"in_reply_to_user_id": ""
				}));
			} 
			trace(Status(statuses[0]).getText());
			this.timelineCallback.apply(this, [statuses.toArray()]);
		}
		
		public function setLocation(location:String):void {
			var ts:TwitterService = new TwitterService(credentials, parseLocationUpdate, "account", "update_location");
			ts.performPost({location:location});
		}

		public function setUpdate(status:String):void {
			var ts:TwitterService = new TwitterService(credentials, parseLocationUpdate, "statuses", "update");
			ts.performPost({status:status});
		}
		
		private function parseLocationUpdate(o:Object):void {
			// do nothing for now
		}

		public static function getStoredUserName():String {
			var storedValue:ByteArray = EncryptedLocalStore.getItem("twitterUserName");
			return storedValue == null ? "" : storedValue.readUTFBytes(storedValue.length);
		}
		
		public static function getStoredPassword():String {
			var storedValue:ByteArray = EncryptedLocalStore.getItem("twitterPassword");
			return storedValue == null ? "" : storedValue.readUTFBytes(storedValue.length);			
		}
		
		public static function setStoredUserName(userName:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(userName);
			EncryptedLocalStore.removeItem("twitterUserName");
			EncryptedLocalStore.setItem("twitterUserName", bytes);			
		}
		
		public static function setStoredPassword(password:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(password);
			EncryptedLocalStore.removeItem("twitterPassword");
			EncryptedLocalStore.setItem("twitterPassword", bytes);			
		}
		
	}
}
