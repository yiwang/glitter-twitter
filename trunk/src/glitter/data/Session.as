package glitter.data
{
	import com.hurlant.crypto.symmetric.NullPad;
	
	public class Session
	{
		/**
		 * a_id_twits stores all twit, indexed by id
		 * a_key_ids stores twit ids categorized by key
		 */
		private var a_id_twits:Object = new Object();
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
			construct_a_key_ids();
			JsonFile.write(u + "_a_id_twits",this.a_id_twits);
			JsonFile.write(u + "_a_key_ids",this.a_key_ids);			
		}
		public function load(u:String):void{
			var obj:Object = JsonFile.read(u + "_a_id_twits");
			this.a_id_twits = obj==null ? new Object() : obj;
			obj = JsonFile.read(u + "_a_key_ids");
			this.a_key_ids = obj==null ? new Object() : obj;
			construct_a_timelines();
		}
		
		public function get_twit_by_id(__id__:String):Object{
			return a_id_twits[__id__];
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
		public function get_num( __key__:String):Number{
			if(a_timelines[__key__]==null) {
				return 0;
			}else{
				return (a_timelines[__key__] as Array).length;
			}
		}
		public function get_timeline(__key__:String):Array{
			return a_timelines[__key__];
		}
		
		public function update_timeline(__key__:String,twits:Array):void{
			if(twits==null)return;
			for each(var t:Object in twits){
				insert_timeline(__key__,t);
			}
		}
		
		public function insert_timeline(__key__:String,t:Object):void{
			if(t==null)return;
			this.a_id_twits[String(t.id)] = t;
			var timeline:Array = a_timelines[__key__];
			if (timeline==null){
				a_timelines[__key__] = new Array(t);
				add_to_all(t);
			}else{
				// avoid duplicate
				for each (var twit:Object in timeline){
					if(t.id==twit.id) return;
				}
				timeline.push(t);
				timeline.sortOn("id",Array.DESCENDING | Array.NUMERIC);
				add_to_all(t);
			}
		}
		private function add_to_all(t:Object):void{
			if(a_timelines["&&All"]==null){
				a_timelines["&&All"]=new Array(t);
			}else{
				a_timelines["&&All"].push(t);
				a_timelines["&&All"].sortOn("id",Array.DESCENDING | Array.NUMERIC);
			}
		}				
		/** 
		 * convert a_timelines and a_key_ids to each other
		 * a_key_ids for storage to file
		 * a_timelines for run time
		 */
		// called at save time
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
		
		// called at load time
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