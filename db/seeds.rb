# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

{"entity_id":"13","name":"Navigation","pages":

[{"entity_id":"24","name":"nav item - Stock",
  "text":"Stock",
  "url_id":"\/stock",
  "page_type":"stock",
  "sort":"003"},
{"entity_id":"148","name":"Nav Item - Reel",
  "text":"Film Reel",
  "url_id":"\/films",
  "page_type":"portfolio",
  "sort":"002"},
{"entity_id":"16","name":"nav item - Portfolio",
  "text":"Portfolio","url_id":"\/portfolio","page_type":"portfolio","is_default":"true","sub":
  {"entity_id":"18","name":"nav item - Portfolio - subnav","pages":
    [{"entity_id":"21","name":"sub nav item - Portfolio\/Places","text":"Places","url_id":"\/portfolio\/places","page_type":"filter","nav_filter_tag":"places","sort":"12"}
    ,{"entity_id":"20","name":"sub nav item - Portfolio\/People","text":"People","url_id":"\/portfolio\/people","page_type":"filter","nav_filter_tag":"people","sort":"11"},
    {"entity_id":"19","name":"sub nav item - Portfolio\/Current","text":"Current","url_id":"\/portfolio\/current","page_type":"filter","nav_filter_tag":"current","sort":"10"},
    {"entity_id":"23","name":"sub nav item - Portfolio\/ View All","text":"View All","url_id":"\/portfolio\/all","page_type":"filter","nav_filter_tag":"all","sort":"14"},
    {"entity_id":"22","name":"sub nav item - Portfolio\/Motion","text":"Motion","url_id":"\/portfolio\/motion","page_type":"filter","nav_filter_tag":"motion","sort":"13"}],
  "kind":"subNav"},"sort":"001"},
  {"entity_id":"147","name":"nav item - Blog","text":"Blog","url_id":"http:\/\/blog.kielphoto.com\/","page_type":"external","sort":"005"},
  {"entity_id":"15","name":"nav item - Home","data_service":"http:\/\/www.kielphoto.com\/vladmin\/api\/index\/template\/3","text":"Home","url_id":"\/","is_logo":"true","sort":"000"},
  {"entity_id":"105","name":"nav item - Tear sheets","data_service":"http:\/\/www.kielphoto.com\/vladmin\/api\/index\/template\/106","text":"Campaigns","url_id":"\/tear_sheets","page_type":"portfolio","sort":"004"},
  {"entity_id":"27","name":"nav item - Contact","text":"Contact","url_id":"\/contact","page_type":"none","sub":
    {"entity_id":"28","name":"sub - Contact","kind":"contact"},
  "sort":"006"}]}