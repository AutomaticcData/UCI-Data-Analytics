
### Heroes of Pymoli - Aalvarez


```python
#Created on Sat Aug 18 18:14:17 2018
#@author: anthonyalvarez
#MASTER FILE: HOP_03_AALVAREZ.ipynb
#GITHUB Markdown Cheetsheet
```

* Testing file used: [HOP_03_AALVAREZ.ipynb](HOP_03_AALVAREZ.ipynb)
* Markdown Cheet Sheet: [https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links](Markdown Cheet Sheet)
![alt text](Resources/HOP_00.jpg "HOP")

### Dependencies


```python
#import dependencies
import pandas as pd
import numpy as npy
```

### File Operations


```python
#get the file
file_path = "Resources/purchase_data.csv"

#read the file into data frame
master_df = pd.read_csv(file_path)
```

### Functions


```python
#format a nice strings
def pretty_money(num_float):
    text_money =     '${:,.2f}'.format(num_float)
    
    return text_money

def percentage_fix(num_float):
    per_fix = '{0:.2f} %'.format(num_float)
    
    return per_fix
```

### Player Count - Calculations


```python
#i kept having issues with modifying the original dataframe after several attempts to create and keep the original
#then i found this article -->
#https://stackoverflow.com/questions/35665135/why-can-pandas-dataframes-change-each-other
main_df = master_df.copy()
#main_df.head()

#get a count of the total player base
#this line does not remove duplicates, rather the total count of records for this column
#total_player_count = main_df["SN"].count()
#count the unique players and get the length of the list returned
total_player_count = len(main_df["SN"].unique())
totalplayer_df = pd.DataFrame({"Total Number of Players":[total_player_count]})
#print(total_player_count)

#create the final dataframe
final_playercount_df = totalplayer_df.copy()
```

### Purchasing Analysis (Total) - Calculations



```python
#get the unique number of items
unique_item_count = len(main_df["Item ID"].value_counts())
#print(unique_item_count)

#total purchase values
total_values_num = main_df["Price"].sum()
#print(total_values_num)

#the total number of purchases 
purchases_count = total_player_count
#print(purchases_count)

#average item price
average_item_price = main_df["Price"].mean()
average_item_price = round(average_item_price,2)
#print(average_item_price)

purchasinganalysis = pd.DataFrame({"Number of Unique Items": unique_item_count
                          ,"Average Price": pretty_money(average_item_price)
                          ,"Number of Purchases": purchases_count
                          ,"Total Revenue": pretty_money(total_values_num)                            
                                    }, index=[0])

#create the final dataframe
final_purchasinganalysis_total_df = purchasinganalysis.copy()
```

### Gender Demographics - Calculations



```python
#https://stackoverflow.com/questions/12497402/python-pandas-remove-duplicates-by-columns-a-keeping-the-row-with-the-highest
#using response 95 for reference
uniqueitems_df = main_df.drop_duplicates(["Item ID"], keep="last")

#only get columns needed
uniqueitems_df = uniqueitems_df[["Item ID","Item Name","Price"]]

#sort columns by id
uniqueitems_df = uniqueitems_df.sort_values(["Item ID"], ascending=[1])
#uniqueitems_df.head()


#CREATE 1 Dataframe for each type
#male items
male_items = main_df.loc[main_df["Gender"]=="Male"]
#male_items.head(2)
female_items = main_df.loc[main_df["Gender"]=="Female"]
#female_items.head(2)
others_items = main_df.loc[main_df["Gender"]=="Other / Non-Disclosed"]
#others_items.head(2)


#GET the counts of each type
count_of_males = len(male_items["SN"].unique())
#print(count_of_males)
count_of_females = len(female_items["SN"].unique())
#print(count_of_females)
count_of_others = len(others_items["SN"].unique())
#print(count_of_others)


#get the percentages
percent_of_males = percentage_fix(round(count_of_males/total_player_count *100,2))
percent_of_females = percentage_fix(round(count_of_females/total_player_count *100,2))
percent_of_others = percentage_fix(round(count_of_others/total_player_count *100,2))

#testing output
#print(f'Total players is: {total_player_count}(100%), Males:{count_of_males}(%{percent_of_males}) - Fem:{count_of_females}(%{percent_of_females}) - Other:{count_of_others}(%{percent_of_others})')


#create the purchasing analysis gender dataframe
genderdemo_df = pd.DataFrame([
                                {"":"Male","Percentage of Players":percent_of_males,"Total Count": count_of_males}
                                 ,{"":"Female","Percentage of Players":percent_of_females,"Total Count": count_of_females}
                                 ,{"":"Other / Non-Disclosed","Percentage of Players":percent_of_others,"Total Count": count_of_others}
                                ])

#create the final dataframe
final_genderdemographics_df = genderdemo_df.copy()


```

### Purchasing Analysis (Gender) - Calculations


```python
#get average purchase for females
female_avg_purchase_price = female_items["Price"].mean()
female_tot_purchase_price = female_items["Price"].sum()
female_aptpp = (female_avg_purchase_price/count_of_females)*100

#testing values output
#print(count_of_females)
#print(pretty_money(female_avg_purchase_price))
#print(pretty_money(female_tot_purchase_price))
#print(pretty_money(female_aptpp))


#get average purchase for males
male_avg_purchase_price = male_items["Price"].mean()
male_tot_purchase_price = male_items["Price"].sum()
male_aptpp = (male_avg_purchase_price/count_of_males)*100

#testing values output
#print(count_of_males)
#print(pretty_money(male_avg_purchase_price))
#print(pretty_money(male_tot_purchase_price))
#print(pretty_money(male_aptpp))


#get average purchase for others
others_avg_purchase_price = others_items["Price"].mean()
others_tot_purchase_price = others_items["Price"].sum()
others_aptpp = (others_avg_purchase_price/count_of_others)*100

#print(count_of_others)
#print(pretty_money(others_avg_purchase_price))
#print(pretty_money(others_tot_purchase_price))
#print(pretty_money(others_aptpp))

#create the dictionary lists
ls_female_pagender = {"Gender":"Female","Purchase Count":count_of_females, "Average Purchase Price":pretty_money(female_avg_purchase_price), "Total Purchase Value":pretty_money(female_tot_purchase_price),"Average Purchase Total PPBG":pretty_money(female_aptpp)}
ls_male_pagender = {"Gender":"Male","Purchase Count":count_of_males, "Average Purchase Price":pretty_money(male_avg_purchase_price), "Total Purchase Value":pretty_money(male_tot_purchase_price),"Average Purchase Total PPBG":pretty_money(male_aptpp)}
ls_others_pagender = {"Gender":"Other / Non-Disclosed","Purchase Count":count_of_others, "Average Purchase Price":pretty_money(others_avg_purchase_price), "Total Purchase Value":pretty_money(others_tot_purchase_price),"Average Purchase Total PPBG":pretty_money(others_aptpp)}

# Create a DataFrame of frames using a dictionary of lists
pagender_df = pd.DataFrame(
                            [
                                ls_female_pagender
                                ,ls_male_pagender
                                ,ls_others_pagender
                                ]
                        )
#reorder columns
#pagender_df.columns
pagender_df = pagender_df[["Gender","Purchase Count","Average Purchase Price","Total Purchase Value","Average Purchase Total PPBG"]]

#create the final dataframe
final_purchasinganalysisgender_df = pagender_df.copy()

```

### Age Demographics - Calculations


```python
#agedemo_maindf = pd.DataFrame(main_df)
agedemo_maindf = main_df.copy()
#agedemo_maindf.head()

#tried to use this but its not working :(
#bins_age = [9, 10, 15, 20, 30, 40]
#bins_labels = ["<10", "10-14", "15-19", "20-29", "30-39", "40-49", ">50"]
#agedemo_maindf["Age Range"] = pd.cut(agedemo_maindf["Age"], bins_age, bins_labels)
#agedemo_maindf.head()


#NOTE: BINNING
#create a bin using conditions
#https://stackoverflow.com/questions/21702342/creating-a-new-column-based-on-if-elif-else-condition
#using examples with LOC reply #6

#TESTING--------------------------------------------------
#if the column 'AGE' is < 10, create a bin called Age Range
#agedemo_maindf.loc[(agedemo_maindf["Age"] < 10), "Age Range"] = "Low on the totem pole"
#agedemo_maindf.loc[agedemo_maindf["Age"] >= 10, "Age Range"] = "Big Boy"
#HUZZAH! this works!!!!

agedemo_maindf.loc[(agedemo_maindf["Age"] < 10), "Age Range"] = "<10"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 10) & (agedemo_maindf["Age"] <= 14), "Age Range"] = "10-14"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 15) & (agedemo_maindf["Age"] <= 19), "Age Range"] = "15-19"

#agedemo_maindf.loc[(agedemo_maindf["Age"] >= 20) & (agedemo_maindf["Age"] <= 29), "Age Range"] = "20-29"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 20) & (agedemo_maindf["Age"] <= 24), "Age Range"] = "20-24"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 25) & (agedemo_maindf["Age"] <= 29), "Age Range"] = "25-29"


#agedemo_maindf.loc[(agedemo_maindf["Age"] >= 30) & (agedemo_maindf["Age"] <= 39), "Age Range"] = "30-39"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 30) & (agedemo_maindf["Age"] <= 34), "Age Range"] = "30-34"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 35) & (agedemo_maindf["Age"] <= 39), "Age Range"] = "30-39"

#agedemo_maindf.loc[(agedemo_maindf["Age"] >= 40) & (agedemo_maindf["Age"] <= 49), "Age Range"] = "40-49"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 40) & (agedemo_maindf["Age"] <= 44), "Age Range"] = "40-44"
agedemo_maindf.loc[(agedemo_maindf["Age"] >= 45) & (agedemo_maindf["Age"] <= 49), "Age Range"] = "40-49"

agedemo_maindf.loc[(agedemo_maindf["Age"] > 49), "Age Range"] = "50>"
#agedemo_maindf.head(2)



#----PURCHASE COUNTS DATAFRAME-----------
#get counts of the bins, group by the AgeRange and the Name
purchase_counts_byage = agedemo_maindf.groupby("Age Range")["SN"].count()
purchasebyage_df = pd.DataFrame(purchase_counts_byage)

#try to sort the columns
#purchasebyage_df = purchasebyage_df.sort_values(["Age Sort"], ascending=[1])
#dont want to use the SN name for the column, rename it to purchase count
purchasebyage_df = purchasebyage_df.rename(columns={"SN":"Purchase Count"})
purchasebyage_df.head()


#-------ADD THE PERCENTAGE COLUMN to the PurchasebyAge Dataframe to avoid having to add to the merged later
#------ PERCENTAGE OF PLAYERS AND Optional: round the percentage column to two decimal points
#pom_df = purchasebyage_df.copy()
#pom_df.head(3)

purchasebyage_df["Percentage of Players"] = round(purchasebyage_df["Purchase Count"] / total_player_count * 100, 2)
purchasebyage_df.head()




#-----AVERAGE PURCHSE PRICE DATAFRAME-------------
#get the average purchase price by age
average_purchase_byage = agedemo_maindf.groupby("Age Range")["Price"].mean()

#create the data frame
avgpurchasebyage_df = pd.DataFrame(average_purchase_byage)
avgpurchasebyage_df = avgpurchasebyage_df.rename(columns={"Price":"Average Purchase Price"})

#http://localhost:8888/notebooks/Python%20Week%204/KickstarterClean_00.ipynb
#hosted_in_us["average_donation"] = hosted_in_us["average_donation"].astype(float).map("${:,.2f}".format)

#good idea to not format until all calculations are done
#avgpurchasebyage_df["Average Purchase Price"] = avgpurchasebyage_df["Average Purchase Price"].astype(float).map("${:,.2f}".format)
#avgpurchasebyage_df.head()



#-----TOTAL PURCHSE VALUE DATAFRAME ---------
#get the total purchase value
purchase_totalvalue_byage = agedemo_maindf.groupby("Age Range")["Price"].sum()
#create the data frame
purchasetotalvaluebyage_df = pd.DataFrame(purchase_totalvalue_byage)
#rename the column from price to Total purchase price
purchasetotalvaluebyage_df = purchasetotalvaluebyage_df.rename(columns={"Price":"Total Purchase Value"})

#format the text
#again...wait till the end to format columns
#purchasetotalvaluebyage_df["Total Purchase Value"] = purchasetotalvaluebyage_df["Total Purchase Value"].astype(float).map("${:,.2f}".format)
#purchasetotalvaluebyage_df.head()



#----- GET THE NUMBER OF TRANSACTIONS PER PERSON ie. Purchases
#get unique values for the number of purchases from the age range buckets
numpurchases_byage_df = pd.DataFrame(agedemo_maindf.drop_duplicates("SN", keep="last"))
#wont work with a single dataframe for some reason
#and i noticed my main dataframe keeps getting modified as well, note to self, find out why.
countofpurchases_byage_df = pd.DataFrame(numpurchases_byage_df.groupby('Age Range')["SN"].count())
#rename the column from SN to Transactions
countofpurchases_byage_df = countofpurchases_byage_df.rename(columns={"SN":"Transactions"})

#countofpurchases_byage_df.head()
#main_df.head()


#------MERGING THE 4 DATAFRAMES ---------------
#merge the 3 tables 
#Python%20Week%204/Merging.ipynb
#https://chrisalbon.com/python/data_wrangling/pandas_join_merge_dataframe/
agedemo_merge_df = pd.merge(purchasebyage_df, avgpurchasebyage_df, on="Age Range", how="left")
agedemo_merge_df = pd.merge(agedemo_merge_df,purchasetotalvaluebyage_df, on="Age Range", how="left")
#agedemo_merge_df.head()

#merge the above dataframe to get my divisor for avg purch total pPerson by agegroup
agedemo_merge_df = pd.merge(agedemo_merge_df,countofpurchases_byage_df, on="Age Range", how="left")
#agedemo_merge_df.head()


#get the Average Purchase Total per Person by using the divisor above
agedemo_merge_df["Average Purchase Total per Person"] = agedemo_merge_df["Total Purchase Value"]/agedemo_merge_df["Transactions"]
#agedemo_merge_df.columns
#agedemo_merge_df.head()
#agedemo_merge_df["Total Purchase Value"]

#formatting columns for aesthetics
agedemo_merge_df["Average Purchase Price"] = agedemo_merge_df["Average Purchase Price"].astype(float).map("${:,.2f}".format)
agedemo_merge_df["Total Purchase Value"] = agedemo_merge_df["Total Purchase Value"].astype(float).map("${:,.2f}".format)
agedemo_merge_df["Average Purchase Total per Person"] = agedemo_merge_df["Average Purchase Total per Person"].astype(float).map("${:,.2f}".format)


#create a master copy of the merged data.
final_agedemographics1_df = agedemo_merge_df.copy()

#get the 5 columns requested
final_agedemographics1_df = final_agedemographics1_df[["Purchase Count","Average Purchase Price","Total Purchase Value","Average Purchase Total per Person"]]
#final_agedemographics1_df = final_agedemographics1_df.rename(columns={"Purchase Count":"Total Count"})
#final_agedemographics1_df



#---------CREATE A SECOND DATAFRAME To SATISFY BOTH REQUEST CRITERIA

#get counts of the bins, group by the AgeRange and the Name
#create a copy of the dataframe
agedemo_counts_df = agedemo_maindf.copy()
#get a aggregate of SN Counts
ad_counts_byage = pd.DataFrame(agedemo_counts_df.groupby("Age Range")["SN"].count())

#use list comprehension because we reviewed that in class today, for good practice
pfix = [percentage_fix(round(value/total_player_count * 100, 2)) for value in ad_counts_byage["SN"]]
#[(expression in value) for value in collection]

#dont use this use a list comp.
#ad_counts_byage["Percentage of Players"] = round(ad_counts_byage["SN"]/total_player_count * 100, 2)

ad_counts_byage["Percentage of Players"] = pfix
#rename the SN to Total Count
ad_counts_byage = ad_counts_byage.rename(columns={"SN":"Total Count"})
#reorder columns, % first
ad_counts_byage = ad_counts_byage[["Percentage of Players","Total Count"]]

final_agedemographics2_df = ad_counts_byage

```

### Top Spenders - Calculations


```python
#create 3 dataframes for total purchase values, avg price of products and amounts

#get the number of products purchased
topspender_count_df = pd.DataFrame(main_df.groupby("SN")["Price"].count())
topspender_count_df = topspender_count_df.rename(columns={"Price":"Purchase Count"})
#topspender_count_df.head()

#get the average price of products
topspender_avg_df = pd.DataFrame(main_df.groupby("SN")["Price"].mean())
topspender_avg_df = topspender_avg_df.rename(columns={"Price":"Average Purchase Price"})

#get the purchased amounts
topspender_purchased_df = pd.DataFrame(main_df.groupby("SN")["Price"].sum())
topspender_purchased_df = topspender_purchased_df.rename(columns={"Price":"Total Purchase Value"})

#topspender_purchased_df.head(1)

#merge the 3 dfs
topspender_merge_df = pd.merge(topspender_count_df, topspender_avg_df, on="SN", how="left")
topspender_merge_df = pd.merge(topspender_merge_df,topspender_purchased_df, on="SN", how="left")

#topspender_merge_df.head()
#topspender_merge_df = None

#check the columns
#topspender_merge_df.columns
#Index(['Price_x', 'Price_y', 'Price'], dtype='object')

#http://pandas.pydata.org/pandas-docs/version/0.19/generated/pandas.DataFrame.sort.html
#sort the data frames
topspender_summary_df = pd.DataFrame(topspender_merge_df)

#Descending order
#ascending : boolean or list, default True
#Sort ascending vs. descending. Specify list for multiple sort orders
#axis : {0 or ‘index’, 1 or ‘columns’}, default 0 = #Sort index/rows versus columns
#inplace : boolean, default False = #Sort the DataFrame without creating a new instance
topspender_summary_df.sort_values("Total Purchase Value", ascending=False, inplace=True)

#limit to top 5 rows
#topspender_summary_df.head()

#format the currencies 
topspender_summary_df["Average Purchase Price"] = topspender_summary_df["Average Purchase Price"].astype(float).map("${:,.2f}".format)
topspender_summary_df["Total Purchase Value"] = topspender_summary_df["Total Purchase Value"].astype(float).map("${:,.2f}".format)

#agedemo_merge_df.columns
#topspender_summary_df.head()

#create final dataframe
final_topspender_df = topspender_summary_df.copy().head()
```

### Most Popular Items - Calculations


```python
#Most popular items Retrieve the Item ID, Item Name, and Item Price columns
#group on item id to get a count
mpop_itemid_df = pd.DataFrame(main_df.groupby("Item ID")["Item ID"].count())
mpop_itemid_df = mpop_itemid_df.rename(columns={"Item ID":"Purchase Count"})
mpop_itemid_df = mpop_itemid_df.sort_values(["Purchase Count"], ascending=[0])
#mpop_itemid_df.head(10)

#NOTE: Why is there a tie? Does it matter?

#get the sum of the price and rename to Total Purchase Value
mpop_itemprice_df = pd.DataFrame(main_df.groupby("Item ID")["Price"].sum())
mpop_itemprice_df = mpop_itemprice_df.rename(columns={"Price":"Total Purchase Value"})
#mpop_itemprice_df.head(10)

mpop_itemmerge_df = pd.merge(mpop_itemid_df, mpop_itemprice_df, on="Item ID", how="left")
#got this error
#D:\Users\antho\Anaconda3\envs\PythonData\lib\site-packages\IPython\core\interactiveshell.py:2963: FutureWarning: 'Item ID' is both an index level and a column label.
#Defaulting to column, but this will raise an ambiguity error in a future version
#  exec(code_obj, self.user_global_ns, self.user_ns)
#!!!!FIXED the error above by Renaming the columns before merging as to have unique names!!!!!!!!

#mpop_itemmerge_df.sort_values("Price", ascending=False, inplace=True)
#mpop_itemmerge_df.head(10)

#deal with many duplicates
#https://stackoverflow.com/questions/12497402/python-pandas-remove-duplicates-by-columns-a-keeping-the-row-with-the-highest
#using response 95 for reference
mpop_uniqueitems_df = main_df.drop_duplicates(["Item ID"], keep="last")
#mpop_uniqueitems_df.count()


#join the unique items with mpop_itemmerge_df because we also need the individual item price
#NOTE: also some items with the same name have different item IDs and different prices

mpop_itemmerge_df = pd.merge(mpop_itemmerge_df, mpop_uniqueitems_df, on="Item ID", how="left")
#mpop_itemmerge_df.head(15)

#SORT THE ITEMS BY ITEM COUNT & TOTAL PRICE AND ONLY THE TOP 5
#using my sort example for unique items since i forgot the syntax, however we want Descending this time so 0 instead of 1
#NOTE: https://stackoverflow.com/questions/17141558/how-to-sort-a-dataframe-in-python-pandas-by-two-or-more-columns
mpop_itemmerge_df = mpop_itemmerge_df.sort_values(["Purchase Count","Item ID"], ascending=[0,0])
#mpop_itemmerge_df.head()



#CREATE A DATAFRAME OF ONLY COUMNS WE WANT, RENAME AND FIX THE FORMAT
#copy
mpop_mainitems_df = mpop_itemmerge_df.copy()

#get columns
mpop_mainitems_df = mpop_mainitems_df[["Item ID","Item Name","Purchase Count","Price","Total Purchase Value"]]

#rename columns
mpop_mainitems_df = mpop_mainitems_df.rename(columns={"Price":"Item Price"})

#apply formatting
#format the currencies 
mpop_mainitems_df["Item Price"] = mpop_mainitems_df["Item Price"].astype(float).map("${:,.2f}".format)
mpop_mainitems_df["Total Purchase Value"] = mpop_mainitems_df["Total Purchase Value"].astype(float).map("${:,.2f}".format)

#create final dataframe
final_mostpopularitems_df = mpop_mainitems_df.copy().head()
```

### Most Profitable Items - Calculations


```python
#create a dataframe copy to work with
mprof_df = main_df.copy()
mprof_df.head()

#get a list of items and sum of price

#get the total purchase value
#purchase_totalvalue_byage = agedemo_maindf.groupby("Age Range")["Price"].sum()
mprof_items_df = pd.DataFrame(mprof_df.groupby("Item ID")["Price"].sum())

#mprof_items_df.head()

#sort descending
#mpop_itemmerge_df = mpop_itemmerge_df.sort_values(["Purchase Count","Item ID"], ascending=[0,0])
mprof_items_df = mprof_items_df.sort_values(["Price"], ascending=[0])

#rename
mprof_items_df = mprof_items_df.rename(columns={"Price":"Total Purchase Value"})
#mprof_items_df.head(10)


#get the number of products purchased
mprof_count_df = pd.DataFrame(mprof_df.groupby("Item ID")["Price"].count())

#rename
mprof_count_df = mprof_count_df.rename(columns={"Price":"Purchase Count"})
#mprof_count_df.head()

#merge the dataframes for results we want
mprof_merge_df = pd.merge(mprof_items_df,mprof_count_df, on="Item ID", how="left")
#mprof_merge_df.head()


#get a list of items to remove duplicates
#deal with many duplicates
#https://stackoverflow.com/questions/12497402/python-pandas-remove-duplicates-by-columns-a-keeping-the-row-with-the-highest
#using response 95 for reference
mprof_uniqueitems_df = mprof_df.drop_duplicates(["Item ID"], keep="last")
#mprof_uniqueitems_df.count()

#merge the duplicate list with our new dataframe
mprof_itemmerge_df = pd.merge(mprof_merge_df, mprof_uniqueitems_df, on="Item ID", how="left")
#mprof_itemmerge_df.head(15)




#CREATE A DATAFRAME OF ONLY COUMNS WE WANT, RENAME AND FIX THE FORMAT
#copy
mprof_mainitems_df = mprof_itemmerge_df.copy()

#get columns
mprof_mainitems_df = mprof_mainitems_df[["Item ID","Item Name","Purchase Count","Price","Total Purchase Value"]]

#rename columns
mprof_mainitems_df = mprof_mainitems_df.rename(columns={"Price":"Item Price"})

#apply formatting
#format the currencies 
mprof_mainitems_df["Item Price"] = mprof_mainitems_df["Item Price"].astype(float).map("${:,.2f}".format)
mprof_mainitems_df["Total Purchase Value"] = mprof_mainitems_df["Total Purchase Value"].astype(float).map("${:,.2f}".format)
#mprof_mainitems_df.head()

#create final dataframe
final_mostprofitableitems_df = mprof_mainitems_df.copy().head()

```

---
# Heroes of Pymoli - Data Analysis

![alt text](Resources/HOP_00.jpg "HOP")

Dear Mr. Manager, 

I have been assigned to analyze the data for our most recent fantasy game Heroes of Pymoli.
Like many others in its genre, the game is free-to-play, but players are encouraged to purchase optional items that enhance their playing experience. I have generated the game's purchasing data into meaningful insights as follows.
Regards,

Anthony Alvarez
Data Analyst

## Player Count
  * Total Number of Players
---


```python
final_playercount_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Number of Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>576</td>
    </tr>
  </tbody>
</table>
</div>



---
## Purchasing Analysis (Total)
  * Number of Unique Items
  * Average Purchase Price
  * Total Number of Purchases
  * Total Revenue
---


```python
final_purchasinganalysis_total_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>183</td>
      <td>$3.05</td>
      <td>576</td>
      <td>$2,379.77</td>
    </tr>
  </tbody>
</table>
</div>



---
## Gender Demographics
  * Percentage and Count of Male Players
  * Percentage and Count of Female Players
  * Percentage and Count of Other / Non-Disclosed
---



```python
final_genderdemographics_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Male</td>
      <td>84.03 %</td>
      <td>484</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Female</td>
      <td>14.06 %</td>
      <td>81</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Other / Non-Disclosed</td>
      <td>1.91 %</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



---
## Purchasing Analysis (Gender)
  * Purchase Count
  * Average Purchase Price
  * Total Purchase Value
  * Average Purchase Total per Person by Gender
---



```python
final_purchasinganalysisgender_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Gender</th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Average Purchase Total PPBG</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Female</td>
      <td>81</td>
      <td>$3.20</td>
      <td>$361.94</td>
      <td>$3.95</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Male</td>
      <td>484</td>
      <td>$3.02</td>
      <td>$1,967.64</td>
      <td>$0.62</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Other / Non-Disclosed</td>
      <td>11</td>
      <td>$3.35</td>
      <td>$50.19</td>
      <td>$30.42</td>
    </tr>
  </tbody>
</table>
</div>



---
## Age Demographics
   * The below each broken into bins of 4 years (i.e. <10, 10-14, 15-19, etc.)
  * Purchase Count
  * Average Purchase Price
  * Total Purchase Value
  * Average Purchase Total per Person by Age Group
---

###  * DataFrame 01


```python
final_agedemographics1_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
      <th>Average Purchase Total per Person</th>
    </tr>
    <tr>
      <th>Age Range</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10-14</th>
      <td>28</td>
      <td>$2.96</td>
      <td>$82.78</td>
      <td>$3.76</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>136</td>
      <td>$3.04</td>
      <td>$412.89</td>
      <td>$3.86</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>365</td>
      <td>$3.05</td>
      <td>$1,114.06</td>
      <td>$4.32</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>101</td>
      <td>$2.90</td>
      <td>$293.00</td>
      <td>$3.81</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>73</td>
      <td>$2.93</td>
      <td>$214.00</td>
      <td>$4.12</td>
    </tr>
    <tr>
      <th>30-39</th>
      <td>41</td>
      <td>$3.60</td>
      <td>$147.67</td>
      <td>$4.76</td>
    </tr>
    <tr>
      <th>40-44</th>
      <td>12</td>
      <td>$3.04</td>
      <td>$36.54</td>
      <td>$3.32</td>
    </tr>
    <tr>
      <th>40-49</th>
      <td>1</td>
      <td>$1.70</td>
      <td>$1.70</td>
      <td>$1.70</td>
    </tr>
    <tr>
      <th>&lt;10</th>
      <td>23</td>
      <td>$3.35</td>
      <td>$77.13</td>
      <td>$4.54</td>
    </tr>
  </tbody>
</table>
</div>



###  * DataFrame 02


```python
final_agedemographics2_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
    <tr>
      <th>Age Range</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10-14</th>
      <td>4.86 %</td>
      <td>28</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>23.61 %</td>
      <td>136</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>63.37 %</td>
      <td>365</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>17.53 %</td>
      <td>101</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>12.67 %</td>
      <td>73</td>
    </tr>
    <tr>
      <th>30-39</th>
      <td>7.12 %</td>
      <td>41</td>
    </tr>
    <tr>
      <th>40-44</th>
      <td>2.08 %</td>
      <td>12</td>
    </tr>
    <tr>
      <th>40-49</th>
      <td>0.17 %</td>
      <td>1</td>
    </tr>
    <tr>
      <th>&lt;10</th>
      <td>3.99 %</td>
      <td>23</td>
    </tr>
  </tbody>
</table>
</div>



---
## Top Spenders
   * Identify the the top 5 spenders in the game by total purchase value, then list (in a table):
  * SN
  * Purchase Count
  * Average Purchase Price
  * Total Purchase Value
---




```python
final_topspender_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Lisosia93</th>
      <td>5</td>
      <td>$3.79</td>
      <td>$18.96</td>
    </tr>
    <tr>
      <th>Idastidru52</th>
      <td>4</td>
      <td>$3.86</td>
      <td>$15.45</td>
    </tr>
    <tr>
      <th>Chamjask73</th>
      <td>3</td>
      <td>$4.61</td>
      <td>$13.83</td>
    </tr>
    <tr>
      <th>Iral74</th>
      <td>4</td>
      <td>$3.40</td>
      <td>$13.62</td>
    </tr>
    <tr>
      <th>Iskadarya95</th>
      <td>3</td>
      <td>$4.37</td>
      <td>$13.10</td>
    </tr>
  </tbody>
</table>
</div>



---
## Most Popular Items
   * Identify the 5 most popular items by purchase count, then list (in a table):
  * Item ID
  * Item Name
  * Purchase Count
  * Item Price
  * Total Purchase Value
---



```python
final_mostpopularitems_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>178</td>
      <td>Oathbreaker, Last Hope of the Breaking Storm</td>
      <td>12</td>
      <td>$4.23</td>
      <td>$50.76</td>
    </tr>
    <tr>
      <th>1</th>
      <td>145</td>
      <td>Fiery Glass Crusader</td>
      <td>9</td>
      <td>$4.58</td>
      <td>$41.22</td>
    </tr>
    <tr>
      <th>2</th>
      <td>108</td>
      <td>Extraction, Quickblade Of Trembling Hands</td>
      <td>9</td>
      <td>$3.53</td>
      <td>$31.77</td>
    </tr>
    <tr>
      <th>3</th>
      <td>82</td>
      <td>Nirvana</td>
      <td>9</td>
      <td>$4.90</td>
      <td>$44.10</td>
    </tr>
    <tr>
      <th>5</th>
      <td>103</td>
      <td>Singed Scalpel</td>
      <td>8</td>
      <td>$4.35</td>
      <td>$34.80</td>
    </tr>
  </tbody>
</table>
</div>



---
## Most Profitable Items
   * Identify the 5 most profitable items by total purchase value, then list (in a table):
  * Item ID
  * Item Name
  * Purchase Count
  * Item Price
  * Total Purchase Value
---


```python
final_mostprofitableitems_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>178</td>
      <td>Oathbreaker, Last Hope of the Breaking Storm</td>
      <td>12</td>
      <td>$4.23</td>
      <td>$50.76</td>
    </tr>
    <tr>
      <th>1</th>
      <td>82</td>
      <td>Nirvana</td>
      <td>9</td>
      <td>$4.90</td>
      <td>$44.10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>145</td>
      <td>Fiery Glass Crusader</td>
      <td>9</td>
      <td>$4.58</td>
      <td>$41.22</td>
    </tr>
    <tr>
      <th>3</th>
      <td>92</td>
      <td>Final Critic</td>
      <td>8</td>
      <td>$4.88</td>
      <td>$39.04</td>
    </tr>
    <tr>
      <th>4</th>
      <td>103</td>
      <td>Singed Scalpel</td>
      <td>8</td>
      <td>$4.35</td>
      <td>$34.80</td>
    </tr>
  </tbody>
</table>
</div>



## Observable Trends Summary
___


* Trend 1
  * Using the data found in the Purchasing Analasys by Gender we notice the disparity between males and females when it comes to spending money on items.
84% is male spending, while females come in at just below 15%. That is a substantial difference of about 70% in spending.

* Trend 2
  * Even though the males tend to spend more in total, using the data above we can also notice that the female groups tend to spend more money per item on average. Where, the males will spend about half a dollar on average, the females will spend nearly 6 times that amount on average.

* Trend 3
  * The "Age Demographics" data shows us that although the 15-19 year come in at 23% and the 25-29 age groups are almost 18% of spending, most of the revenue is being generated from the 20-24 year old age group at an astounding % 63.37. 
