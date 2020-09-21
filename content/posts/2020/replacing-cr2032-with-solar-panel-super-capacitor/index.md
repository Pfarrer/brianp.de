+++
title = "Replacing a Battery with a Solar Panel and a Super Capacitor"
date = "2020-08-03"
tags = [
    "CR2032",
    "solar",
    "super-capacitor",
    "boost-converter",
    "electronics",
]
draft = true
+++

CR2032 batteries usually power devices with very low energy requirements. A typical use-case for such a battery is, keeping an internal clock active even if the main power supply is not available. The device will be able to maintain the correct date and time even when turned off and not connected to any other power source. An example device that makes use of this is, a common mainboard - an essential part of every computer.

The device I selected to equip with a solar-powered circuit instead of the build-in CR2032 battery is the Mi Flora plant sensor.
It is powered by a single CR2032 battery which lasts at least 6 months when the sensor is used once every 10 minutes. See my other post on <a href="{{< ref "plant-monitoring-xiaomi-miflora-rasperrypi-grafana" >}}" target="_blank">Mi Flora based plant monitoring</a>.

## Buffer

I planed to use a small 3 V solar cell to collect the energy from the sunlight. A single cell should be (far) more than enough to power a sensor. The solar power yield is far less during the night, or on a cloudy day. Therefore, I added an energy buffer to store excess energy for periods with low yield. A standard battery was my initial idea, but that would suffer from the environment as the CR2032 battery did (constantly changing temperatures). I ended up selecting a super capacitor for that purpose. It is basically not affected by changing temperatures and it can deal nicely with getting charged and discharged constantly.

To prevent the super capacitor from discharging through the connected solar cell, a diode must be added that allows the flow only into the super capacitor. It also has the nice benefit of reducing the maximal  voltage provided by the solar cell. The super capacitor is only rated for a maximum of 3 V, but the solar cell has an open-circuit voltage in direct sunlight of about 3.4 V. A diode drops about 0.6 to 0.7 V, therefore, the theoretical maximal voltage that could be delivered to the super capacitor is 2.8 V. Indeed, I measured this voltage in the super capacitor on a very sunny day.

The following image shows the charging curve of the super capacitor in direct sunlight. I had to stop the measurement after about 4 minutes since a few clouds blocked the direct sunlight. Nevertheless, the conclusion of this curve is that it takes only about 5 minutes to charge the super capacitor to capacity.

![Charging curve of the super capacitor in direct sunlight](charge/plot.png)

## Regulator

![Discharging curve of the super capacitor](discharge/plot.png)

![Circuit diagram](circuit/circuit.jpg)
