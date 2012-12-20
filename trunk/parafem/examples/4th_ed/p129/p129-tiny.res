Number of processors used:                             4
Number of nodes in the mesh:                         321
Number of nodes that were restrained:                 21
Number of equations solved:                          900
Total load applied:                           0.2500E+02

        Time t  cos(omega*t)  Displacement    Iterations
    0.3142E+02    0.9511E+00    0.1416E-01           131
    0.6283E+02    0.8090E+00    0.1266E-01           131
    0.9425E+02    0.5878E+00    0.9102E-02           131
    0.1257E+03    0.3090E+00    0.4820E-02           130
    0.1571E+03    0.6123E-16    0.8351E-04           149
    0.1885E+03   -0.3090E+00   -0.4662E-02           131
    0.2199E+03   -0.5878E+00   -0.8953E-02           130
    0.2513E+03   -0.8090E+00   -0.1237E-01           130
    0.2827E+03   -0.9511E+00   -0.1457E-01           130
    0.3142E+03   -0.1000E+01   -0.1535E-01           131
    0.3456E+03   -0.9511E+00   -0.1462E-01           130
    0.3770E+03   -0.8090E+00   -0.1247E-01           130
    0.4084E+03   -0.5878E+00   -0.9089E-02           130
    0.4398E+03   -0.3090E+00   -0.4822E-02           130
    0.4712E+03    0.7045E-15   -0.8376E-04           151
    0.5027E+03    0.3090E+00    0.4662E-02           131
    0.5341E+03    0.5878E+00    0.8953E-02           130
    0.5655E+03    0.8090E+00    0.1237E-01           130
    0.5969E+03    0.9511E+00    0.1457E-01           130
    0.6283E+03    0.1000E+01    0.1535E-01           130
    0.6597E+03    0.9511E+00    0.1462E-01           130
    0.6912E+03    0.8090E+00    0.1247E-01           130
    0.7226E+03    0.5878E+00    0.9089E-02           130
    0.7540E+03    0.3090E+00    0.4822E-02           130
    0.7854E+03   -0.5820E-15    0.8375E-04           148
    0.8168E+03   -0.3090E+00   -0.4662E-02           131
    0.8482E+03   -0.5878E+00   -0.8953E-02           130
    0.8796E+03   -0.8090E+00   -0.1237E-01           130
    0.9111E+03   -0.9511E+00   -0.1457E-01           130
    0.9425E+03   -0.1000E+01   -0.1535E-01           130
    0.9739E+03   -0.9511E+00   -0.1462E-01           130
    0.1005E+04   -0.8090E+00   -0.1247E-01           130
    0.1037E+04   -0.5878E+00   -0.9089E-02           130
    0.1068E+04   -0.3090E+00   -0.4822E-02           130
    0.1100E+04   -0.4286E-15   -0.8376E-04           151
    0.1131E+04    0.3090E+00    0.4663E-02           130
    0.1162E+04    0.5878E+00    0.8953E-02           130
    0.1194E+04    0.8090E+00    0.1237E-01           130
    0.1225E+04    0.9511E+00    0.1457E-01           130
    0.1257E+04    0.1000E+01    0.1535E-01           130

Program section execution times                   Seconds  %Total    
Setup                                            0.067827    4.49
Compute steering array                           0.000096    0.01
Compute interprocessor communication tables      0.000288    0.02
Allocate neq_pp arrays                           0.000035    0.00
Element stiffness integration                    0.006082    0.40
Build the diagonal preconditioner                0.000074    0.00
Read the applied forces                          0.001209    0.08
Solve the equations                              1.368770   90.51
Output the results                               0.065400    4.32
Total execution time                             1.512295  100.00