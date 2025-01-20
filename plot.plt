set multiplot
set key off
set size 0.5,0.5
set xlabel 'T'
set origin 0.0,0.5
set ylabel '<S>'
plot [0:6] [-400:3500]"output.dat" using 1:2 w lp
set origin 0.5,0.5
set ylabel '<E>'
plot [0:6] [-20000:0] "output.dat" using 1:3 w lp
set origin 0.0,0.0
set ylabel 'Cv'
plot [0:6] [0:25000] "output.dat" using 1:4 w lp