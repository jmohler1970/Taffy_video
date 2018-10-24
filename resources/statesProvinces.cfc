component extends="taffy.core.resource" taffy_uri="/stateandprovince" {

function get(){

	return rep(queryToArray(
		EntityToQuery(EntityLoad("StatesProvinces", { Country = 'USA' }, "CountrySort, LongName"))
		));
	}

}
