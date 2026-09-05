# Supply Chain & Delivery Improvement

## Business Analyst Project

**Role:** Business Analyst  
**Business Area:** Supply Chain & Logistics  
**Dataset:** DataCo Smart Supply Chain Dataset  
**Tools:** Excel, PostgreSQL, Jira, Business Analysis Techniques

---

## Project Overview

This project analyzes supply chain delivery performance to identify delays, understand operational patterns, and recommend process improvements.

The analysis focuses on delivery performance across regions, shipping modes, product categories, and time periods. Business analysis techniques were used to translate the findings into requirements, process improvements, user stories, and actionable recommendations.

---

## Business Problem

The organization lacks clear visibility into delivery performance and the factors associated with delayed orders.

High delivery delays can affect:

- Customer satisfaction
- Operational efficiency
- Delivery planning
- Service-level performance
- Business profitability

The objective is to analyze delivery performance and identify areas where operational improvements can be prioritized.

---

## Business Objectives

- Measure overall delivery performance.
- Identify the proportion of delayed and on-time orders.
- Analyze delivery performance by region.
- Compare delivery performance across shipping modes.
- Identify product categories associated with higher delays.
- Analyze delivery trends over time.
- Compare actual shipping time with scheduled shipping time.
- Translate findings into business requirements and improvement recommendations.

---

## Key Business Questions

1. What percentage of eligible orders are delayed?
2. Which regions experience the highest delay rates?
3. Which shipping modes have the highest delay rates?
4. Which product categories show higher delivery delays?
5. Are delays consistent over time?
6. How does actual shipping time compare with scheduled shipping time?
7. Which areas should be prioritized for operational improvement?

---

## Key Findings

- **57.31%** of delivery-eligible orders were delayed.
- **42.69%** of delivery-eligible orders were delivered on time.
- **Central Africa** had the highest regional delay rate at approximately **60.04%**.
- **Canada** had the lowest regional delay rate at approximately **52.58%**.
- **First Class** had a **100% delay rate** in the analyzed data.
- **Second Class** had approximately **79.99%** delayed orders.
- **Standard Class** had approximately **39.85%** delayed orders.
- Monthly delay rates remained consistently high, generally around **55%–60%**.
- Average actual shipping time was **3.50 days**, compared with **2.94 scheduled days**.
- Several product categories showed delay rates above **60%** and should be investigated alongside order volume and region.

---

## Business Analysis Approach

### 1. Business Understanding

Defined the business problem, objectives, stakeholders, scope, assumptions, constraints, and success criteria.

### 2. Requirements Analysis

Documented business requirements, functional requirements, and non-functional requirements based on the identified business needs.

### 3. AS-IS Process Analysis

Reviewed the existing delivery process and identified visibility and monitoring gaps.

### 4. TO-BE Process

Designed an improved process focused on:

- Delivery performance monitoring
- Exception identification
- Regional and shipping-mode monitoring
- Performance reporting
- Continuous improvement

### 5. Data Analysis

Used Excel and PostgreSQL to analyze:

- Delivery KPIs
- Region
- Shipping mode
- Product category
- Time trends
- Order-level performance
- Delivery time gaps

### 6. Recommendations

Developed recommendations based on the identified delivery-performance patterns.

---

## Key KPIs

| KPI | Result |
|---|---:|
| Total Orders | 65,752 |
| Canceled Orders | 2,855 |
| Delivery-Eligible Orders | 62,897 |
| Delayed Orders | 36,048 |
| On-Time Orders | 26,849 |
| Delay Rate | 57.31% |
| On-Time Rate | 42.69% |
| Average Actual Shipping Time | 3.50 days |
| Average Scheduled Shipping Time | 2.94 days |

---

## Requirements & User Stories

The project includes documented:

- Business requirements
- Functional requirements
- Non-functional requirements
- User stories
- Acceptance criteria
- Stakeholder analysis
- AS-IS process
- TO-BE process

---

## Jira Implementation

Jira was used to demonstrate Agile requirements management.

### Jira Structure

- **Project:** Supply Chain & Delivery Improvement
- **Project Key:** SCDI
- **Methodology:** Scrum
- **Epics:** 3
- **User Stories:** 8
- **Tasks:** 13
- **Sprint:** Sprint 1 – Discovery & Analysis

---

## Tools Used

### Excel

Used for:

- Data validation
- Order-level analysis
- KPI calculations
- Pivot analysis
- Segmentation
- Delivery performance analysis

### PostgreSQL

Used for:

- Data transformation
- Order-level dataset creation
- KPI calculations
- Regional analysis
- Shipping-mode analysis
- Category analysis
- Time-based analysis
- Cross-analysis
- Validation

### Jira

Used for:

- Agile project management
- Epic creation
- User stories
- Acceptance criteria
- Task tracking
- Sprint planning

---

## Repository Contents

### Business Analysis Documentation

`Supply chain.pdf`

Contains:

- Business problem
- Objectives
- Stakeholder analysis
- Scope
- Requirements
- AS-IS process
- TO-BE process
- User stories
- Acceptance criteria
- Success metrics

### Excel Analysis

`DataCo_Supply_Chain_BA_Analysis.xlsb`

Contains the Excel-based delivery performance analysis.

### SQL Analysis

`Supply_Chain_Delivery_Performance_Analysis..sql`

Contains PostgreSQL queries for data transformation, KPI analysis, segmentation, cross-analysis, and findings.

---

## Data Limitations

The source dataset does **not contain a Shipping Cost field**. Therefore, shipping cost was not included in the quantitative analysis.

The identified patterns indicate areas for investigation but do not independently establish root causes of delivery delays.

---

## Recommendations

Based on the analysis:

1. Investigate high-delay shipping modes, particularly First Class and Second Class.
2. Prioritize regions with consistently higher delivery delays.
3. Investigate product categories with delay rates above 60%.
4. Monitor actual versus scheduled shipping performance.
5. Establish regular delivery KPI monitoring.
6. Use exception-based monitoring to identify high-risk delivery segments.
7. Investigate root causes before implementing operational changes.

---

## Expected Business Impact

The proposed improvements can help the organization:

- Improve delivery visibility
- Identify high-risk delivery segments
- Support proactive exception management
- Improve delivery planning
- Reduce recurring delivery delays
- Support data-driven operational decisions

---

## Project Outcome

This project demonstrates an end-to-end Business Analyst approach covering:

**Business Problem → Stakeholders → Requirements → AS-IS → TO-BE → Data Analysis → User Stories → Jira → Findings → Recommendations**
