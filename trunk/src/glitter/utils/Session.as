package glitter.data
{
	import mx.messaging.channels.StreamingAMFChannel;
	
	public class Session
	{
		/**
		 * a_twit stores all twit, indexed by id
		 * a_key_id stores twit ids categorized by key
		 */
		private var a_twit:Object = new Object();
		private var a_key_id:Object = new Object();
		/** 
		 * the inventory of timelines
		 * used directly by Twitter.as
		 * for retrieving newer data, filtering and user customized tweets
		 */  
		private var a_timelines:Object = new Object();
				
		public function Session()
		{
		}

		public function save(u:String):void{
			JsonFile.write(u + "_a_twit",this.a_twit);
				construct_a_key_id();
				JsonFile.write(u + "_a_key_id",this.a_key_id);
			
		}
		public function load(u:String):void{
			var obj:Object = JsonFile.read(u + "_a_twit");
			this.a_twit = obj==null ? new Object() : obj;
			obj = JsonFile.read(u + "_a_key_id");
			this.a_key_id = obj==null ? new Object() : obj;
			construct_a_timelines();
		}
		
		public function getTwitById(__id__:String):Object{
			return a_twit[__id__];
		}

		public function getAllTwits():Array{
			var a:Array = new Array();
			for each (var twit:Object in this.a_twit){
				a.push(twit);
			}
			a.sortOn("id",Array.DESCENDING | Array.NUMERIC);
			return a;
		}
		
		public function get_lastid(__key__:String):Number
		{
			if(a_timelines[__key__]==null){
				return 1000000000; //"1032736924";
			}else{
				//allways sorted by date
				return a_timelines[__key__][0].id;
			}
		}
				
		public function get_new_timeline(new_a:Array,__key__:String):Array	{
			if(a_timelines[__key__]==null){
				a_timelines[__key__] = new_a;
			}else{
				a_timelines[__key__] = new_a.concat(a_timelines[__key__]);
			}
			// insert new twit to a_twit
			for each(var twit:Object in new_a){
				a_twit[String(twit.id)] = twit;
			}
			return a_timelines[__key__];
		}
		/** 
		 * convert a_timelines and a_key_id to each other
		 * a_key_id for storage
		 * a_timelines for run time
		 */
		private function construct_a_key_id():void{
			for ( var key:String in this.a_timelines){
				this.a_key_id[key] = extract_ids(this.a_timelines[key]) as Array;
			}
		}
		private function extract_ids(twits:Array):Array{
			var ids:Array = new Array();
			for each (var twit:Object in twits){
				ids.push(twit.id);
			}
			return ids;
		}
		private function construct_a_timelines():void{
			for ( var key:String in this.a_key_id){
				this.a_timelines[key] = extract_twits(this.a_key_id[key]) as Array;
			}			
		}
		private function extract_twits(ids:Array):Array{
			var twits:Array = new Array();
			for each (var id:Number in ids){
				twits.push(getTwitById(String(id)));
			}
			return twits;
		}
		
	}
}