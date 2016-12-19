# Getting And Cleaning Data - Course Project

## Introduction

Hello and welcome! This is a repo containing files for the Coursera "Getting and Cleaning Data" course.

## Scripts

The repo contains one script file - `run_analysis.R`. 

This script will:

1. Download the UCI HAR data to the current working directory if it's not already there
2. Aggregate the training and test data into one data set, while making the data and headers look nicer
3. Average the mean and std. deviation columns in the complete data set
4. Output these averaged results to a file called `averagedMeasurementData.txt`

## Execution

Just run `run_analysis.R` in your chosen working directory and look for the resulting
averaged data in `averagedMeasurementData.txt`
