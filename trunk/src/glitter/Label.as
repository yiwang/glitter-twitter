package glitter
{
	import mx.collections.ArrayCollection;
		
	dynamic public class Label
	{
		private var statuses:ArrayCollection;
		private var name:String;
		private var filters:ArrayCollection;
		
		public function Label(name:String)
		{
			this.name = name;
			statuses = new ArrayCollection();
			filters = new ArrayCollection();
			var j:Filter = new Filter();
			this.addFilter(j);
			this.addFilter(new Filter());
		}
		
		public function setName(name:String):void {
			this.name = name;
		}
		
		public function addFilter(filter:Filter):void{
			filters.addItem(filter);
		}
		
		public function addStatus(newStatus:Status):void {
			// avoid duplicate
			for each (var status:Status in statuses){
				if(newStatus.getId()==status.getId() ) return;
			}
			statuses.addItemAt(newStatus, 0);
//			sortStatuses();
		}
		
		public function getStatuses():ArrayCollection {
//			var sortField:SortField = new SortField();
//			sortField.name = "getId";
//			sortField.numeric = true;
//			var sort:Sort = new Sort();
//			sort.reverse();
//			sort.fields = [sortField];
//			statuses.sort = sort;
//			statuses.refresh();
			return statuses;
		}
		
		private function sortStatuses():void{
			statuses = new ArrayCollection(statuses.toArray().sortOn("id",Array.DESCENDING));
		}
		
		public function clearStatuses():void{
			statuses = new ArrayCollection();
		}
		
		public function getName():String {
			return name;
		}
		
		public function insertStatusesThatMatchFilters(statuses:ArrayCollection):void {
			for each (var status:Status in statuses) {
				for each (var filter:Filter in filters) {
					if (filter.statusMatchesFilter(status)) {
						addStatus(status);
					}
				}
			}
			sortStatuses();
		}
		
		public function toJSON():String{
			var s:String = "{\n";
			s += '"name":"' + this.name +'",\n';
			s += '"statuses":[\n'+ this.statusesToJSON() + '],\n';
			s += '"filters":[\n'+ this.filtersToJSON() + ']';
			s += "}";
			return s; 
		}
		
		private function statusesToJSON():String{
			var s:String = "";
			for each (var status:Status in this.statuses){
				s += status.toJSON() + ",\n";
			}
			return s.substr(0,s.length-2);
		}
		
		private function filtersToJSON():String{
			var s:String = "";
			for each (var filter:Filter in this.filters){
				s += filter.toJSON() + ",\n";
			}
			return s.substr(0,s.length-2);			
		}
		
		static public function fromObj(o:Object):Label{
			var label:Label = new Label(o.name);
			label.statuses = new ArrayCollection();
			label.filters = new ArrayCollection();			
			for each (var item:Object in o.statuses){
				label.statuses.addItem(new Status(item));
			}
			for each (var f:Object in o.filters){
				label.filters.addItem(Filter.fromObj(f));
			}
			return label;
		}
	}
}