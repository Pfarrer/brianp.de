set term png
set output "plot.png"

set xdata time
set format x "%d. \n %H:%M"
set timefmt "%d-%H:%M"

show style line
set ylabel 'Supercapacitor Voltage'
set xlabel 'Day and Time'

set style line 1 lt rgb "blue" lw 1 pt 2
set style line 2 lc rgb "blue" pt 7
set style line 3 lt rgb "#5cc863" lw 1 pt 2
set style line 4 lc rgb "#5cc863" pt 7
set style line 5 lt rgb "red" lw 1 pt 2

set arrow from "1-14:00",0.35 to "5-10:45",0.35 nohead linestyle 5
set label "Boost Converter V_{min}" left at graph 0.02, graph 0.15

plot "darkened.data" using 1:2 w lines ls 1 title 'Darkened Solar Panel', \
    "" using 1:2 w points ls 2 title '', \
    "disconnected.data" using 1:2 w lines ls 3 title 'Disconnected Solar Panel', \
    "" using 1:2 w points ls 4 title ''