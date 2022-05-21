-module(covid).
-export([init/0, fetch/0, fetchBody/0, dallasRows/0, dallasToday/0, todaysNumbers/1, canDaveGoOut/0, filterRows/1]).

init() ->
	application:start(inets),
	application:start(crypto),
	application:start(asn1),
	application:start(public_key),
	application:start(ssl).

fetch() ->
	httpc:request(get, {
						"https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-recent.csv", []
					   },
				  [{ssl,[{verify,verify_none}]}], []
				 ).

fetchBody() ->
	{_, {_, _, Body}} = fetch(),
	Body.

filterRows(CityCounty) ->
	[X || X <- string:tokens(fetchBody(), "\n"), string:find(X, CityCounty) /= nomatch].


dallasRows() ->
	filterRows("Dallas,Texas").

dallasToday() ->
	list_to_tuple(string:tokens(lists:last(lists:sort(dallasRows())), ",")).

todaysNumbers(Record) ->
	{element(1, Record), element(7, Record)}.

canDaveGoOut() ->
	todaysNumbers(dallasToday()).
