terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.22.0"
    }
  }
}

resource snowflake_user user {
  name         = "chang sun"
  login_name   = "changsun"
  comment      = "A user of snowflake."
  password     = "Hongluan4006"
  disabled     = false
  display_name = "changsun"
  email        = "user@snowflake.example"
  first_name   = "chang"
  last_name    = "sun"

  default_warehouse = "WH_XSMALL"
  default_role      = "sysadmin"

  must_change_password = false
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

resource "snowflake_database" "demo_db" {
  provider = snowflake.sys_admin
  name     = "DEMO_DB"
}

resource "snowflake_warehouse" "WH_XSMALL" {
  provider       = snowflake.sys_admin
  name           = "DEMO_WH"
  warehouse_size = "xsmall"

  auto_suspend = 60
}
