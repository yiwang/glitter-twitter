package
{
	// yw2298
	// implement like so:
	// http://blog.log2e.com/2008/05/25/twitter-flex-and-json/
	public class Twitter
	{
		private var userName:String;
		private var password:String;
		
		public function Twitter(userName:String, password:String)
		{
			this.userName = userName;
			this.password = password;
		}

		// methods to retrieve timelines. These all return Arrays of Status objects
		public function userTimeline(id:String = this.userName):Array {}
		
		public function friendsTimeline():Array {}
		
		public function replies():Array {}
		
		// returns the number of messages left in the rate limit
		public function getRateLimit():Integer {}
		
		// sets the user's location on twitter
		public function setLocation(location:String):void {}
	}
}