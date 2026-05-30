# Customer Churn Analysis — SQL Project

## Problem Statement
Telecom company losing customers every month.
Goal: Identify churn patterns using SQL queries.

## Dataset
- Source: Kaggle — IBM Telco Customer Churn
- Size: 7,032 customers, 21 features
- Database: PostgreSQL

## Tools Used
PostgreSQL, pgAdmin4

## SQL Concepts Used
- GROUP BY, ORDER BY
- Window Functions (OVER, PARTITION BY)
- CASE WHEN statements
- Aggregate Functions (AVG, SUM, COUNT)
- CTEs

## Key Findings
1. 26.58% overall churn rate — 1 in 4 customers leaving
2. Month-to-month customers churn 42.71% — highest among all contract types
3. New customers (0-6 months) have 54.71% churn rate
4. Churned customers paid higher avg charges ($74.44)
5. Monthly revenue loss: $139,130 | Yearly: $1,669,570
6. Fiber optic customers churn 41.89%
7. Senior citizens churn 41.68% vs 23.6% non-seniors

## Business Recommendations
1. Incentivize long-term contracts with discounts
2. Improve onboarding for new customers
3. Create retention offers for high-paying customers
4. Investigate fiber optic pricing and quality
5. Design senior citizen retention programs

## Business Impact
Identified $1,669,570 yearly revenue loss through
SQL analysis — actionable insights provided to
reduce churn and retain high-value customers
