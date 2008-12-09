package glitter.data
{
	import com.adobe.serialization.json.JSON;
	
	import flash.filesystem.*;
	
	import glitter.Label;
	
	public class JsonFile
	{
		public function JsonFile()
		{
		}

		// File I/O
	 	static public function write(filename:String,labelsData:Object):void{
	 		var str:String = "[";
	 		for each(var label:Label in labelsData){
	 			str += label.toJSON() + ",\n"
	 		}
	 		str = str.substr(0,str.length-2);
	 		str += "]";
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
			var raw:Object = JSON.decode(str);
			var labelData:Object = new Object();
			for each (var label:Object in raw){
				labelData[label.name] = Label.fromObj(label);  
			}
 	 		return labelData;
 	 	}		

	}
}