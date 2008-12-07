package glitter
{
	public class Filter
	{
		private var userName:String;
		private var date:Date;
		private var containsString:String;
		private var isReplyToUser:Boolean;
		private var isReply:Boolean;
		private var hasTwitPic:Boolean;
		
		public function Filter()
		{
		}
		
		public function statusMatchesFilter(status:Status):Boolean {
			return true;
		}
	}
}