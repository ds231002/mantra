import pandas as pd
import numpy as np
from typing import Literal

# =====================================
# Metadata
# =====================================

def validate_meter_directions(df: pd.DataFrame):
    df_check = (
        df.groupby("meter_id")
        .agg({
            "consumption": lambda x: x.notna().any(),
            "generation": lambda x: x.notna().any()
        })
    )

    invalid_both = df_check[
        (df_check["consumption"]) &
        (df_check["generation"])
    ]

    invalid_none = df_check[
        (~df_check["consumption"]) &
        (~df_check["generation"])
    ]

    if not invalid_both.empty:
        raise ValueError(f"Meter mit beiden Richtungen:\n{invalid_both}")

    if not invalid_none.empty:
        raise ValueError(f"Meter ohne Richtung:\n{invalid_none}")

    return True

def get_meter_metadata(df: pd.DataFrame) -> pd.DataFrame:
    validate_meter_directions(df)

    df_meta = (
        df.groupby(["meter_id", "location"])
        .agg({
            "consumption": lambda x: x.notna().any(),
            "generation": lambda x: x.notna().any()
        })
        .reset_index()
    )

    df_meta["direction"] = np.where(
        df_meta["consumption"],
        "consumption",
        "generation"
    )

    return df_meta[["meter_id", "location", "direction"]]

def get_direction_for_meter_id(df: pd.DataFrame, meter_id: str) -> str:
    meta = get_meter_metadata(df)
    return meta.loc[
        meta["meter_id"] == meter_id, "direction"
    ].iloc[0]

# =====================================
# Timeseries
# =====================================

def get_data(
    df: pd.DataFrame,
    meter_id: str = None,
    location: str = None,
    start: str = None,
    end: str = None,
    forecast: bool = None,
) -> pd.DataFrame:
    TZ = "Europe/Vienna"

    if start is not None:
        start = pd.Timestamp(start, tz=TZ)
    if end is not None:
        end = pd.Timestamp(end, tz=TZ)

    result = df.copy()

    if meter_id is not None:
        result = result[result["meter_id"] == meter_id]

    if location is not None:
        result = result[result["location"] == location]

    if forecast is not None:
        result = result[result["forecast"] == forecast]

    if start is not None:
        result = result[result["timestamp"] >= start]

    if end is not None:
        result = result[result["timestamp"] < end]

    return result.sort_values("timestamp").reset_index(drop=True)