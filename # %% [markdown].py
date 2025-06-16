# %% [markdown]
# We will use a artificial recurrent nueral network called a LSTM (Long Short Term Memory) to predict Housing prices. I will pull data from the sql databases that I created
# 

# %%
#import Libraries
import math 
import pandas_datareader as web
import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers import Dense, LSTM
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
plt.style.use('fivethirtyeight')
import datetime
import pandas as pd
import sqlalchemy as sa


# %%
#need to create a connection string between the server and python
connection_string_Housing = "mssql+pyodbc:///?odbc_connect=DRIVER={ODBC Driver 18 for SQL Server};SERVER=KALLESPC;DATABASE=Housing;Encrypt=NO;Trusted_Connection=yes"
connection_string_GDP_GROWTH = "mssql+pyodbc:///?odbc_connect=DRIVER={ODBC Driver 18 for SQL Server};SERVER=KALLESPC;DATABASE=GDP_GROWTH_1998_2024_STATE;Encrypt=NO;Trusted_Connection=yes"
engine = sa.create_engine(connection_string_Housing)

#upload,read and show table
Housing_prices_df = pd.read_sql('hpi_avg_monthly', engine)
print (Housing_prices_df.head())





# %%
#Get number of rows and columns
print(Housing_prices_df.shape)
print (Housing_prices_df['column1'].max())

# %%
#Visualize the data 
#Housing_prices_df['Year'] = pd.to_datetime(Housing_prices_df['Year'])
Housing_prices_df.set_index('column1',inplace=True)
Housing_prices_df.sort_index(inplace=True)
plt.figure(figsize=(16,8))
plt.title('HPI over years')
#plt.plot(Housing_prices_df['Year'],Housing_prices_df['avg_hpi'])
plt.xlabel('Date', fontsize=8)
plt.ylabel('hpi', fontsize=18)
Housing_prices_df.plot(ax=plt.gca())
plt.show()

# %%
#create a new dataframe with only the "Close" column
close_stock = Housing_prices_df#.filter(['avg_hpi_year'])
#Convert the data frame to a numpy array
dataset = close_stock.to_numpy()
print(dataset)
#get the number of rows to train the model on 
Training_data_len = math.ceil(len(dataset)*.9)
Training_data_len


# %%
#Good practice to Scale the data
scaler = MinMaxScaler(feature_range=(0,1))
#create variable to hold scaled data
print(dataset.shape)
scaled_data = scaler.fit_transform(dataset)#<----computes minimum and maximum values that are used for scaling and transforms data based on those values

scaled_data

# %%
#Create the training data set
#Create the Scaled training data set
train_data = scaled_data[0:Training_data_len , :]
#Split the data into x_train and y_train data sets
x_train = []
y_train = []

for i in range(308, len(train_data)):
    x_train.append(train_data[i-308:i,0])
    y_train.append(train_data[i,0])
    if i<=309:
        print(x_train)
        print(y_train)
        print()
#the first 229 values(x_train) are the values that will train the data to predict the 230th value(y_train)

# %%
#convert the x_train and y_train to numpy arrays
x_train, y_train = np.array(x_train), np.array(y_train)


# %%
#Reshape the data
x_train = np.reshape(x_train,(x_train.shape[0], x_train.shape[1], 1))
x_train.shape

# %%
#Build the LSTM model
model = Sequential()
model.add(LSTM(50, return_sequences= True, input_shape= (x_train.shape[1],1)))
model.add(LSTM(50, return_sequences= False))
model.add(Dense(25))
model.add(Dense(1))

# %%

#Compile the model
model.compile(optimizer='adam', loss='mean_squared_error')

# %%
#train the model
model.fit(x_train, y_train, batch_size=1, epochs=1)

# %%
#Create the testing data set
test_data = scaled_data[Training_data_len - 40: , :  ]
#Create the data sets x_test and y_test
x_test = []
y_test = dataset[Training_data_len:, :]
for i in range(40, len(test_data)):
    x_test.append(test_data[i-40:i, 0])
    

# %%
#Convert the data to a numpy array
x_test = np.array(x_test)

# %%
x_test = np.reshape(x_test,(x_test.shape[0],x_test.shape[1], 1 ))

# %%
#Get the models predicted price values
predictions = model.predict(x_test)
predictions = scaler.inverse_transform(predictions)

# %%
#Get the root mean squared error (RMSE) it is the standard deviation of the residuals and you want lower values
rmse = np.sqrt(np.mean(predictions - y_test)**2 )
rmse

# %%
#Plot the data
train = Housing_prices_df[:Training_data_len]
valid = Housing_prices_df[Training_data_len:]
valid['Predictions'] = predictions
#visualize the data
plt.figure(figsize=(16,8))
plt.title('Model')
plt.xlabel('Date', fontsize = 18)
plt.ylabel('HPI_avg', fontsize=18)
plt.plot(train['avg_hpi'])
plt.plot(valid[['avg_hpi','Predictions']])
plt.legend(['Train','Val','Predictions'], loc = 'lower right')
plt.show()

# %%
#Show the valid and predicted prices
valid


