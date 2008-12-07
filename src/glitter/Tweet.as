package glitter
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.Canvas;
	import mx.controls.*;
	
	public class Tweet extends Canvas
	{
		private var userName:mx.controls.Label;
		private var profileImage:Image;
		private var htmlLabel:HTML;
		private var createdAt:mx.controls.Label;
		private var display:TweetDisplay;
		private var isLinked:Boolean = false;
		private var url:String;
		private var replyTo:mx.controls.Label;
		public var isReply:Boolean = false;
		private var text:String;
		
		public function foo(s:String):void {
			Alert.show(s);
		}
		
		public function domInitialized(event:Event):void {
			htmlLabel.htmlLoader.window.showUserStatuses = getUserUpdates;
			htmlLabel.htmlLoader.window.showLink = link;
		}
			
		public function Tweet(status:Status, display:TweetDisplay)
		{
			this.display = display;
	
			htmlLabel = new HTML();
			htmlLabel.setStyle("right", 3);
			htmlLabel.setStyle("left", 3);
			htmlLabel.setStyle("top", 3);
			htmlLabel.setStyle("bottom", 3);
			htmlLabel.addEventListener(Event.HTML_DOM_INITIALIZE, domInitialized);
			text = "<body style='background-color: #91e4f3'><p>";	
			setSource(status.getSource());
			setUserName(status.getUserName());
			setText(status.getText());
			setTime(status.getFormattedDate());
			
			/* var glow:GlowFilter = new GlowFilter();
            glow.color = StyleManager.getColorName("white");
            glow.alpha = 0.8;
            glow.blurX = 4;
            glow.blurY = 4;
            glow.strength = 6;
            glow.quality = BitmapFilterQuality.HIGH;
            profileImage.filters = [glow]; */
			
			//text.setStyle("backgroundColor", 0x91e4f3);
			/* text.addEventListener(MouseEvent.CLICK, link); */

			text += "</p></body>";
			htmlLabel.htmlText = text;
			//htmlLabel.verticalScrollPolicy = "off";
			//htmlLabel.minHeight = 72;
			//htmlLabel.percentHeight = 100;
			//htmlLabel.height = 72;
			htmlLabel.height = 72;
			htmlLabel.setStyle("left", 2);
			htmlLabel.setStyle("right", 2);
			addChild(htmlLabel);
			
			//cvs.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function setUserName(name:String):void{
			text += "<a href=\"#\" onClick=\"showUserStatuses('" + name + "');\"><font color='#EE5815'>"+ name + "</font></a>&nbsp;&nbsp;&nbsp;";			
		}
		public function setSource(src:String):void{
			text += "<img src='" + src + "' style='float:left; margin-right:5px;' />";
		}
		public function setText(status:String):void{ 
			var a:Array = status.split(" ");
			for each(var s:String in a){
				if(s.charAt(0) == '@'){
					var replyTo:String = s.substr(1, s.length-1);
					text += "<a href=\"#\" onClick=\"showUserStatuses('" + replyTo + "');\"><font color='#EE5815'>" + s + "</font></a>&nbsp;&nbsp;";	
				}
				else if(s.match("http://twitpic.com/")){	// twitpic
					text += "<a href=\"#\" onClick=\"showLink('" + s + "');\"><font color='#EE5815'>" + s + "</font></a> ";	
				}
				else if(s.match("http://")){				// other links
					text += "<a href=\"#\" onClick=\"showLink('" + s + "');\"><font color='#EE5815'>" + s + "</font></a> ";
				}
				else{
					text += s + " ";
				}
			}			
		}
		
		public function getHeight():int {
			return htmlLabel.height;
		}
		
		public function link(url:String):void{
			var urlRequest:URLRequest = new URLRequest(url);
			navigateToURL(urlRequest, null);
		}
		
        public function setTime(tm:String):void{
        	text += "<br/><font color='#3b71d4'>" + tm + "</font>";
        }
		
	 	public function getUserUpdates(name:String):void {
	 		display.getUserUpdates(name);
		} 
		
		/* private function mouseDownHandler(event:MouseEvent):void{

            var dragSource:DragSource = new DragSource();
			dragSource.addData(cvs, "Canvas");
			
			var imageProxy:UIComponent = new UIComponent();
			var bitmap:Bitmap = new Bitmap();
			var bitmapData:BitmapData = new BitmapData(cvs.width, cvs.height);
			bitmapData.draw(cvs);
			bitmap.bitmapData = bitmapData;
            imageProxy.addChild(bitmap);
			
			DragManager.doDrag(cvs, dragSource, event, imageProxy);
        }  */
	}
}
