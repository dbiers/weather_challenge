# Weather Challenge

API usage challenge with bash.

## Setup

1. Rename `api.conf.sample` to `api.conf`
2. Set API Key value in `api.conf`
3. Run script.

## Usage

```sh

    /path/to/weather.sh -z <ZIPCODE> [-h][-d]

    -z      REQUIRED: ZIP Code for weather request
    -d      Debug mode (set -x)
    -h      Print this help menu

```

## Example Run:

```sh
$ ./weather.sh -z 78413
Date            TempHi/Low          Precipitation
====            ==========          =============
2024-08-27      90.5/81.34          2.03mm
2024-08-28      91.27/82.9          0.76mm
2024-08-29      92.19/83.32         1.77mm
2024-08-30      91.36/83.03         1.2mm
2024-08-31      92.7/82.96          0.68mm
```
