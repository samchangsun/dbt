{{ config({
    "materialized": "incremental",
    "unique_key": "project_id"
    })
}}


SELECT *
FROM {{ source('gitlab_dotcom', 'container_expiration_policies') }}
{% if is_incremental() %}

WHERE updated_at >= (SELECT MAX(updated_at) FROM {{this}})

{% endif %}
QUALIFY ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY updated_at DESC) = 1
