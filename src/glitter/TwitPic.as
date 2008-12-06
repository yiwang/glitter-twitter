package glitter
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import glitter.twitter.Twitter;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.HTTPService;

	public class TwitPic
	{
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
		
		// call this with the photoUrl returned from Status.getPhotoUrl and
		// a function name. The function should expect one parameter of type
		// mx.controls.Image
		public static function getPic(url:String, callback:Function):void {
			var http:HTTPService = new HTTPService();
			http.url = url;
			http.method = "GET";
			
			// for some reason the response from TwitPic throws an error even when it worked.
			// this is due some problem where the response isn't parsed correctly. If that is
			// the case then we can ignore and pull out the info we need
			http.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void {
				if (event.fault.faultCode == "Client.CouldNotDecode") {
					// this regex is ugly, but we can't use an html parser since it doesn't validate 
					var imageLinkPart:String = String(event.message.body.match(/id="pic" style=".*" src=".*"/g)[0]);
					var u:String = String(imageLinkPart.split('"')[5]);
					
					// if the first character is a slash then it's an image on twitpic.com
					// otherwise we got a full url (resides on s3)
					if (u.charAt(0) == "/") {
						u = "http://twitpic.com" + u;
					}
					var img:Image = new Image();
					img.source = u;
					callback.apply(this, [img]);
				}
				else {
					Alert.show("error getting picture from TwitPic");
				}
			})
			http.send();
		}
		
		private static function processTwitPicPage(callbackFunction:Function):void {
			
		}
	}
}