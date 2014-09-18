package com.gearbrother.sheepwolf.test;

import java.net.URI;
import java.util.Arrays;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

public class HelloCouchbase {

	public static void main(String[] args) throws Exception {
		// (Subset) of nodes in the cluster to establish a connection
		List<URI> hosts = Arrays.asList(new URI("http://127.0.0.1:8091/pools"));
		// Name of the Bucket to connect to
		String bucket = "beer-sample";
		// Password of the bucket (empty) string if none
		String password = "";
		// Connect to the Cluster
//		CouchbaseClient client = new CouchbaseClient(hosts, bucket, password);
//		ObjectMapper om = new ObjectMapper();
//		long start = System.currentTimeMillis();
//		for (int i = 0; i < 100000; i++) {
//			String g = (String) client.get("21st_amendment_brewery_cafe-north_star_red");
//			Beer parent = om.readValue(g, Beer.class);
//			Beer child = om.readValue(g, Beer.class);
//			parent.nextBeer = child;
//			String s = om.writeValueAsString(parent);
//			System.out.println(parent);
//			System.out.println(s);
//		}
//		System.out.println(System.currentTimeMillis() - start);
//		View view = client.getView("beer", "brewery_beers");
//		Query query = new Query();
//		query.setKey("esb");
//		query.setSkip(2);
//		query.setLimit(1);
//		query.setReduce(true);
//		query.setReduce(false);
//		query.setGroupLevel(1);
//		query.setGroup(true);
//		ViewResponse res = client.query(view, query);
//		for (Iterator<ViewRow> iterator = res.iterator(); iterator.hasNext();) {
//			ViewRow row = (ViewRow) iterator.next();
//			System.out.println(row.getKey() + ", " +   row.getValue());
//		}
		// Shutting down properly
//		client.shutdown();
	}
}
class Beer {
	public String name;
	public double abv;
	public double ibu;
	public double srm;
	public double upc;
	public String type;
	@JsonProperty("brewery_id")
	public String id;
	public String updated;
	public String description;
	public String style;
	public String category;
	@JsonProperty("next")
	public Beer nextBeer;
}