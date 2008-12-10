package glitter
{
	import com.adobe.serialization.json.JSON;
	
	import mx.controls.Image;
	import mx.formatters.DateFormatter;
	
	dynamic public class Status
	{
		private var id:String;
		private var userId:String;
		private var userName:String;
		private var source:String;
		private var text:String;
		private var createdAt:String;
		private var inReplyToStatusId:String;
		private var inReplyToUserId:String;
		private var flickrPhoto:FlickrPhoto; // not all will have this
		private var image:Image;
		private var hasPic:Boolean = false;
		private var photoUrl:String;
		public var _item:Object;
		
		public function Status(item:Object)
		{
			id = item.id;
			userId = item.user.id;
			userName = item.user.screen_name;
			source = item.user.profile_image_url;
//			Alert.show(source);
			text = item.text;
			createdAt = item.created_at;
			inReplyToStatusId = item.in_reply_to_status_id;
			inReplyToUserId = item.in_reply_to_user_id;
			_item = item; 
		}
		
		public function getId():String
		{
			return id;
		}

		public function getUserName():String
		{
			return userName;			
		}
		
		public function getSource():String
        {
       		return source;
        }
		
  	 	public function getText():String
       	{
       		return text;
       	}		
       	
       	public function getFormattedDate():String
       	{
			var dateFormatter:DateFormatter = new DateFormatter();
    		dateFormatter.formatString = "MMMM D, YYYY, J:NN:SS";    
    		var a:Array = createdAt.split(" ");
    		var date:String = dateFormatter.format( createdAt );
    		date = date.replace("2000", a.pop());
 			return date;
       	}	
       	
       	public function getInReplyToStatusId():String
       	{
       		return inReplyToStatusId;
       	}
       	
       	public function getInReplyToUserId():String
       	{
       		return inReplyToUserId;       		
       	}

		// returns true if this tweet has a photo attached.
		// figures this out by parsing the text of the update
		public function hasPhoto():Boolean
		{
			var a:Array = text.split(" ");
			a.reverse();
			
			for each(var s:String in a){
				if(s.match("http://twitpic.com/")){
					hasPic = true;
					photoUrl = s;
					TwitPic.getPic(photoUrl,setImage);
					break;
				}
			}	
			return hasPic;			
		}	
		
		// twitpic URL
		public function getPhotoUrl():String
		{
			return photoUrl;
		}
		
		private function setImage(img:Image):void{
			this.image = img;
		}
		public function getImage():Image{
			return image;
		}
		
		public function toJSON():String{					
			return JSON.encode(this._item);
		}
		
		static public function fromObj(item:Object):Status{
			var status:Status = new Status(item);
			return status;
		}
	}
}
