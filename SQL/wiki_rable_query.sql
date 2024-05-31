SELECT post_title, post_content, ID, post_parent 
FROM itsg_posts 
WHERE post_status = 'publish' AND post_type = 'post' AND post_content != '';


SELECT p.ID, p.post_title, t.name, tt.taxonomy
FROM itsg_posts AS p
JOIN itsg_term_relationships AS tr ON p.ID = tr.object_id
JOIN itsg_term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
JOIN itsg_terms AS t ON tt.term_id = t.term_id
WHERE p.post_type = 'post' AND tt.taxonomy IN ('category', 'post_tag');



SELECT 
    p.ID, 
    p.post_title, 
    p.post_content, 
    t.name AS term_name,
    tt.taxonomy AS term_taxonomy,
    pm.meta_key,
    pm.meta_value
FROM itsg_posts AS p
LEFT JOIN itsg_term_relationships AS tr ON p.ID = tr.object_id
LEFT JOIN itsg_term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
LEFT JOIN itsg_terms AS t ON tt.term_id = t.term_id
LEFT JOIN itsg_postmeta AS pm ON p.ID = pm.post_id
WHERE 
    p.post_status = 'publish' AND 
    p.post_type = 'post' AND 
    p.post_content != '' AND
    tt.taxonomy IN ('category', 'post_tag');

   
SELECT 
    p.ID, 
	MAX(t.name) AS term_name,  -- Использование агрегатной функции MAX для гарантирования совместимости с режимом ONLY_FULL_GROUP_BY
    p.post_title, 
    p.post_content, 
    MAX(tt.taxonomy) AS term_taxonomy,  -- То же для term_taxonomy
    CONCAT('{', GROUP_CONCAT(CONCAT('"', pm.meta_key, '": "', pm.meta_value, '"') SEPARATOR ', '), '}') AS meta_json
FROM itsg_posts AS p
LEFT JOIN itsg_term_relationships AS tr ON p.ID = tr.object_id
LEFT JOIN itsg_term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id
LEFT JOIN itsg_terms AS t ON tt.term_id = t.term_id
LEFT JOIN itsg_postmeta AS pm ON p.ID = pm.post_id
WHERE 
    p.post_status = 'publish' AND 
    p.post_type = 'post' AND 
    p.post_content != '' AND
    tt.taxonomy IN ('category', 'post_tag')
GROUP BY p.ID, p.post_title, p.post_content, p.post_parent
ORDER BY term_name

