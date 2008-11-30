package glitter
{
	import glitter.twitter.Twitter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	public class TweetDisplay extends Canvas
	{
		public var disp:Canvas;
		
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
		}
		
		public function getUserTimeline(name:String, pw:String): void {
			var t:Twitter = new Twitter(name, pw);
			t.getUserTimeline(showTweets);				
		}
			
		public function getReplies(name:String, pw:String): void {
			var t:Twitter = new Twitter(name, pw);
			t.getReplies(showTweets);				
		}
			
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
					var t:Tweet = new Tweet(st);
					t.x = 2;
					t.y = counter;			
				/* 	 with(t){		// display one user's all updates
						t.userName.addEventListener(MouseEvent.CLICK, getUserUpdates);
					}	 */	 
					disp.addChild(t);
					counter += 73;
				}
			}
		}
	}
}