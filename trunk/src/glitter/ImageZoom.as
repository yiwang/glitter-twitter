package glitter
{
	import mx.controls.Image;

	public class ImageZoom extends Image
	{
		public function ImageZoom( path:String )
		{
			super();
			makeImage( path );
		}	

		private function makeImage( path:String ):void {
			this.source = path;
		}
	}
}