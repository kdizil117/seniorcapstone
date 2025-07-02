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

connection_string_Housing = "mssql+pyodbc:///?odbc_connect=DRIVER={ODBC Driver 18 for SQL Server};SERVER=KALLESPC;DATABASE=Housing;Encrypt=NO;Trusted_Connection=yes"
connection_string_GDP_GROWTH = "mssql+pyodbc:///?odbc_connect=DRIVER={ODBC Driver 18 for SQL Server};SERVER=KALLESPC;DATABASE=GDP_GROWTH_1998_2024_STATE;Encrypt=NO;Trusted_Connection=yes"
engine = sa.create_engine(connection_string_Housing)

#upload,read and show table
Housing_prices_df = pd.read_sql('hpi_po_monthly_hist', engine)
Housing_prices_df['array_hpi_values'] = Housing_prices_df[Housing_prices_df.columns.tolist()].apply(lambda row: row.values.tolist(),axis=1)
print (Housing_prices_df.head())