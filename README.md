# Getting And Cleaning Data - Course Project

## Introduction

This is a repo containing files for the Coursera "Getting and Cleaning Data" course.

## Scripts

The repo contains one script file - `run_analysis.R`. 

This script will:

1. Download the Samsung data to the current working directory
2. Aggregate the training and test data into one data set
3. Average the mean and std. deviation columns in the complete data set
4. Output these averaged results to a file called `averagedMeasurementData.txt`

## Execution

Just run `run_analysis.R` in your chosen working directory and look for the resulting
averaged data in `averagedMeasurementData.txt`

There is just one script called run_analysis.R. It contains all functions and code to do the following:
        
        Download UCI HAR zip file to data dir
Read data
Do some transformations
Write output data to a CSV file inside data/output dir
The CodeBook.md explains it more detailed.

Run from command line

Clone this repo
Run the script:
        
        $ Rscript run_analysis.R

Look for the final dataset at data/output/uci_har_mean_std_averages.csv

$ head -3 data/output/uci_har_mean_std_averages.csv

Open project with RStudio

This repo also contains the RStudio project file peer_assessment.Rproj.