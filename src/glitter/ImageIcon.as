package glitter
{
	import mx.controls.Image;

	public class ImageIcon extends Image
	{
//		protected var path:String;
		
		public function ImageIcon( path:String )
		{
			super();
//			this.path = path;
			makeIcon( path );
		}
		
		private function makeIcon( path:String ):void {
// 			image.x = 10;
//			image.y = 10;
//			var image:Image = new Image();
			this.width = 80;
			this.height = 80;
			this.setStyle("verticalCenter", 0);
			this.setStyle("horizontalCenter", 0);
			this.source = path;
		}


	}
}