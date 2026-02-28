#!/usr/bin/env python3

import json
import requests
from datetime import datetime
from pathlib import Path
import time
import sys

CITY = "Tangier"

# Expanded mapping
WEATHER_CODES = {
    '113': '☀️',       # Sunny / Clear
    '116': '⛅',       # Partly cloudy
    '119': '☁️',       # Cloudy
    '122': '☁️☁️',     # Overcast (double cloud for emphasis)
    '143': '🌫️',      # Mist
    '176': '🌦️',      # Patchy rain nearby
    '179': '🌨️',      # Patchy snow nearby
    '182': '🌧️❄️',    # Patchy sleet nearby
    '185': '🌧️🥶',    # Patchy freezing drizzle
    '200': '⛈️',       # Thundery outbreaks possible
    '227': '🌬️❄️',    # Blowing snow
    '230': '❄️🌪️',    # Blizzard (tornado for strong wind + snow)
    '248': '🌫️',      # Fog
    '260': '🌫️🥶',    # Freezing fog
    '263': '🌧️',      # Patchy light drizzle
    '266': '🌧️',      # Light drizzle
    '281': '🌧️🥶',    # Freezing drizzle
    '284': '🌧️🥶🥶',   # Heavy freezing drizzle
    '293': '🌧️',      # Patchy light rain
    '296': '🌧️',      # Light rain
    '299': '🌧️🌧️',    # Moderate rain at times
    '302': '🌧️🌧️',    # Moderate rain
    '305': '🌧️🌧️',    # Heavy rain at times
    '308': '⛈️🌧️',    # Heavy rain (thunder cloud + rain)
    '311': '🌧️🥶',    # Light freezing rain
    '314': '🌧️🥶🥶',   # Moderate/heavy freezing rain
    '317': '🌨️🌧️',    # Light sleet
    '320': '🌨️🌧️',    # Moderate/heavy sleet
    '323': '🌨️',      # Patchy light snow
    '326': '🌨️',      # Light snow
    '329': '❄️',       # Patchy moderate snow
    '332': '❄️',       # Moderate snow
    '335': '❄️❄️',     # Patchy heavy snow
    '338': '❄️❄️❄️',   # Heavy snow
    '350': '🌨️',      # Ice pellets
    '353': '🌧️',      # Light rain shower
    '356': '🌧️🌧️',    # Moderate/heavy rain shower
    '359': '🌧️⛈️',    # Torrential rain shower
    '362': '🌨️🌧️',    # Light sleet showers
    '365': '🌨️🌧️',    # Moderate/heavy sleet showers
    '368': '🌨️',      # Light snow showers
    '371': '❄️❄️',     # Moderate/heavy snow showers
    '374': '🌨️',      # Light showers of ice pellets
    '377': '🌨️',      # Moderate/heavy showers of ice pellets
    '386': '⛈️🌧️',    # Patchy light rain with thunder
    '389': '⛈️⛈️',     # Moderate/heavy rain with thunder
    '392': '⛈️❄️',     # Patchy light snow with thunder
    '395': '⛈️❄️❄️',   # Moderate/heavy snow with thunder
}

MOON_CODES = {
    'New Moon': '🌑',
    'Waxing Crescent': '🌒',
    'First Quarter': '🌓',
    'Waxing Gibbous': '🌔',
    'Full Moon': '🌕',
    'Waning Gibbous': '🌖',
    'Last Quarter': '🌗',
    'Waning Crescent': '🌘'
}

CACHE_FILE = Path("/tmp/wttr_tangier.json")
CACHE_SECONDS = 600  # 10 minutes

def get_cached():
    if CACHE_FILE.exists() and (time.time() - CACHE_FILE.stat().st_mtime) < CACHE_SECONDS:
        try:
            with CACHE_FILE.open("r") as f:
                return json.load(f)
        except:
            pass
    return None

def save_cache(data):
    try:
        with CACHE_FILE.open("w") as f:
            json.dump(data, f)
    except:
        pass

def format_time(time_str: str) -> str:
    hour = int(time_str) // 100
    return f"{hour:02d}"

def format_temp(temp_str: str) -> str:
    temp = int(temp_str)
    return f"{temp:+d}°"

def format_chances(hour: dict) -> str:
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sun",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Windy"
    }
    conds = [f"{label} {int(hour.get(key,0))}%" for key, label in chances.items() if int(hour.get(key,0)) > 0]
    return ", ".join(conds) if conds else "—"

def wind_arrow(winddir16: str) -> str:
    arrows = {
        "N": "↑", "NNE": "↗", "NE": "↗", "ENE": "→", "E": "→",
        "ESE": "↘", "SE": "↘", "SSE": "↓", "S": "↓", "SSW": "↙",
        "SW": "↙", "WSW": "←", "W": "←", "WNW": "↖", "NW": "↖",
        "NNW": "↑"
    }
    return arrows.get(winddir16.strip(), "→?")

data = {"text": "…", "tooltip": "Weather unavailable"}

cached = get_cached()
if cached:
    print(json.dumps(cached))
    sys.exit(0)

try:
    resp = requests.get(f"https://wttr.in/{CITY}?format=j1", timeout=12)
    resp.raise_for_status()
    weather = resp.json()

    current = weather["current_condition"][0]
    code = current["weatherCode"]
    icon = WEATHER_CODES.get(code, "❓")
    feels_like = current["FeelsLikeC"]
    real_temp = current["temp_C"]
    rain_chance_now = int(current.get("chanceofrain", "0"))

    text_parts = [icon, format_temp(feels_like)]
    if rain_chance_now >= 40:
        text_parts.append(f"🌧️{rain_chance_now}%")

    data["text"] = " ".join(text_parts)

    tooltip = []
    tooltip.append(f"<b>{current['weatherDesc'][0]['value']}  {real_temp}°C</b>")
    tooltip.append(f"Feels like: {feels_like}°C")
    tooltip.append(f"Wind: {wind_arrow(current['winddir16Point'])} {current['windspeedKmph']} km/h")
    tooltip.append(f"Humidity: {current['humidity']}%")
    tooltip.append("")

    now_hour = datetime.now().hour

    for i, day in enumerate(weather["weather"]):
        line = []
        if i == 0:
            line.append("Today")
            # Add moon phase for today
            astro = day["astronomy"][0]
            moon = astro.get("moon_phase", "Unknown")
            moon_icon = MOON_CODES.get(moon, "🌙")
            line.append(f"({moon_icon} {moon})")
        elif i == 1:
            line.append("Tomorrow")
        line.append(day["date"])
        tooltip.append(f"<b>{' '.join(line)}</b>")

        astro = day["astronomy"][0]
        tooltip.append(f"↑ {day['maxtempC']}°C ↓ {day['mintempC']}°C   🌅 {astro['sunrise']}   🌇 {astro['sunset']}")

        for hour in day["hourly"]:
            h = int(hour["time"]) // 100
            if i == 0 and h < now_hour - 2:
                continue
            h_icon = WEATHER_CODES.get(hour["weatherCode"], "❓")
            parts = [
                format_time(hour["time"]),
                h_icon,
                format_temp(hour["FeelsLikeC"]),
                hour["weatherDesc"][0]["value"].strip(".")
            ]
            chances = format_chances(hour)
            if chances != "—":
                parts.append(f"({chances})")
            tooltip.append("  ".join(parts))
        tooltip.append("")

    data["tooltip"] = "\n".join(tooltip).strip()

    save_cache(data)

except Exception as e:
    data["text"] = "…?"
    data["tooltip"] = f"Fetch failed\n({str(e)})\nCheck internet / wttr.in"

print(json.dumps(data))
