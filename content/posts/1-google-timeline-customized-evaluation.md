+++
title = "Idea and Motivation to build a custom Geo-data analytics and evaluation system based on Google Timeline"
date = "2019-09-26"
tags = [
    "google",
    "timeline",
    "analytics",
    "data",
    "docker",
    "rust",
    "elastic",
    "elasticsearch",
    "kibana",
    "docker",
]
toc = true
draft = true
+++

[Google Timeline](https://www.google.com/maps/timeline) is an optional feature of Google Maps that keeps track of your location history and activities. The data is recorded by the Google Maps app on your smartphone if the feature is enabled. Google will also classify your movements and assigns them the most plausible means of transportation.

![Google Timeline example of a Rome visit](/google-timeline-rome.jpg)

With the help of [Google Takeout](https://takeout.google.com/settings/takeout), the collected data can be downloaded including enriched details by Google, e.g. means of transportation.

I have Google Timeline enabled partially in 2012 and 2013, and permanently since 2014, that means about 10 years of movement data, at the time of writing this article. The JSON data export compressed as a ZIP archive is about 35 MB in size. Uncompressed it takes nearly 500 MB of disk space.

The files in the unwrapped archive have the following structure (for some reason, Google has localized file and folder names in the archive, thus, this could differ with your export, mine is in German):

```
.
├── Archiv_U?\210bersicht.html
└── Standortverlauf
    ├── Semantic\ Location\ History
    │   ├── 2012
    │   │   ├── 2012_DECEMBER.json
    │   │   └── 2012_NOVEMBER.json
    │   ├── 2013
    │   │   └── 2013_DECEMBER.json
    │   ├── 2014
    │   │   ├── 2014_APRIL.json
    │   │   ├── 2014_AUGUST.json
    │   │   ├── 2014_DECEMBER.json

[...]

    │   ├── 2019
    │   │   ├── 2019_APRIL.json
    │   │   ├── 2019_AUGUST.json
    │   │   ├── 2019_FEBRUARY.json
    │   │   ├── 2019_JANUARY.json
    └── Standortverlauf.json
```

The json-files are the ones that contain the relevant data. There are two basic kinds of json-files:

- Those in the `Standortverlauf/Semantic\ Location\ History` folder are separated by year and month, e.g. `2019_APRIL.json`. These files ... TODO
- The `Standortverlauf/Standortverlauf.json` file appears to contain all raw location records that were collected, each record may be enriched with further information deduced by Google.
