package glitter
{
	import flash.events.*;
	import flash.filters.GlowFilter;
	
	import mx.controls.Alert;
	import mx.controls.Image;

	public class ImageIcon extends Image
	{
//		protected var path:String;
		protected var index:int;
		
		public function ImageIcon( path:String, index:int )
		{
			super();
			this.index = index;
//			this.path = path;
			makeIcon( path );
			this.addEventListener(MouseEvent.CLICK,hndlMouseClick);
		}
		
		private function hndlMouseClick ( event:Event ):void {
			var myGlowFilter:GlowFilter = new GlowFilter (0xFFFFFF,.8,5,5,4,4);
			event.target.filters = [myGlowFilter];
//			Alert.show( this.parent.parent.getCurrentImage( index ));			
//			Alert.show( this.parent.parent.parent.toString());			
		}
		
		private function makeIcon( path:String ):void {
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.setStyle("verticalCenter", 0);
			this.setStyle("horizontalCenter", 0);
			this.source = path;
		}


	}
}