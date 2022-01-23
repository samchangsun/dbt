WITH version_usage_data AS (

  SELECT * 
  FROM {{ ref('version_usage_data') }}

)

SELECT DISTINCT
  f.path                     AS ping_name,
  REPLACE(f.path, '.','_')   AS full_ping_name
FROM version_usage_data,
lateral flatten(input => version_usage_data.stats_used, recursive => True) f
WHERE IS_OBJECT(f.value) = FALSE
-- error when listed items pops up. 
-- more details in the issue https://gitlab.com/gitlab-data/analytics/-/issues/10749
-- This is a temporary solution and this hard-coded values should be removed.
AND full_ping_name NOT IN ('groups_bugdb_active',
                           'groups_shimo_active',
                           'groups_inheriting_bugdb_active',
                           'projects_bugdb_active',
                           'projects_inheriting_shimo_active',
                           'projects_inheriting_bugdb_active',
                           'projects_shimo_active',
                           'instances_shimo_active',
                           'license_scanning_jobs',
                           'templates_bugdb_active')
AND full_ping_name NOT ILIKE ('%_BUGDB_%')
AND full_ping_name NOT ILIKE ('%_SHIMO_%')