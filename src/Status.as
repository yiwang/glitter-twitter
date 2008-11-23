package
{
	public class Status
	{
		private var userName:String;
		private var id:String;
		private var text:String;
		private var createdAt:Date;
		private var source:String;
		private var inReplyToStatusId:String;
		private var inReployToUserId:String;
		private var flickrPhoto:FlickrPhoto; // not all will have this
		
		public function Status()
		{
		}

		// returns true if this tweet has a photo attached.
		// figures this out by parsing the text of the update
		public function hasPhoto():Boolean {}		
	}
}