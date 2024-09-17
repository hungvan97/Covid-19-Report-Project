# Covid-19-Report-Project-
Purpose: Practice use-cases using Azure Tech-stack (ADF, Databricks ) + PowerBI

## I. Concept of the project 💡
This project depicts COVID-19 Situation in Europe using dataset from the ECDC website. Using the reference source data and multiple cloud service from Microsoft Azure to gain some hand-on experiences about ETL process ( extract, transform, load ) and also to get familiar with various tools/platforms provided by Azure e.g Azure Data Factory, Azure Databricks,… The primary objective is visualising the key point of the whole acquired dataset, in order to comprehensively understand the influence of COVID-19 on the entirety of European Region throughout the year 2020

## II. Task 🎯
- Ingest data from multiple source, clean it up, make sensible transformation to be suitable for the goal
- Load the processed data into central repository, such as data warehouse and datalake
- Using Power BI to access data storage and make a representatioithn about confirmed cases and deaths, hospital and ICU occupancy rate

## III. Resource 📤
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
  
  ## IV. Approach
  Solution Architecture Overview
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/solution%20architecture%20overview.png)
  
  ### 1. Data Extraction/Ingestion
  Four different datasets were ingested from the link mention in Section III.1. These are:
  - Cases and Deaths Data
  - Hospital Admissions Data
  - Population Data
  - Test Conducted Data
  To gain some hand-on experiences, I used various components of ADF Pipeline activities to ingest data both from HTTP Data Source and Azure Storage Account to Azure DataLake. These are:
  - Validaton Activity
  - Get Metadata Activity
  - Copy Activity
  
  ***Step 1.1 Population Data: Load into Storage Account and move it to Desitination Data Lake***
  
  *Solution Flow*
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/Population%20Data%20Solution%20Flow.png)
  
  *Process*
  - (1) Create Linked Service to Azure Blob Storage
  - (2) Create Source Data Set
  - (3) Execute Copy Activity when file becomes available -> Check Metadata about number of column before loading data using IF condition -> Load Data into Target Destination
  - (4) Create Linked Service to Azure Lake Storage (GEN2)
  - (5) Create Sink Data Set
  - (6) Create Pipeline and Schedule Trigger
  
  *Pipeline Design*
  
  ![Pipeline](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Pipeline/Population%20Data%20Pipeline.png)
  
  ***Step 1.2 ECDC Data from Web to Destination Data Lake***
  
  *Solution Flow*
  
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/ECDC%20Data%20Solution%20Flow.png)
  
  *Process*
  -	(1) Create Linked Service using HTTP GET method
  -	(2) Create Source Data Set
  -	(3) Look up to get all the parameters from json config file to get 4 files of ECDC Data Content
  -	(4) Create Sink Dataset
  -	(5) Create Linked Service to Azure Data Lake Storage (GEN2)
  -	(6) Create Pipeline and schedule Trigger to recursive trigger pipeline every 24 hours
    
  *Pipeline*
  
  ![Pipeline](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Pipeline/ECDC%20Data%20Pipeline.png)
  
  ### 2. Data Transformation
  ***Step 2.2 “Cases and Deaths” and “Hospital Admissions” data were transformed using ADF Data Flows***
  
  The transformation used on both dataset include following method: select, lookup, filter, join, sort, conditional split, derived columns.
  
  ***Data Flows Transformation Cases & Deaths Data***
  
  *Solution Flow*
  
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/Cases%20%26%20Deaths%20Data%20Flow%20Solution.png)
  
  *Process*
  -	Ingest Cases and Deaths Source (Azure Data Lake Storage Gen2)
  -	Filter data from Europe-Only country
  -	Filter only selected columns
  -	Pivot Count only “indicator” column and get the sum of daily confirmed cases and death count
  -	Lookup Country to get country_code_2_digit (Country Code in 2 digits) and country_code_3_digit (Country Code in 3 digits) (this steps is unnecessary, just to practice on several transformation method )
  -	Filter only selected columns for the Sink
  -	Create Sink Dataset (Azure Data Lake Storage Gen2)
  -	Create Pipeline and schedule Trigger to recursive trigger pipeline for every 24 hours
  
  ***Data Flows Transformation Hospital Admissions Data***
  
  *Solution Flow*
  
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/Hospital%20Admissions%20Daily%20Data%20Solution.png)
  
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/Hospital%20Admissions%20Weekly%20Data%20Solution.png)
  
  *Process*
  -	Hospital Admissions Source (Azure Data Lake Storage Gen2)
  -	Filter only selected columns
  -	Lookup Country to get “country_code_2_digit” (Country code in 2 digits), “country_code_3_digit” (Country code in 3 digits) columns
  -	Filter out duplicated columns
  -	Filter rows using Condition Split Weekly, Daily condition
    - indicator=='Weekly new hospital admissions per 100k' || indicator=='Weekly new ICU admissions per 100k'
    - indicator== "Daily hospital occupancy" || indicator=="Daily ICU occupancy"
  
  <ins>For Weekly Path</ins>
  
  - Join with Date to get “ecdc_year_week”, “week_start_date”, “week_end_date”
  - Pivot Count only “indicator” column and get the sum of weekly hospital & ICU admissions per 100k
  - Sort data using “reported_year_week” and “country” in respectively ascending and descending order
  - Filter selected columns for Sink
  - Create Sink Dataset (Azure Data Lake Storage Gen 2)
  - Schedule Trigger to recursive trigger pipeline every 24 hours
  
  <ins>For Daily Path</ins>
  
  - Pivot Count only “indicator” column and get the sum of daily hospital & ICU admissions per 100k
  - Sort data using “reported_date” and “country” in respectively descending and ascending order
  - Filter selected columns for Sink
  - Create Sink Dataset (Azure Data Lake Storage Gen 2)
  - Schedule Trigger to recursive trigger pipeline every 24 hours
  
  *Daily Flows Transformation*
  
  ![Pipeline](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Pipeline/Data%20Flows%20Transformation.png)
  
  ***Step 2.3 Databricks Transformation on “Population by Age” File***
  
  *Solution Flow*
  
  ![SolutionFlow](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Solution%20Flow/Population%20By%20Age%20Databrick%20Solution.png)
  
  ### 3. Store Data in Azure SQL Database
  
  *Create pipeline to copy Cases & Deaths Data to SQL Database*
  
  ![Pipeline](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Pipeline/Cases%20%26%20Deaths%20Data%20to%20SQL%20Database%20Pipeline.png)
  
  *Create pipeline to copy Hospital Admissions Daily Data to SQL Database*
  
  ![Pipeline](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Pipeline/Hospital%20Admissions%20Daily%20Data%20to%20SQL%20Databse%20Pipeline.png)
  
  *The same goes for Hospital Admissions Weekly Data*
  
  ### 4. Visualize Presentation using PowerBI Desktop
  
  *Solution Flow*
  -	Create a connection from Azure SQL Database to PowerBI and load the data
  -	Visualize the total confirm Cases and Deaths Year 2020 in Slider Depict
  -	Visualize the total confirm Cases and Deaths Year 2020 in Map Depict
  -	Visualize the distribution Case of each Age Group Year 2019 in Chart Depict
  
  *Process*
  
  ![Visualization](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Visualization/COVID-19%20Cases%20and%20Deaths%20in%20EU%20Vis.png)
  ![Visualization](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Visualization/COVID-19%20Cases%20and%20Deaths%20in%20EU%20Mapping.png)
  ![Visualization](https://github.com/hungvan97/Covid-19-Report-Project-/blob/main/Screenshots/Visualization/Case%20of%20each%20Age%20Group%20in%20Year%202019%20Piechart.png)

## V. Conclusion
This project contains almost every basic step of ETL progress and also covers some use-cases of Azure Technology Stack, including: Azure Data Factory (with the using of Blob and Data Lake Storage, Data Flows for various transformation methods), Azure Databricks and visualization tool like PowerBI.

