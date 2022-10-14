#!/home/tom/.asdf/installs/python/3.9.4/bin/python
import requests
import pytz
import dateutil.parser
from datetime import datetime, timedelta

try:
    event = requests.get("https://myapi.home.tomusher.com/calendar/next-event/").json()
except:
    print("")
    exit(0)

now = datetime.now(pytz.utc)
tomorrow = now.replace(hour=0, minute=0, second=0, microsecond=0) + timedelta(days=1)
date = dateutil.parser.isoparse(event['date'])
nice_date = date.strftime("%H:%M")

if date > tomorrow:
    print("")
    exit(0)

start_format_string = ""
end_format_string = ""

if date < now + timedelta(minutes=15):
    date_diff = date - now
    if date_diff.days >= 0:
        minutes_diff = date_diff.seconds//3600 + ((date_diff.seconds//60)%60)
        normalized = minutes_diff * 17
        hexed = hex(normalized)[2:]
    else:
        hexed = "ff"

    start_format_string = f"%{{B{hexed}bf616a}}"
    end_format_string = "%{B- F-}"


print(f"{start_format_string} {nice_date} - {event['summary']} {end_format_string}")

