import pandas as pd
import numpy as np
from typing import Literal

Direction = Literal["consumption", "generation"]
Frequency = Literal["15min", "1h"]

def create_data(
    mp_id: str,
    mp_name: Optional[str]
    mp_type: Direction,
    location: str,
    start_date: pd.Timestamp,
    end_date: pd.Timestamp,
    freq: Frequency,
    data_type: bool
) -> pd.DataFrame:
    timestamps = pd.date_range(start=start_date, end=end_date, freq=freq, inclusive="left")

    base = np.sin(np.linspace(0, 2*np.pi, len(timestamps))) + 1

    rng = np.random.default_rng(42)
    noise = rng.normal(0, 0.1, len(timestamps))
    
    values = (base + noise).clip(min=0)

    if direction == "consumption":
        consumption = values
        generation = np.full(len(values), np.nan)
    else:
        consumption = np.full(len(values), np.nan)
        generation = values
    
    df = pd.DataFrame({
        "meter_id": meter_id,
        "location": location,
        "timestamp": timestamps,
        "consumption": consumption,
        "generation": generation,
        "forecast": forecast
    })

    return df.astype({
        "meter_id": "string",
        "location": "string",
        "consumption": "float64",
        "generation": "float64",
        "forecast": "bool"
    })

TZ = "Europe/Vienna"
now = pd.Timestamp.now(tz=TZ)
today_00 = now.normalize()
start_date = today_00 - pd.Timedelta(days=3)
# start_date = pd.Timestamp("2026-04-10", tz=TZ).normalize()
yesterday_00 = today_00 - pd.Timedelta(days=1)
day_after_tomorrow_00 = today_00 + pd.Timedelta(days=2)

def create_actual_and_forecast(
    meter_id: str,
    location: str,
    direction: Direction,
    start_actual: pd.Timestamp = start_date,
    start_forecast: pd.Timestamp = yesterday_00,
    end_forecast: pd.Timestamp = day_after_tomorrow_00
) -> pd.DataFrame:

    df_actual = create_data(
        meter_id=meter_id,
        location=location,
        direction=direction,
        start_date=start_actual,
        end_date=start_forecast,
        freq="15min",
        forecast=False
    )

    df_forecast = create_data(
        meter_id=meter_id,
        location=location,
        direction=direction,
        start_date=start_forecast,
        end_date=end_forecast,
        freq="1h",
        forecast=True
    )

    return pd.concat([df_actual, df_forecast])

def create_testdata(start_date: pd.Timestamp = start_date) -> pd.DataFrame:
    location_home = "Wohnhaus"
    location_work = "Firma"

    mp_1 = create_actual_and_forecast("mp_1", location_home, "consumption", start_date)
    mp_2 = create_actual_and_forecast("mp_2", location_home, "generation", start_date)
    mp_3 = create_actual_and_forecast("mp_3", location_work, "consumption", start_date)
    mp_4 = create_actual_and_forecast("mp_4", location_work, "generation", start_date)
    
    return pd.concat([mp_1, mp_2, mp_3, mp_4])