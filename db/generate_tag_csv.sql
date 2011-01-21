-- This can be run to retrieve the tag csv to upload to bento/tags/index to populate mongoDB 
SET SESSION group_concat_max_len = 4096;
select sp.`name` as 'Filename', GROUP_CONCAT(DISTINCT spt.`name` ORDER BY spt.`name` DESC SEPARATOR ';') as 'Keywords'
from `stock_photo` sp 
inner join `stock_photo_tag_link` spl on sp.`photo_id` = spl.`photo_id` 
inner join `stock_photo_tag` spt on spl.`tag_id` = spt.`tag_id` 
group by sp.`name` 
order by sp.`name`;