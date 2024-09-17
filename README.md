# Covid-19-Report-Project-
Purpose: Practice use-cases using Azure Tech-stack (ADF, Databricks ) + PowerBI

### Concept of the project 💡
This project depicts COVID-19 Situation in Europe using dataset from the ECDC website. Using the reference source data and multiple cloud service from Microsoft Azure to gain some hand-on experiences about ETL process ( extract, transform, load ) and also to get familiar with various tools/platforms provided by Azure e.g Azure Data Factory, Azure Databricks,… The primary objective is visualising the key point of the whole acquired dataset, in order to comprehensively understand the influence of COVID-19 on the entirety of European Region throughout the year 2020

## Task 🎯
- Ingest data from multiple source, clean it up, make sensible transformation to be suitable for the goal
- Load the processed data into central repository, such as data warehouse and datalake
- Using Power BI to access data storage and make a representatioithn about confirmed cases and deaths, hospital and ICU occupancy rate

## Resource 📤
- Source data
  - The resources for the dataset and the main concept of these project is based on “Udemy Course – Azure Data Factory For Data Engineers – Project on Covid-19 by Ramesh Retnasamy” under the following link: https://github.com/cloudboxacademy/covid19
  - The acquisitive dataset is categorized like following:
    - eurostat_data: contain population
    - ecdc
      - cases_deaths.csv: timeline of number of case and death in each country
      - country_response.csv: timeline of how each country response to the situation
      - hospital_admissions.csv: timeline of daily and weekly hospital occupancy in each country
      - testing.csv: COVID test-situation in each country
    - look_up
      - country_lookup.csv: geometric information of each country
      - dim_data.csv: derived information of reported date
- Tools
  - Environment Setup
    - Azure Subscription
  - Data Integration/Ingestion
    - ADF Data Flows within Data Factory
  - Transformation
    - Data Flows within Data Factory
    - Azure Databricks Cluster
  - Data Storage
    - Azure SQL Database
    - Azure Blob Storage Account
    - Azure Data Lake Storage Gen 2
  - Visualization
    - Power BI Desktop

- Approach
  Solution Architecture Overview
  
