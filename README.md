# Fetch-Rewards-Analytics-Engineer-Coding-Exercise
This repository contains my submission for the Fetch Rewards Coding Exercise. It involves data modeling, SQL query generation, data quality analysis, and stakeholder communication.

## Contents
- *data_model*: Contains the relational data model diagram developed from the provided unstructured JSON data.
- *sql_queries*: SQL queries crafted to answer specific business questions.
- *data_quality*: Analysis of data quality issues identified in the provided datasets and suggestions for improvement.
- *communication*: A mockup communication intended for business stakeholders, addressing the findings and suggesting next steps.

## Tools used
- Data Quality Checks - ***Python***
- SQL Quesries - ***T-SQL***
- Data Extraction - ***Python***
- Initital Data Analysis - ***Excel***

## Data Quality Findings
***Receipts Dataset***
- Significant Null Values: Key fields such as finishedDate, purchaseDate, totalSpent, and purchasedItemCount show substantial percentages of null values. This affects the consistency and completeness of the dataset, complicating analyses on purchase behavior and financial metrics.
- Data Consistency and Accuracy Concerns: Absence of zero values in pointsEarned suggests missing data for transactions where points should have been captured.
- Impact on Analysis: These issues hinder accurate analysis of customer loyalty, purchasing behavior, engagement, and the effectiveness of promotional offers.

***Users Dataset***
- Redundant Records: More than 50% of the user records are duplicates, potentially skewing analysis and affecting marketing efficiency.
- Missing Information: Null values in signUpSource and state could impact the evaluation of marketing strategies and user segmentation. The dataset indicates a high concentration of users in Wisconsin, pointing to possible regional biases in data collection or user acquisition.

***Brands Dataset***
- Category and Brand Identification: A large proportion of records lack topBrand and categoryCode, crucial for brand promotion and category-level analysis. Furthermore, 13% null values in category could obscure brand performance insights.
- Brand Code Discrepancies: Missing or inconsistent brandCode entries complicate brand identification and performance analysis. Inconsistencies in special characters and case sensitivity between the name and brandCode columns indicate potential challenges in matching and analysis.
- Overall Impacts on Business: These data quality issues can significantly affect the reliability of business analytics, including customer behavior analysis, financial forecasting, marketing strategy evaluation, and brand performance analysis. Ensuring data integrity, completeness, and accuracy is paramount for informed decision-making and strategic planning.

### For any questions or further discussion, feel free to reach out. Your insights and feedback are always welcome!
Charan Teja Vangapandu
charantejavangapandu@gmail.com
