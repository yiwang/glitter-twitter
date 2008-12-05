package glitter
{
	import glitter.twitter.Twitter;
    import flash.filesystem.File;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

	public class TwitPic
	{
		public function TwitPic()
		{
		}
		
		public static function urlFromResponse(xmlString:String):String {
			return new XML(xmlString).child("mediaurl")[0];
		}
		
		public static function upload(image:File):void {
            var urlRequest:URLRequest = new URLRequest("http://twitpic.com/api/upload");
            
	        urlRequest.method = URLRequestMethod.POST;
            var urlVars:URLVariables = new URLVariables();
            urlVars.username = Twitter.getStoredUserName();
            urlVars.password = Twitter.getStoredPassword();
            urlRequest.data = urlVars;
            
			image.upload(urlRequest, 'media');			
		}
	}
}