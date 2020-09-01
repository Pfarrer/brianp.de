set term png
set output "plot.png"

set xdata time
set format x "%H:%M"
set timefmt "%H:%M"

show style line
set ylabel 'Super Capacitor Voltage'
set xlabel 'Minutes/Seconds after Connect'

set style line 1 lt rgb "blue" lw 1 pt 2
set style line 2 lc rgb "blue" pt 7

plot "charge.data" using 1:2 w lines ls 1 title 'Direct Sunlight', \
    "" using 1:2 w points ls 2 title ''