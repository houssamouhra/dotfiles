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
    "113": "",
    "116": "󰖕",
    "119": "",
    "122": "",
    "143": "",
    "176": "",
    "179": "",
    "182": "",
    "185": "",
    "200": "⛈️",
    "227": "🌨️",
    "230": "🌨️",
    "248": "☁️ ",
    "260": "☁️",
    "263": "🌧️",
    "266": "🌧️",
    "281": "🌧️",
    "284": "🌧️",
    "293": "🌧️",
    "296": "🌧️",
    "299": "🌧️",
    "302": "🌧️",
    "305": "🌧️",
    "308": "🌧️",
    "311": "🌧️",
    "314": "🌧️",
    "317": "🌧️",
    "320": "🌨️",
    "323": "🌨️",
    "326": "🌨️",
    "329": "❄️",
    "332": "❄️",
    "335": "❄️",
    "338": "❄️",
    "350": "🌧️",
    "353": "🌧️",
    "356": "🌧️",
    "359": "🌧️",
    "362": "🌧️",
    "365": "🌧️",
    "368": "🌧️",
    "371": "❄️",
    "374": "🌨️",
    "377": "🌨️",
    "386": "🌨️",
    "389": "🌨️",
    "392": "🌧️",
    "395": "❄️",
}

MOON_CODES = {
    "New Moon": "🌑",
    "Waxing Crescent": "🌒",
    "First Quarter": "🌓",
    "Waxing Gibbous": "🌔",
    "Full Moon": "🌕",
    "Waning Gibbous": "🌖",
    "Last Quarter": "🌗",
    "Waning Crescent": "🌘",
}

CACHE_FILE = Path("/tmp/wttr_tangier.json")
CACHE_SECONDS = 600  # 10 minutes


def get_cached():
    if (
        CACHE_FILE.exists()
        and (time.time() - CACHE_FILE.stat().st_mtime) < CACHE_SECONDS
    ):
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
        "chanceofwindy": "Windy",
    }
    conds = [
        f"{label} {int(hour.get(key, 0))}%"
        for key, label in chances.items()
        if int(hour.get(key, 0)) > 0
    ]
    return ", ".join(conds) if conds else "—"


def wind_arrow(winddir16: str) -> str:
    arrows = {
        "N": "↑",
        "NNE": "↗",
        "NE": "↗",
        "ENE": "→",
        "E": "→",
        "ESE": "↘",
        "SE": "↘",
        "SSE": "↓",
        "S": "↓",
        "SSW": "↙",
        "SW": "↙",
        "WSW": "←",
        "W": "←",
        "WNW": "↖",
        "NW": "↖",
        "NNW": "↑",
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
    tooltip.append(
        f"Wind: {wind_arrow(current['winddir16Point'])} {current['windspeedKmph']} km/h"
    )
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
        tooltip.append(
            f"↑ {day['maxtempC']}°C ↓ {day['mintempC']}°C   🌅 {astro['sunrise']}   🌇 {astro['sunset']}"
        )

        for hour in day["hourly"]:
            h = int(hour["time"]) // 100
            if i == 0 and h < now_hour - 2:
                continue
            h_icon = WEATHER_CODES.get(hour["weatherCode"], "❓")
            parts = [
                format_time(hour["time"]),
                h_icon,
                format_temp(hour["FeelsLikeC"]),
                hour["weatherDesc"][0]["value"].strip("."),
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
