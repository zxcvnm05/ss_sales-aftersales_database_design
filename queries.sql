#sql1
WITH request_stats AS (
    SELECT
        product_id,
        COUNT(*) AS total_service_requests
    FROM ServiceRequest
    GROUP BY product_id
),
repair_stats AS (
    SELECT
        sr.product_id,
        COUNT(r.repair_id) AS total_repairs,
        COALESCE(SUM(r.cost), 0) AS total_repair_cost,
        COALESCE(AVG(r.cost), 0) AS avg_repair_cost
    FROM ServiceRequest sr
    LEFT JOIN Repair r
        ON sr.request_id = r.request_id
    GROUP BY sr.product_id
),
feedback_stats AS (
    SELECT
        product_id,
        COUNT(*) AS total_feedbacks,
        COALESCE(AVG(rating), 0) AS avg_rating
    FROM Feedback
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COALESCE(rs.total_service_requests, 0) AS total_service_requests,
    COALESCE(rep.total_repairs, 0) AS total_repairs,
    COALESCE(rep.total_repair_cost, 0) AS total_repair_cost,
    COALESCE(rep.avg_repair_cost, 0) AS avg_repair_cost,
    COALESCE(fs.total_feedbacks, 0) AS total_feedbacks,
    COALESCE(fs.avg_rating, 0) AS avg_rating
FROM Product p
LEFT JOIN request_stats rs
    ON p.product_id = rs.product_id
LEFT JOIN repair_stats rep
    ON p.product_id = rep.product_id
LEFT JOIN feedback_stats fs
    ON p.product_id = fs.product_id
ORDER BY
    total_service_requests DESC,
    total_repairs DESC,
    total_repair_cost DESC,
    avg_rating ASC;
#sql2
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(sr.request_id) AS total_service_requests,
    SUM(
        CASE
            WHEN LOWER(sr.status) NOT IN ('completed', 'resolved', 'closed') THEN 1
            ELSE 0
        END
    ) AS unresolved_requests,
    SUM(
        CASE
            WHEN r.repair_id IS NOT NULL
                 AND LOWER(r.status) NOT IN ('completed', 'closed') THEN 1
            ELSE 0
        END
    ) AS pending_repairs,
    ROUND(
        AVG(
            CASE
                WHEN LOWER(sr.status) NOT IN ('completed', 'resolved', 'closed')
                THEN CURRENT_DATE - sr.request_date
                ELSE NULL
            END
        ),
        2
    ) AS avg_unresolved_days
FROM Product p
LEFT JOIN ServiceRequest sr
    ON p.product_id = sr.product_id
LEFT JOIN Repair r
    ON sr.request_id = r.request_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
HAVING COUNT(sr.request_id) > 0
ORDER BY
    unresolved_requests DESC,
    pending_repairs DESC,
    avg_unresolved_days DESC;

#sql3
WITH revenue_stats AS (
    SELECT
        so.customer_id,
        COUNT(DISTINCT so.order_id) AS total_orders,
        COALESCE(SUM(p.amount), 0) AS total_revenue,
        COALESCE(AVG(so.total_amount), 0) AS avg_order_value
    FROM SalesOrder so
    LEFT JOIN Invoice i
        ON so.order_id = i.order_id
    LEFT JOIN Payment p
        ON i.invoice_id = p.invoice_id
    GROUP BY so.customer_id
),
service_stats AS (
    SELECT
        sr.customer_id,
        COUNT(DISTINCT sr.request_id) AS total_service_requests,
        COUNT(DISTINCT r.repair_id) AS total_repairs,
        COALESCE(SUM(r.cost), 0) AS total_repair_cost
    FROM ServiceRequest sr
    LEFT JOIN Repair r
        ON sr.request_id = r.request_id
    GROUP BY sr.customer_id
),
feedback_stats AS (
    SELECT
        customer_id,
        COUNT(*) AS total_feedbacks,
        COALESCE(AVG(rating), 0) AS avg_rating
    FROM Feedback
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.name,
    c.email,
    COALESCE(rs.total_orders, 0) AS total_orders,
    COALESCE(rs.total_revenue, 0) AS total_revenue,
    COALESCE(rs.avg_order_value, 0) AS avg_order_value,
    COALESCE(ss.total_service_requests, 0) AS total_service_requests,
    COALESCE(ss.total_repairs, 0) AS total_repairs,
    COALESCE(ss.total_repair_cost, 0) AS total_repair_cost,
    COALESCE(fs.total_feedbacks, 0) AS total_feedbacks,
    COALESCE(fs.avg_rating, 0) AS avg_rating
FROM Customer c
LEFT JOIN revenue_stats rs
    ON c.customer_id = rs.customer_id
LEFT JOIN service_stats ss
    ON c.customer_id = ss.customer_id
LEFT JOIN feedback_stats fs
    ON c.customer_id = fs.customer_id
ORDER BY
    total_revenue DESC,
    total_orders DESC,
    avg_rating DESC;