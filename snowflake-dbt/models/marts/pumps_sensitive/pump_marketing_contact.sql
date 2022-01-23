{{ config(
    tags=["mnpi_exception"]
) }}

SELECT

  -- MAPPED COLUMNS: ANY ADDITIONAL COLUMNS SHOULD BE ADDED TO THE END OF THIS LIST
  company_name,
  country,
  customer_db_confirmed_date,
  customer_db_created_date,
  customer_db_customer_id,
  days_since_saas_signup_bucket,
  days_since_saas_trial_ended_bucket,
  days_since_self_managed_owner_signup_bucket,
  dim_marketing_contact_id,
  email_address,
  first_name,
  gitlab_dotcom_active_state,
  gitlab_dotcom_confirmed_date,
  gitlab_dotcom_created_date,
  IFNULL(gitlab_dotcom_email_opted_in, FALSE) AS gitlab_dotcom_email_opted_in,
  gitlab_dotcom_last_login_date,
  gitlab_dotcom_user_id,
  gitlab_user_name,
  group_member_of_saas_bronze_tier,
  group_member_of_saas_free_tier,
  group_member_of_saas_premium_tier,
  group_member_of_saas_trial,
  group_member_of_saas_ultimate_tier,
  group_owner_of_saas_bronze_tier,
  group_owner_of_saas_free_tier,
  group_owner_of_saas_premium_tier,
  group_owner_of_saas_trial,
  group_owner_of_saas_ultimate_tier,
  individual_namespace_is_saas_bronze_tier,
  individual_namespace_is_saas_free_tier,
  individual_namespace_is_saas_premium_tier,
  individual_namespace_is_saas_trial,
  individual_namespace_is_saas_ultimate_tier,
  is_customer_db_owner,
  is_customer_db_user,
  is_gitlab_dotcom_user,
  is_group_namespace_member,
  is_group_namespace_owner,
  is_individual_namespace_owner,
  is_paid_tier,
  is_self_managed_premium_tier,
  is_self_managed_starter_tier,
  is_self_managed_ultimate_tier,
  is_zuora_billing_contact,
  last_name,
  responsible_for_free_tier_only,
  responsible_for_group_saas_bronze_tier,
  responsible_for_group_saas_free_tier,
  responsible_for_group_saas_premium_tier,
  responsible_for_group_saas_trial,
  responsible_for_group_saas_ultimate_tier,
  zuora_active_state,
  zuora_contact_id,
  zuora_created_date,

  -- METADATA COLUMNS FOR USE IN PUMP (NOT INTEGRATION)
  last_changed

FROM {{ ref('mart_marketing_contact' )}}
WHERE rlike(email_address, '^[A-Z0-9.+_%-]+@[A-Z0-9.-]+\\.[A-Z]+$','i')