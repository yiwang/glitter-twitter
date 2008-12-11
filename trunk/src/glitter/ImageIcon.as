package glitter
{
	import flash.events.*;
	import flash.filters.GlowFilter;
	
	import mx.controls.Image;

	public class ImageIcon extends Image
	{
//		protected var path:String;
		public var index:int;
		public var sender:String;
		public var date:String;
		
		public function ImageIcon( path:String, index:int, sender:String, date:String )
		{
			super();
			this.index = index;
			this.sender = sender;
			this.date = date;
//			this.path = path;
			makeIcon( path );
			this.addEventListener(MouseEvent.CLICK,hndlMouseClick);
		}
		
		private function hndlMouseClick ( event:Event ):void {
			var myGlowFilter:GlowFilter = new GlowFilter (0xFFFFFF,.8,5,5,4,4);
			//event.target.filters = [myGlowFilter];
//			Alert.show( this.parent.parent.getCurrentImage( index ));			
//			Alert.show( this.parent.parent.parent.toString());			
		}
		
		private function makeIcon( path:String ):void {
//			this.width = 80;
			//this.percentWidth = 100;
//			this.percentHeight = 100;
			this.maxWidth = 225;
			this.maxHeight = 175;
//			this.setStyle("verticalCenter", 0);
//			this.setStyle("horizontalCenter", 0);

			TwitPic.getPic(path,setImage);
			//this.source = path;
		}
		
		private function setImage(img:Image):void{
			this.source = img.source;
		}
	}
}