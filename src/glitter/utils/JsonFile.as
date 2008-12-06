package glitter.data
{
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.*;
	
	public class JsonFile
	{
		public function JsonFile()
		{
		}

		// File I/O
	 	static public function write(filename:String,obj:Object):void{
	 		var str:String = JSON.encode(obj);
 			var fs:FileStream = new FileStream();
 			var file:File = new File();
 			file.nativePath = File.applicationDirectory.nativePath + "\\" +filename + ".txt";
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();      		 		
 	 	}
 	 	
 	 	// return null if fail to read
 	 	static public function read(filename:String):Object{
 			var fs:FileStream = new FileStream();
 			var file:File = new File();
 			file.nativePath = File.applicationDirectory.nativePath + "\\" +filename + ".txt";
			if(!file.exists) {
				return null;
			}
			fs.open(file, FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable);
			if(str=="null"){
				fs.close();
				return null;
			}
			// successful
			fs.close();		 		
 	 		return JSON.decode(str);
 	 	}		

	}
}