# DataAnalystPortfolio
JClemons
This read me specifically addresses: Diabetes & Hate Crimes Jupyter Notebook projects.
### Diabetes
An analysis of the reported health metrics that relate to the probability of a diabetes diagnosis. I utilized Pandas to clean the data. 
Matplotlib/Seaborn to visualize the data with graphs and regression lines and a correlation matrix.

##### How I cleaned the data 
- I began by loading the data. 
- Checking for nulls and duplicates. 
- Then running histograms on all diabetic variables. 

The data did have duplicates but given the similarity in possible outcomes such as age,
skin thickness, glucose level...I figured it was normal to have duplicates.

##### Analysis of the data
- What age group has the most number of outcomes (diagnosed with diabetes)?

Made a histogram of the Outcome variable which column showed 1 for Diabetic and 0 for not Diabetic. Then I concluded with a bar chart
to support the distribution of the histogram.

- Can you show the relationship between Glucose/Age and Glucose/Insulin?

I'm open to learn other practices. Right now for me, the best way to show relationship between two variables is to provide a regression line.
So I use regplot function to graph and prove a slight positive correlation between both: glucose/age and glucose/insulin.

- Can you determine which factor affects the probability of diabetes?

For this analysis I used Seaborn's heatmap in the color preset: coolwarm to distinctly show strong/no correlation.
Glucose looks to show the highest correlation to Diabetic diagnosis.

---


### Hate-Crimes
An analysis of the reported hate crimes over the course of 2019. The data includest

##### How I cleaned the data:
- load/read the data csv
- rename the columns since they had slashes(/) in their names
- pivot the columns: 1st,2nd, 3rd & 4th Quarter...I believe these are data, not column headings so they need to be pivoted
- change decimal points to integer data
- delete or fill empty rows
- remove duplicates
- lastly update data types

##### Challenges
This data needed to be cleaned and separated into different datasets to analyze. Each state/Agency combo needed its own UniqueID so 
I created a 'hate crime by state' dataset and pivoted the melted dataset to creat a 'count by state dataset'.


##### Analysis of the data
- Which season on average has the highest rate of reported crimes (assuming q1=spring, q2=summer, q3=fall, q4=winter)?

Began by finding the mean of each quarter's reported crimes and multiplying by 100.
Then I plotted the result and renamed the columns with the associated season.

- What are the most common types of hate crimes reported?

Used a pie plot with Matplotlib to answwer the quantity of hate crimes reported. Then I confirmed my results with a bar plot.



