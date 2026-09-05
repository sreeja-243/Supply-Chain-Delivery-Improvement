 /*
============================================================
PROJECT: SUPPLY CHAIN & DELIVERY PERFORMANCE IMPROVEMENT
ROLE: BUSINESS ANALYST
TOOLS: PostgreSQL, Excel, Jira

DATASET:
DataCo SMART Supply Chain Dataset

BUSINESS OBJECTIVE:
Analyze delivery performance and identify areas requiring
operational investigation and improvement.

RAW DATA:
180,519 records
53 columns
65,752 unique orders

ANALYSIS GRAIN:
Order ID for delivery-performance analysis.

DELIVERY PERFORMANCE RULE:

1. Canceled
   Delivery Status = 'Shipping canceled'

2. Delayed
   Actual shipping days > scheduled shipping days

3. On-Time
   Actual shipping days <= scheduled shipping days

CANCELED ORDERS:
Excluded from delay-rate and on-time-rate calculations.

DELAY RATE:
Delayed Orders / Delivery-Eligible Orders * 100

ANALYSIS AREAS:
- Overall delivery performance
- Region
- Shipping mode
- Product category
- Time
- Financial/order metrics
- Cross-analysis

LIMITATIONS:
- Historical dataset
- Not real-time
- Dataset does not contain Shipping Cost
- Observed patterns do not independently establish causation
============================================================
*/
SELECT COUNT(*) AS total_rows
FROM dataco_raw;

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM dataco_raw;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM dataco_raw;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,

    COUNT(*) FILTER (WHERE order_region IS NULL) AS null_region,

    COUNT(*) FILTER (WHERE shipping_mode IS NULL) AS null_shipping_mode,

    COUNT(*) FILTER (WHERE category_name IS NULL) AS null_category,

    COUNT(*) FILTER (WHERE delivery_status IS NULL) AS null_delivery_status,

    COUNT(*) FILTER (WHERE days_for_shipping_real IS NULL)
        AS null_actual_shipping_days,

    COUNT(*) FILTER (WHERE days_for_shipment_scheduled IS NULL)
        AS null_scheduled_shipping_days

FROM dataco_raw;

SELECT
    delivery_status,
    COUNT(*) AS row_count
FROM dataco_raw
GROUP BY delivery_status
ORDER BY row_count DESC;

SELECT
    shipping_mode,
    COUNT(*) AS row_count
FROM dataco_raw
GROUP BY shipping_mode
ORDER BY row_count DESC;

SELECT
    order_region,
    COUNT(*) AS row_count
FROM dataco_raw
GROUP BY order_region
ORDER BY row_count DESC;

SELECT
    category_name,
    COUNT(*) AS row_count
FROM dataco_raw
GROUP BY category_name
ORDER BY row_count DESC;

SELECT
    order_id,
    COUNT(*) AS line_items
FROM dataco_raw
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY line_items DESC
LIMIT 20;

CREATE TABLE order_level AS

SELECT
    order_id,
    order_region,
    shipping_mode,
    category_name,
    customer_segment,
    market,
    order_country,
    order_date_dateorders,
    delivery_status,
    days_for_shipping_real,
    days_for_shipment_scheduled,
    sales,
    order_profit_per_order,
    benefit_per_order,
    order_item_quantity,

    CASE
        WHEN delivery_status = 'Shipping canceled'
            THEN 'Canceled'

        WHEN days_for_shipping_real > days_for_shipment_scheduled
            THEN 'Delayed'

        ELSE 'On-Time'
    END AS delivery_performance

FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY order_item_id
        ) AS rn

    FROM dataco_raw
) AS ranked

WHERE rn = 1;

SELECT COUNT(*) AS order_level_records
FROM order_level;

SELECT
    delivery_performance,
    COUNT(*) AS orders
FROM order_level
GROUP BY delivery_performance
ORDER BY orders DESC;

SELECT
    COUNT(*) AS incorrectly_classified_orders
FROM order_level
WHERE
    (
        delivery_status = 'Shipping canceled'
        AND delivery_performance <> 'Canceled'
    )
    OR
    (
        delivery_status <> 'Shipping canceled'
        AND days_for_shipping_real > days_for_shipment_scheduled
        AND delivery_performance <> 'Delayed'
    )
    OR
    (
        delivery_status <> 'Shipping canceled'
        AND days_for_shipping_real <= days_for_shipment_scheduled
        AND delivery_performance <> 'On-Time'
    );

	SELECT

    COUNT(*) AS total_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Canceled'
    ) AS canceled_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance <> 'Canceled'
    ) AS delivery_eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        NULLIF(
            COUNT(*) FILTER (
                WHERE delivery_performance <> 'Canceled'
            ),
            0
        ),
        2
    ) AS delay_rate_percent,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'On-Time'
        )
        /
        NULLIF(
            COUNT(*) FILTER (
                WHERE delivery_performance <> 'Canceled'
            ),
            0
        ),
        2
    ) AS on_time_rate_percent,

    ROUND(
        AVG(days_for_shipping_real) FILTER (
            WHERE delivery_performance <> 'Canceled'
        ),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled) FILTER (
            WHERE delivery_performance <> 'Canceled'
        ),
        2
    ) AS avg_scheduled_shipping_days

FROM order_level;

SELECT
    order_region,

    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent,

    ROUND(
        AVG(days_for_shipping_real),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled),
        2
    ) AS avg_scheduled_shipping_days

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY order_region

ORDER BY delay_rate_percent DESC;

SELECT
    order_region,
    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY order_region

ORDER BY delay_rate_percent DESC

LIMIT 10;

SELECT
    shipping_mode,

    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent,

    ROUND(
        AVG(days_for_shipping_real),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled),
        2
    ) AS avg_scheduled_shipping_days

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY shipping_mode

ORDER BY delay_rate_percent DESC;

SELECT
    category_name,

    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY category_name

ORDER BY delay_rate_percent DESC;

SELECT

    EXTRACT(YEAR FROM order_date_dateorders) AS order_year,

    EXTRACT(MONTH FROM order_date_dateorders) AS order_month,

    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY
    EXTRACT(YEAR FROM order_date_dateorders),
    EXTRACT(MONTH FROM order_date_dateorders)

ORDER BY
    order_year,
    order_month;

	WITH monthly_performance AS (

    SELECT

        EXTRACT(YEAR FROM order_date_dateorders) AS order_year,

        EXTRACT(MONTH FROM order_date_dateorders) AS order_month,

        ROUND(
            100.0 *
            COUNT(*) FILTER (
                WHERE delivery_performance = 'Delayed'
            )
            /
            COUNT(*),
            2
        ) AS delay_rate_percent

    FROM order_level

    WHERE delivery_performance <> 'Canceled'

    GROUP BY
        EXTRACT(YEAR FROM order_date_dateorders),
        EXTRACT(MONTH FROM order_date_dateorders)
)

SELECT *
FROM monthly_performance
ORDER BY delay_rate_percent DESC
LIMIT 1;

WITH monthly_performance AS (

    SELECT

        EXTRACT(YEAR FROM order_date_dateorders) AS order_year,

        EXTRACT(MONTH FROM order_date_dateorders) AS order_month,

        ROUND(
            100.0 *
            COUNT(*) FILTER (
                WHERE delivery_performance = 'Delayed'
            )
            /
            COUNT(*),
            2
        ) AS delay_rate_percent

    FROM order_level

    WHERE delivery_performance <> 'Canceled'

    GROUP BY
        EXTRACT(YEAR FROM order_date_dateorders),
        EXTRACT(MONTH FROM order_date_dateorders)
)

SELECT *
FROM monthly_performance
ORDER BY delay_rate_percent
LIMIT 1;

SELECT
    delivery_performance,

    COUNT(*) AS orders,

    ROUND(
        AVG(sales),
        2
    ) AS avg_sales,

    ROUND(
        AVG(order_profit_per_order),
        2
    ) AS avg_profit_per_order,

    ROUND(
        AVG(benefit_per_order),
        2
    ) AS avg_benefit_per_order,

    ROUND(
        AVG(order_item_quantity),
        2
    ) AS avg_item_quantity

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY delivery_performance;

SELECT
    shipping_mode,

    COUNT(*) AS eligible_orders,

    ROUND(
        AVG(sales),
        2
    ) AS avg_sales,

    ROUND(
        AVG(order_profit_per_order),
        2
    ) AS avg_profit_per_order,

    ROUND(
        AVG(order_item_quantity),
        2
    ) AS avg_item_quantity

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY shipping_mode

ORDER BY avg_profit_per_order DESC;

SELECT
    order_region,
    shipping_mode,

    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY
    order_region,
    shipping_mode

HAVING COUNT(*) >= 50

ORDER BY delay_rate_percent DESC;

SELECT
    order_region,
    category_name,

    COUNT(*) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        COUNT(*),
        2
    ) AS delay_rate_percent

FROM order_level

WHERE delivery_performance <> 'Canceled'

GROUP BY
    order_region,
    category_name

HAVING COUNT(*) >= 30

ORDER BY delay_rate_percent DESC;

SELECT
    order_id,
    order_region,
    shipping_mode,
    category_name,

    days_for_shipping_real,
    days_for_shipment_scheduled,

    days_for_shipping_real
        - days_for_shipment_scheduled
        AS shipping_delay_days

FROM order_level

WHERE delivery_performance = 'Delayed'

ORDER BY shipping_delay_days DESC

LIMIT 20;

SELECT

    ROUND(
        AVG(days_for_shipping_real),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled),
        2
    ) AS avg_scheduled_shipping_days,

    ROUND(
        AVG(days_for_shipping_real)
        -
        AVG(days_for_shipment_scheduled),
        2
    ) AS average_shipping_gap

FROM order_level

WHERE delivery_performance <> 'Canceled';

DROP VIEW IF EXISTS delivery_kpi_summary;

CREATE VIEW delivery_kpi_summary AS

SELECT

    COUNT(*) AS total_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Canceled'
    ) AS canceled_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance <> 'Canceled'
    ) AS eligible_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'Delayed'
    ) AS delayed_orders,

    COUNT(*) FILTER (
        WHERE delivery_performance = 'On-Time'
    ) AS on_time_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'Delayed'
        )
        /
        NULLIF(
            COUNT(*) FILTER (
                WHERE delivery_performance <> 'Canceled'
            ),
            0
        ),
        2
    ) AS delay_rate_percent,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE delivery_performance = 'On-Time'
        )
        /
        NULLIF(
            COUNT(*) FILTER (
                WHERE delivery_performance <> 'Canceled'
            ),
            0
        ),
        2
    ) AS on_time_rate_percent,

    ROUND(
        AVG(days_for_shipping_real) FILTER (
            WHERE delivery_performance <> 'Canceled'
        ),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(days_for_shipment_scheduled) FILTER (
            WHERE delivery_performance <> 'Canceled'
        ),
        2
    ) AS avg_scheduled_shipping_days

FROM order_level;

SELECT *
FROM delivery_kpi_summary;


/*
============================================================
KEY BUSINESS FINDINGS
============================================================

1. OVERALL DELIVERY PERFORMANCE
57.31% of delivery-eligible orders were delayed.

2. REGIONAL PERFORMANCE
Central Africa recorded the highest observed delay rate
at approximately 60.04%, while Canada recorded the lowest
at approximately 52.58%.

3. SHIPPING METHOD
First Class recorded an observed delay rate of 100%.
Second Class recorded approximately 79.99%.
Standard Class recorded approximately 39.85%.

4. PRODUCT CATEGORY
Several product categories recorded delay rates above 60%.
These categories should be investigated alongside order
volume, region and shipping method.

5. TIME PERFORMANCE
Monthly delay rates remained consistently high,
generally around 55%-60%.

6. SHIPPING GAP
Average actual shipping time was approximately 3.50 days,
compared with approximately 2.94 scheduled days.

7. FINANCIAL COMPARISON
On-time orders showed slightly higher average profit/order
than delayed orders.

8. BUSINESS IMPLICATION
Delivery performance should be monitored across region,
shipping method, product category and time.

9. RECOMMENDATION APPROACH
High-delay regions, shipping methods and categories should
be investigated to identify potential operational
improvement areas.

10. LIMITATION
These analyses identify patterns and areas requiring
investigation. They do not independently establish
root causes or causation.
============================================================
*/

/*
============================================================
SQL METHODOLOGY
============================================================

1. Raw Data Validation
   - Checked total records.
   - Checked unique Order IDs.
   - Checked missing values.
   - Reviewed categorical values.

2. Data Transformation
   - Converted line-item data into an order-level dataset.
   - Used one representative record per Order ID for
     delivery-performance analysis.

3. Delivery Classification
   - Canceled: Shipping canceled.
   - Delayed: Actual shipping days > scheduled days.
   - On-Time: Actual shipping days <= scheduled days.

4. KPI Calculation
   - Delay Rate = Delayed / Eligible Orders * 100.
   - On-Time Rate = On-Time / Eligible Orders * 100.

5. Segmentation
   - Region
   - Shipping Mode
   - Product Category
   - Time

6. Additional Analysis
   - Shipping-time gap
   - Financial/order metrics
   - Region + Shipping Mode
   - Region + Category

7. Validation
   - SQL results were compared with Excel analysis.

============================================================
*/