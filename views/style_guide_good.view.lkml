include: "products.view"
view: style_guide_good {
  sql_table_name: "PUBLIC"."ORDER_ITEMS" ;;
  drill_fields: [id]
  extends: [products]

  ## Parameters
  ## Developed in LookML
  parameter: order_status {  # https://docs.looker.com/reference/field-params/parameter
    label: "Order Status"
    allowed_value: {
      label: "Canceled"
      value: "Canceled"
    }
    allowed_value: {
      label: "Complete"
      value: "Complete"
    }
    allowed_value: {
      label: "Pending"
      value: "Pending"
    }
  }

  ## Filters
  ## Developed in LookML
  filter: brand {  # https://docs.looker.com/reference/field-params/filter
    view_label: "Product Properties"
    suggest_dimension: products.brand
  }

  ## Primary key
  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  ## Foreign keys and IDs
  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    view_label: "*_IDs"
  }
  ## Hidden
  dimension: inventory_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }
  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }
  ## Developed in LookML
  dimension: status_id {  # Created to demo order_by_field: parameter. Not expected to work
    hidden: yes
    type: number
    sql: ${TABLE}."STATUS_ID" ;;
  }

  ## Timestamps
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
    view_label: "Timestamps"
  }
  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
    view_label: "Timestamps"
  }
  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
    view_label: "Timestamps"
  }
  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
    view_label: "Timestamps"
  }

  ## Duration
  ## Developed in LookML
  dimension_group: ship_to_deliver {
    type: duration
    intervals: [
      minute
      , hour
      , day
      , week
    ]
    sql_start: ${shipped_raw} ;;
    sql_end: ${delivered_raw} ;;
    view_label: "Duration"  # Get peer feedback
    group_label: "Ship to Deliver Time"
    description: "Measures the time between EasyPost shipping confirmation and carrier delivery confirmation"
  }

  ## Flags
  ## Developed in LookML
  dimension: is_returned {
    type: yesno
    sql: ${returned_raw} IS NOT NULL ;;
    label: "Is Returned Item"
  }

  ## Statuses
  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
    order_by_field: status_id
  }

  ## Properties
  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  ## Metrics and KPIs
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  ## Developed in LookML
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    label: "Gross Merchandise Value"
  }

  ## Ratios


  ## Sets
  set: detail {
    fields: [
      order_items.id
      , inventory_items.product_name
      , inventory_items.id
      , users.last_name
      , users.id
      , users.first_nam
    ]
  }
}
