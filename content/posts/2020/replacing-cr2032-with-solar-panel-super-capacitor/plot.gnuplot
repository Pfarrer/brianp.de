set term png
set output "plot.png"

set xdata time
set format x "%d. \n %H:%M"
set timefmt "%d-%H:%M"

show style line
set ylabel 'Supercapacitor Voltage'
set xlabel 'Day and Time'

set style line 1 lt rgb "blue" lw 1 pt 2
set style line 2 lc rgb 'blue' pt 7

plot "plot.data" using 1:2 w lines ls 1 title 'Darkened Solar Panel', \
    "" using 1:2 w points ls 2 title ''