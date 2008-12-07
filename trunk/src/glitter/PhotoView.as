package glitter
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.Tile;
	import mx.events.*;


	public class PhotoView extends Canvas
	{
		private var photoAreasHBox:HBox;
		private var photoIconsTile:Tile;
		private var photoZoomCanvas:Canvas;
		private var photoArray:ArrayCollection;
		private var directory:File = File.documentsDirectory;
		private var curIndex:int;


		public function PhotoView()
		{
			photoIconsTile = new Tile();
			photoIconsTile.percentWidth=95;
			photoIconsTile.percentHeight=100;
			photoIconsTile.tileHeight=150;
			photoIconsTile.tileWidth=150;
			this.addChild(photoIconsTile);
			photoArray = new ArrayCollection;
			loadPhotosFromDirectory();
			//loadTestPhotos();
		}


		public function setCurrentIndex( curIndex:int ):void {
			this.curIndex = curIndex;
		}


		public function getCurrentIndex( ):int {
			return curIndex;
		}


		public function loadTestPhotos():void {
			var image:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 013.JPG",0,new String("linusconcepcion"),new String("2008-12-04"));// + files[i].nativePath );
			photoArray.addItem(image);
			var image1:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 015.JPG",1,new String("linusconcepcion"),new String("2008-12-04"));// + files[i].nativePath );
			photoArray.addItem(image1);
			var image2:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 020.JPG",2,new String("linusconcepcion"),new String("2008-12-04"));// + files[i].nativePath );
			photoArray.addItem(image2);
			displayPhotos( photoArray );
		}

		
		public function loadPhotosFromDirectory():void {
			var myFile:File = new File();
			try
			{
			    directory.browseForDirectory("Select directory of photos (for testing)");
			    directory.addEventListener(Event.SELECT, hndlFileSelect);
			}
			catch (error:Error)
			{
			    trace("Failed:", error.message)
			}
		}
		

		private function hndlFileSelect(event:Event):void 
		{
		    directory = event.target as File;
		    var lcpath:String;
		    var files:Array = directory.getDirectoryListing();
 		    for(var i:uint = 0; i < files.length; i++)
		    {
				lcpath = files[i].nativePath.toLowerCase();
		    	if ( lcpath.indexOf("jpg") > 0
		    		|| lcpath.indexOf("gif") > 0 
		    		|| lcpath.indexOf("png") > 0 ) {
		    			var image:ImageIcon = new ImageIcon( "file://" + files[i].nativePath, i,"test","2008-12-04" );
						photoArray.addItem(image);
			     }
		    }
			displayPhotos( photoArray );
		}
				
		public function displayPhotos( thePhotoArray:ArrayCollection ):void {
			for(var i:uint=0; i<thePhotoArray.length; i++) {
				photoIconsTile.addChild( thePhotoArray[i] );
			} 			
		}
	}
}