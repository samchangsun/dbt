WITH source AS (

    SELECT {{ hash_sensitive_columns('xactly_pos_part_assignment_source') }}
    FROM {{ ref('xactly_pos_part_assignment_source') }}

)

SELECT *
FROM source
