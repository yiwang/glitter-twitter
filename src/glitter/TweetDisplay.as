package glitter
{
	import glitter.twitter.Twitter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	public class TweetDisplay extends Canvas
	{
		private var disp:Canvas;
		private var username:String;
		private var password:String;
		
		public function TweetDisplay()
		{
			disp = new Canvas();
			disp.width = 280;
			disp.height = 600;
			disp.setStyle("backgroundColor", 0x6aaec7);
			disp.verticalScrollPolicy = "on";
			
			addChild(disp);
		}
		
		public function getFriendsTimeline(name:String, pw:String):void {
			var t:Twitter = new Twitter(name, pw);
			t.getFriendsTimeline(showTweets);
			this.username = name;
			this.password = pw;
		}
		
		public function getUserTimeline(name:String, pw:String): void {
			var t:Twitter = new Twitter(name, pw);
			t.getUserTimeline(showTweets);			
			this.username = name;
			this.password = pw;
		}
			
		public function getReplies(name:String, pw:String): void {
			var t:Twitter = new Twitter(name, pw);
			t.getReplies(showTweets);				
			this.username = name;
			this.password = pw;
		}
		
		public function getUserUpdates(n:String):void {
			var t:Twitter = new Twitter(username, password);
			t.getUserTimeline(showTweets, n);
		}
		
		private var nm:String;	
		private function showTweets(tw:Array):void {
			disp.removeAllChildren();
			disp.graphics.clear();
				
			var tweets:ArrayCollection = new ArrayCollection(tw);
			var counter:uint = 2;
			var i:int;
			var j:int = 19;
				
			for(i =0; i<20; i++){
				if(tweets.length <= i) break;
			else{
					var item:Object = tweets.getItemAt(i);
					var st:Status = new Status(item);
					var t:Tweet = new Tweet(st, this);
					nm = st.getUserName();
					t.x = 2;
					t.y = counter;		
					disp.addChild(t);
					counter += 73;
				}
			}
		}
	}
}