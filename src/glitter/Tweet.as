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
		private var cvs:Canvas;
		private var userName:mx.controls.Label;
		private var profileImage:Image;
		private var htmlLabel:HTML;
		private var createdAt:mx.controls.Label;
		private var display:TweetDisplay;
		private var isLinked:Boolean = false;
		private var url:String;
		private var replyTo:mx.controls.Label;
		public var isReply:Boolean = false;
		private var sss:String;
		private var cs:Status;
		
		public function foo(s:String):void {
			Alert.show(s);
		}
		
		public function domInitialized(event:Event):void {
			htmlLabel.htmlLoader.window.showUserStatuses = foo;
		}
			
		public function Tweet(status:Status, display:TweetDisplay)
		{
			this.display = display;
			this.cs = status;
			
			 cvs = new Canvas();
			/* cvs.setStyle("left", 2);
			cvs.setStyle("right", 2);
			cvs.percentHeight = 100;
			cvs.height = 100; */ 
			//cvs.percentHeight = 100;
			//setColor(0x91e4f3);
			
			htmlLabel = new HTML();
			htmlLabel.setStyle("right", 3);
			htmlLabel.setStyle("left", 3);
			htmlLabel.setStyle("top", 3);
			htmlLabel.setStyle("bottom", 3);
			htmlLabel.addEventListener(Event.HTML_DOM_INITIALIZE, domInitialized);
			sss = "<body style='background-color: #91e4f3'><p>";	
			setSource(status.getSource());
			setUserName(status.getUserName());
			setText(status.getText());
			setTime(status.getFormattedDate());
			
			/* 
			userName.addEventListener(MouseEvent.CLICK, getUserUpdates); */
			
			/* 
			replyTo.addEventListener(MouseEvent.CLICK, getUserUpdates); */
			
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

			sss += "</p></body>";
			htmlLabel.htmlText = sss;
			//htmlLabel.verticalScrollPolicy = "off";
			//htmlLabel.minHeight = 72;
			//htmlLabel.percentHeight = 100;
			//cvs.addChild(htmlLabel);
			//addChild(cvs);
			//htmlLabel.height = 72;
			htmlLabel.height = 72;
			htmlLabel.setStyle("left", 2);
			htmlLabel.setStyle("right", 2);
			//htmlLabel.percentHeight = 100;
			//cvs.height = 72;
			addChild(htmlLabel);
			//cvs.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
/* 		public function linkHandler(event:TextEvent):void {
			navigateToURL(new URLRequest(event.text), '_blank')
        }
 */
		public function setUserName(name:String):void{
			sss += "<a class='user-link' href=\"#\" onClick=\"showUserStatuses('" + name + "');\"><font color='#EE5815'>"+ name + "</font></a>&nbsp;&nbsp;&nbsp;";			
		}
		public function setSource(src:String):void{
			sss += "<img src='" + src + "' style='float:left; margin-right:5px;' />";
		}
		public function setText(status:String):void{ 
			var a:Array = status.split(" ");
			for each(var s:String in a){
				if(s.charAt(0) == '@'){
					setColor(0x82f2d4);
					sss += "<a class='user-link' href=''><font color='#EE5815'>" + s + "</font></a>&nbsp;&nbsp;";	
				}
				else if(s.match("http://twitpic.com/")){	// twitpic
					isLinked = true;
					sss += "<a class='twitpic-link' href='"+ s +"'><font color='#EE5815'>" + s + "</font></a> ";	
				}
				else if(s.match("http://")){				// other links
					isLinked = true;
					sss += "<a class='link' href='"+ s +"'><font color='#EE5815'>" + s + "</font></a> ";
				}
				else{
					sss += s + " ";
				}
			}			
		}
		
		public function getHeight():int {
			return htmlLabel.height;
		}
		
		public function link(e:MouseEvent):void{
			if(isLinked){
			htmlLabel.setStyle("color", 0x1931c4);
			var urlRequest:URLRequest = new URLRequest(url);
			navigateToURL(urlRequest, null);
			}
		}
		
        public function setTime(tm:String):void{
        	//createdAt.text = tm;
        	sss += "<br/><font color='#3b71d4'>" + tm + "</font>";
        }
		public function setColor(color:uint):void{
			cvs.setStyle("backgroundColor", color);
		}
		public function rollOver(e:MouseEvent):void{
			if (e.target == userName)
				userName.setStyle("textDecoration", "underline");
			else if (e.target == replyTo)
				replyTo.setStyle("textDecoration", "underline");
			else if (e.target==htmlLabel && isLinked)
				htmlLabel.setStyle("color", 0x1931c4);
		}
		public function rollOut(e:MouseEvent):void{
			if (e.target == userName)
				userName.setStyle("textDecoration", "none");
			else if (e.target == replyTo)
				replyTo.setStyle("textDecoration", "none");
			else if (e.target==htmlLabel && isLinked)
				htmlLabel.setStyle("color", 0xEE5815);
		}
	 	public function getUserUpdates():void {
	 		/* if (e.currentTarget == userName)
	 			display.getUserUpdates(userName.text);
	 		else if (e.currentTarget == replyTo) {
				var name:String = replyTo.text.substr(1, replyTo.text.length-1);
				display.getUserUpdates(name);
	 		} */
	 		display.getUserUpdates(cs.getUserName());
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
