import datetime
from datetime import timedelta
import numpy as np
import pandas as pd
import psycopg2
from statsmodels.tsa.arima.model import ARIMA
import os
import time

os.environ['TZ'] = 'Europe/London'
time.tzset()

conn = psycopg2.connect(
    database='masterdb',
    user='group_admin',
    password='group007',
    host='18.202.24.40',
    port='5432'
)
print("connected")
# Use the connection to create a Pandas DataFrame
data = pd.read_sql_query("SELECT * FROM aqi_data", conn, index_col="insert_time")
data = data.fillna(0)
# Group the data by station
stations = data.groupby('station_id')

# Loop over each station

cursor = conn.cursor()
cursor.execute(
    "DELETE FROM aqi_forecast Where station_id != '1'")
conn.commit()

for name, station in stations:

    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO aqi_forecast (station_id,forecast_time,aqi,pm25,pm10,ozone,no2,so2,co,latitude,longitude) Values (%s,%s,0,0,0,0,0,0,0,0,0)",
        (str(name),str(datetime.datetime.now())))
    conn.commit()
    #AQI
    aqi = station['aqi'].values
    if len(aqi) < 3:
        aqi = np.append(aqi, [0])

    # Create a time series model
    model = ARIMA(aqi, order=(2, 1, 2))
    model_fit = model.fit()

    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
       "UPDATE aqi_forecast SET forecast_time = %s, aqi = %s WHERE station_id = %s",
       (forecast_time, prediction, name))
    conn.commit()


    # NO2
    no2 = station['no2'].values
    if len(no2) < 3:
        no2 = np.append(no2, [0])

    # Create a time series model
    model = ARIMA(no2, order=(2, 1, 2))
    model_fit = model.fit()

    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE aqi_forecast SET forecast_time = %s, no2 = %s WHERE station_id = %s",
        (forecast_time, prediction, name))
    conn.commit()

    # SO2
    so2 = station['so2'].values
    if len(so2) < 3:
        so2 = np.append(so2, [0])

    # Create a time series model
    model = ARIMA(so2, order=(2, 1, 2))
    model_fit = model.fit()

    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE aqi_forecast SET forecast_time = %s, so2 = %s WHERE station_id = %s",
        (forecast_time, prediction, name))
    conn.commit()

    # pm25
    pm25 = station['pm25'].values
    if len(pm25) < 3:
        pm25 = np.append(pm25, [0])

    # Create a time series model
    model = ARIMA(pm25, order=(2, 1, 2))
    model_fit = model.fit()

    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE aqi_forecast SET forecast_time = %s, pm25 = %s WHERE station_id = %s",
        (forecast_time, prediction, name))
    conn.commit()

    # pm10
    pm10 = station['pm10'].values
    if len(pm10) < 3:
        pm10 = np.append(pm10, [0])

    # Create a time series model
    model = ARIMA(pm10, order=(2, 1, 2))
    model_fit = model.fit()

    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE aqi_forecast SET forecast_time = %s, pm10 = %s WHERE station_id = %s",
        (forecast_time, prediction, name))
    conn.commit()

    # ozone
    ozone = station['ozone'].values
    if len(ozone) < 3:
        ozone = np.append(ozone, [0])

    # Create a time series model
    model = ARIMA(ozone, order=(2, 1, 2))
    model_fit = model.fit()

    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE aqi_forecast SET forecast_time = %s, ozone = %s WHERE station_id = %s",
        (forecast_time, prediction, name))
    conn.commit()

    # ozone
    co = station['co'].values
    if len(co) < 3:
        co = np.append(co, [0])

    # Create a time series model
    model = ARIMA(co, order=(2, 1, 2))
    model_fit = model.fit()
    lat = station['latitude'].values[0]
    long = station['longitude'].values[0]
    # Make a prediction for the next hour
    prediction = model_fit.forecast()[0]
    last_timestamp = station.index[-1]
    forecast_time = datetime.datetime.now() + timedelta(hours=1)
    # Insert the predicted AQI value and the forecast time into a table
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE aqi_forecast SET forecast_time = %s, latitude = %s, longitude = %s, co = %s WHERE station_id = %s",
        (forecast_time,lat,long, prediction, name))
    conn.commit()

# Close the database connection
conn.close()
