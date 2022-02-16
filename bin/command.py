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

def print_prompt(title, value, exit):
    print(json.dumps({
        "view": {
            "type": "list",
            "options": [
                {
                    "title": title,
                    "action": {
                    "type": "copy",
                    "value": value
                    }
                }
            ]
        }
    }))

    if exit:
        sys.exit()

if len(sys.argv) > 1:
    user_input = sys.argv[1]

    # input_string = "1030pm sf ath"
    # slapdash appends a --query= prefix in the arguments string when rerunning a Form
    input_string = user_input.replace("--query=", "", 1)
    try:
        input_time = input_string.split()[0]
        input_tz_from = input_string.split()[1]
        input_tz_to = input_string.split()[2]
    except IndexError:
        print_prompt("Wrong input, please try again.", "Wrong input, please try again.", True)

    if (input_tz_from in tz_dict.keys()) and (input_tz_to in tz_dict.keys()):
        try:
            input_time_dissect = time.strptime(input_time, "%I%p")
        except ValueError:
            input_time_dissect = time.strptime(input_time, "%I%M%p")

        input_hour = input_time_dissect.tm_hour
        input_min = input_time_dissect.tm_min

        today = datetime.date.today()
        day = today.strftime("%d")
        month = today.strftime("%m")
        year = today.strftime("%Y")

        input_time_object = datetime.datetime(int(year), int(month), int(day),
            input_hour, input_min, tzinfo=zoneinfo.ZoneInfo(key=tz_dict[input_tz_from]))

        as_tz = input_time_object.astimezone(pytz.timezone(tz_dict[input_tz_to]))
        as_tz_h = as_tz.strftime("%H")
        as_tz_m = as_tz.strftime("%M")
        as_tz_p = as_tz.strftime("%p")

        res = f"{as_tz_h}:{as_tz_m} {as_tz_p} {input_tz_to.upper()}"

        print_prompt(res, res, True)
    else:
        print_prompt("Wrong input, please try again.", "Wrong input, please try again.", True)


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