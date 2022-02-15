#!/opt/homebrew/bin/python3

import time, datetime, json, pytz, zoneinfo, sys, json

# get input
# convert text input to a properly formatted time object
# convert time object from input FROM tz to input TO tz
# return result

tz_dict = {
    "ath": "Europe/Athens",
    "lon": "Europe/London",
    "nyc": "America/New_York",
    "sf": "America/Los_Angeles"
}

if len(sys.argv) > 1:
    user_input = sys.argv[1]

    # input_string = "1030pm sf ath"
    # slapdash appends a --query= prefix in the arguments string when rerunning a Form
    input_string = user_input.replace("--query=", "", 1)
    input_time = input_string.split()[0]
    try:
        input_tz_from = input_string.split()[1]
        input_tz_to = input_string.split()[2]
    except IndexError:
        sys.exit()
    has_minutes = False

    try:
        input_time_dissect = time.strptime(input_time, "%I%p")
    except ValueError:
        input_time_dissect = time.strptime(input_time, "%I%M%p")
        has_minutes = True

    input_hour = input_time_dissect.tm_hour
    input_min = input_time_dissect.tm_min

    today = datetime.date.today()
    day = today.strftime("%d")
    month = today.strftime("%m")
    year = today.strftime("%Y")

    if input_tz_from in tz_dict.keys():
        if not has_minutes:
            # input_time_object = datetime.datetime.strptime(input_time, "%I%p").time()
            input_time_object = datetime.datetime(int(year), int(month), int(day), input_hour,
                tzinfo=zoneinfo.ZoneInfo(key=tz_dict[input_tz_from]))
        else:
            input_time_object = datetime.datetime(int(year), int(month), int(day), input_hour, input_min,
                tzinfo=zoneinfo.ZoneInfo(key=tz_dict[input_tz_from]))

    # as_tz = input_time_object.astimezone(pytz.timezone(tz_list[1]))
    if input_tz_to in tz_dict.keys():
        as_tz = input_time_object.astimezone(pytz.timezone(tz_dict[input_tz_to]))

    res = as_tz.strftime("%H") + ":" + as_tz.strftime("%M") + as_tz.strftime("%p")

    print(json.dumps({
        "view": {
              "type": "list",
              "options": [
                  {
                      "title": str(res),
                      "action": {
                          "type": "copy",
                          "value": str(res)
                      }
                  }
              ]
              }
        }))
    sys.exit()

print(json.dumps({
    "view": {
      "type": "form",
      "title": "Timezone Query",
      "submitLabel": "Run",
      "fields": [
        {
          "type": "text",
          "id": "query",
          "label": "Your Query",
        },
      ],
    },
  }))