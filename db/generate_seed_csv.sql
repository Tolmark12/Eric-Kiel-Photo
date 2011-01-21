-- This can be run to retrieve the csv to upload to bento/seed/index to populate mongoDB 
SELECT * FROM
((SELECT e.`entity_id`, evset.`attribute_set_name`, attr.`attribute_code`, eval.`value` FROM vladmin_template_entity e 
	INNER JOIN `eav_attribute_set` evset on e.`attribute_set_id` = evset.`attribute_set_id`
	INNER join `eav_entity_attribute` eattr on evset.`attribute_set_id`  = eattr.`attribute_set_id`
	INNER join `eav_attribute` attr on attr.`attribute_id`  = eattr.`attribute_id`
	INNER join `vladmin_template_entity_varchar` eval on e.`entity_id` = eval.`entity_id` and  eattr.`attribute_id` = eval.`attribute_id`) 
UNION
(SELECT e.`entity_id`, evset.`attribute_set_name`, attr.`attribute_code`, eval.`value` FROM vladmin_template_entity e 
	INNER JOIN `eav_attribute_set` evset on e.`attribute_set_id` = evset.`attribute_set_id`
	INNER join `eav_entity_attribute` eattr on evset.`attribute_set_id`  = eattr.`attribute_set_id`
	INNER join `eav_attribute` attr on attr.`attribute_id`  = eattr.`attribute_id`
    INNER join `vladmin_template_entity_text` eval on e.`entity_id` = eval.`entity_id` and  eattr.`attribute_id` = eval.`attribute_id`)
UNION
(SELECT e.`entity_id`, evset.`attribute_set_name`, attr.`attribute_code`, eval.`value` FROM vladmin_template_entity e 
	INNER JOIN `eav_attribute_set` evset on e.`attribute_set_id` = evset.`attribute_set_id`
	INNER join `eav_entity_attribute` eattr on evset.`attribute_set_id`  = eattr.`attribute_set_id`
	INNER join `eav_attribute` attr on attr.`attribute_id`  = eattr.`attribute_id`
	INNER join `vladmin_template_entity_int` eval on e.`entity_id` = eval.`entity_id` and  eattr.`attribute_id` = eval.`attribute_id`)
UNION
(SELECT `photo_id` as `entity_id`, 'stock_photo' as `attribute_set_name`, 'name' as `attribute_code`, `name` as `value` 
	FROM `stock_photo`) 
UNION
(SELECT `photo_id` as `entity_id`, 'stock_photo' as `attribute_set_name`, 'image' as `attribute_code`, `image` as `value` 
	FROM `stock_photo`)
UNION
(SELECT `photo_id` as `entity_id`, 'stock_photo' as `attribute_set_name`, 'small_width' as `attribute_code`, `small_width` as `value` 
	FROM `stock_photo`)
UNION
(SELECT `photo_id` as `entity_id`, 'stock_photo' as `attribute_set_name`, 'mid_width' as `attribute_code`, `mid_width` as `value` 
	FROM `stock_photo`)
UNION
(SELECT `photo_id` as `entity_id`, 'stock_photo' as `attribute_set_name`, 'large_width' as `attribute_code`, `large_width` as `value` 
	FROM `stock_photo`)) vals
ORDER BY attribute_set_name, entity_id