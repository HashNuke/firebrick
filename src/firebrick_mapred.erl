-module(firebrick_mapred).
-export([map_result/3, reduce_result/2]).

map_result(Obj, _, _)->
  [{riak_object:key(Obj), riak_object:get_value(Obj)}].

reduce_result(Objs, _)-> Objs.
