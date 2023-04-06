from datetime import timedelta
import numpy as np
import pandas as pd
import psycopg2
from statsmodels.tsa.arima.model import ARIMA

conn = psycopg2.connect(
    database='masterdb',
    user='group_admin',
    password='group007',
    host='18.202.24.40',
    port='5432'
)

# Use the connection to create a Pandas DataFrame
data = pd.read_sql_query("SELECT * FROM aqi_data", conn, index_col="insert_time")
data = data.fillna(0)
# Group the data by station
stations = data.groupby('station_id')

# Loop over each station
for name, station in stations:
    aqi = station['aqi'].values
    if (len(aqi) < 3):
        aqi = np.append(aqi, [0])
# Create a time series model
model = ARIMA(aqi, order=(2, 1, 2))
model_fit = model.fit()

# Make a prediction for the next hour
prediction = model_fit.forecast()[0]
last_timestamp = station.index[-1]
print(name)
print(last_timestamp)
forecast_time = last_timestamp + timedelta(hours=1)
print(type(prediction))
# Insert the predicted AQI value and the forecast time into a table
cursor = conn.cursor()
cursor.execute(
"UPDATE aqi_forecast SET forecast_time = %s, predicted_aqi = %s WHERE station_id = %s",
(forecast_time, prediction, name))
conn.commit()

print("Forecast time:", forecast_time)

print('The predicted AQI for the next hour is:', prediction)

# Close the database connection
conn.close()
