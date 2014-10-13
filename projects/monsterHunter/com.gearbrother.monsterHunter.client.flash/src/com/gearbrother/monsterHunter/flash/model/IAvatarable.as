package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GBmdDefinition;

	public interface IAvatarable {
		function get definitionStand():GBmdDefinition;
		
		function get definitionMove():GBmdDefinition;
		
		function get definitionADMovie():GBmdDefinition;
		
		function get definitionApMovie():GBmdDefinition;
	}
}
