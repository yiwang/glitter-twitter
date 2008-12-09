package glitter
{
	import flash.filesystem.File;
	
	public class Filter
	{
		import com.adobe.serialization.json.JSON;
		
		private var userName:String;
		private var date:String;
		private var containsString:String;

		private var hasTwitPicCheck:Boolean;
		private var hasTwitPic:Boolean;
				
		private var isReplyToUserCheck:Boolean;
		private var isReplyToUser:Boolean;
		
		private var isReplyCheck:Boolean;
		private var isReply:Boolean;
		
		public function Filter()
		{
			
		}
		
		public function statusMatchesFilter(status:Status):Boolean {
			var b:Boolean = true;
			if(this.userName!=null && this.userName != ""){
				b = b&& (this.userName == status.getUserName());
			}
			if(this.containsString!=null && this.containsString != ""){
				b = b&& (status.getText().search(this.containsString)!= -1);
			}
			if(this.hasTwitPicCheck){
				b = b&& (this.hasTwitPic == status.hasPhoto());	
			}
			if(this.isReplyToUserCheck){
				b = b&& (this.isReplyToUser == status.getInReplyToUserId());
			}
			if(this.isReplyCheck){
				b = b&& (this.isReply == status.getInReplyToStatusId());		
			}
			return b;
		}
		
		public function toJSON():String{
			var j:Object = new Object();

			j.userName = this.userName;
			j.date = this.date;
			j.containsString = this.containsString;
			
			j.hasTwitPicCheck = this.hasTwitPicCheck;
			j.hasTwitPic = this.hasTwitPic;
			
			j.isReplyToUserCheck =  this.isReplyToUserCheck;
			j.isReplyToUser =  this.isReplyToUser;
				
			j.isReplyCheck = this.isReplyCheck;
			j.isReply = this.isReply;

			var s:String = JSON.encode(j);
			return s;
		}
		
		static public function fromObj(f:Object):Filter{
			var j:Filter = new Filter();
			j.userName = f.userName;
			j.date = f.date;
			j.containsString = f.containsString;
			
			j.hasTwitPicCheck = f.hasTwitPicCheck;
			j.hasTwitPic = f.hasTwitPic;
			
			j.isReplyToUserCheck =  f.isReplyToUserCheck;
			j.isReplyToUser =  f.isReplyToUser;
				
			j.isReplyCheck = f.isReplyCheck;
			j.isReply = f.isReply;

			return j;
		}
	}
}