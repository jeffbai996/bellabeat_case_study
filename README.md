# Bellabeat Case Study

This repository contains materials for the Google Data Analytics capstone project analyzing usage patterns from the **Fitbit Fitness Tracker Data**. The goal is to explore how smart device users behave in order to provide insights for Bellabeat's marketing strategy.

## Project goals
- Clean and explore activity, sleep, and weight data collected from Fitbit devices.
- Visualize patterns that can inform how Bellabeat markets its wellness products.

## Getting the data
The required CSV files are not stored in this repository. Download the following files from the [Fitbit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) dataset on Kaggle:

- `dailyActivity.csv`
- `sleepDay.csv`
- `weightLogInfo.csv`

Create a folder named `datasets` in the project root and place the three CSV files inside it so that the file structure looks like:

```
bellabeat_case_study/
├── bellabeat_script.R
├── datasets/
│   ├── dailyActivity.csv
│   ├── sleepDay.csv
│   └── weightLogInfo.csv
```

## Running the analysis
Make sure you have R installed with the packages `tidyverse`, `janitor`, `skimr`, and `lubridate`. Once the datasets are in place run the script from the project root:

```bash
Rscript bellabeat_script.R
```

The script reads the CSV files from the `datasets` directory, cleans the data, and generates exploratory plots.
