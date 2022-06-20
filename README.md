# Market Basket Analysis Project

This project is created on a stack of R Shiny and Tableau. 

A Market Basket Analysis Project based on Instacart dataset sourced from Kaggle. 


# Overview

We've created a 2 page website using R Shiny. 
 1. Authentication Page : Authentication is done using a library "reglog".  
 2. Dashboard Page.
 
 We've created Dashboard using Tableau Desktop.
 1. Dashboard contains 5 charts.
 2. Can give insights on concept of Market Basket Analysis
 
 Maintained Db using MySQL and accessing it in R using RMySQL Library.

## Setup Database

- Create Database with name **mbadb** in MySQL; use any service like Workbench or Apache XAMPP to interact.(in our case we are using Workbench).

- Open the DUMP folder provided in repository. Open SQL files using Workbench.
- Execute those files one-by-one. 

It will setup database structure for us. 

## Setup R Code.

To setup the R code and run for the first time.

Make directory structure like. put 2 folders in One Root folder. 
2 folders can be named as:

 - dataset
 - application

---

 - Open file **DbConnection**. Remove **#** from the line 1 to uncomment **install.packages()** function. 
 - Execute that line. 

*Iterate this in every R file to install all dependent libraries.* 

## Run R Script for the first time.

Now you have all your dependencies.

- Open **dbConnection.R** file and change the **'root'** and **'password'** to the username and password you set for your database in **line #7**.

- Now open **reglog.R** file and execute it. 

- It will open **R shiny application**. Signup to add your username and then sign in to login. You'll see dashboard page.

*In case of any error check the directory structure and file path.*

***Happy Coding!***
