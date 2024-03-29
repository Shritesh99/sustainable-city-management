# -*- coding: utf-8 -*-
"""ASE ML.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1_x-5XI_-UwuT-QQu-gyAsgQBToxRX5ct
"""

import pandas as pd
import numpy as np
from statsmodels.tsa.api import VAR
# Get current path
import os

path = os.getcwd()

file_path = None
if os.path.exists(path+'data/pedestrian.csv'):
    file_path = path+'data/pedestrian.csv'
else:
    file_path = path+'pedestrian.csv'

df = pd.read_csv(file_path, parse_dates=['Time'])
df_original = df    
df = df.set_index('Time')
data = df.iloc[:, :]
forecast_index = pd.date_range(start=df.index[-1], periods=25, freq='H')
print(forecast_index)
forecast_index = forecast_index[1:]
model = VAR(data)
model_fit = model.fit(maxlags=24, ic='aic')

forecast = model_fit.forecast(model_fit.endog, steps=24)
forecast = np.clip(forecast, 0, None)
forecast = np.round(forecast).astype(int)
forecast_df = pd.DataFrame(forecast, index=forecast_index, columns=df.columns)
forecast_df.reset_index(drop=False, inplace=True)
forecast_df = forecast_df.rename(columns={'index': 'Time'})
merged_df = pd.concat([df_original, forecast_df], axis=0)
merged_df.to_csv(path+'data/pedestrian.csv', index=False)
