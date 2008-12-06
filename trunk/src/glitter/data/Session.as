package glitter.data
{
	import com.hurlant.crypto.symmetric.NullPad;
	
	public class Session
	{
		/**
		 * a_twit stores all twit, indexed by id
		 * a_key_id stores twit ids categorized by key
		 */
		private var a_twits:Object = new Object();
		private var a_key_ids:Object = new Object();
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
			JsonFile.write(u + "_a_twit",this.a_twits);
			construct_a_key_ids();
			JsonFile.write(u + "_a_key_id",this.a_key_ids);			
		}
		public function load(u:String):void{
			var obj:Object = JsonFile.read(u + "_a_twit");
			this.a_twits = obj==null ? new Object() : obj;
			obj = JsonFile.read(u + "_a_key_id");
			this.a_key_ids = obj==null ? new Object() : obj;
			construct_a_timelines();
		}
		
		public function get_twit_by_id(__id__:String):Object{
			return a_twits[__id__];
		}

		public function getAllTwits():Array{
			var a:Array = new Array();
			for each (var twit:Object in this.a_twits){
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
		
		public function get_timeline_by_key(__key__:String):Array{
			return a_timelines[__key__];
		}
		
		public function update_timeline_by_key(__key__:String,twits:Array):void{
			for each(var t:Object in twits){
				insert_timeline_by_key(__key__,t);
			}
		}
		
		private function insert_timeline_by_key(__key__:String,t:Object):void{
			var timeline:Array = a_timelines[__key__];
			if (timeline==null){
				a_timelines[__key__] = new Array(t);
				return;
			}
			for each (var twit:Object in timeline){
				if(t.id==twit.id) return;
			}
			timeline.push(t);
			timeline.sortOn("id",Array.DESCENDING | Array.NUMERIC);
		}
				
		/** 
		 * convert a_timelines and a_key_id to each other
		 * a_key_id for storage
		 * a_timelines for run time
		 */
		private function construct_a_key_ids():void{
			for ( var key:String in this.a_timelines){
				this.a_key_ids[key] = extract_ids(this.a_timelines[key]) as Array;
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
			for ( var key:String in this.a_key_ids){
				this.a_timelines[key] = extract_twits(this.a_key_ids[key]) as Array;
			}			
		}
		private function extract_twits(ids:Array):Array{
			var twits:Array = new Array();
			for each (var id:Number in ids){
				twits.push(get_twit_by_id(String(id)));
			}
			return twits;
		}
		
	}
}