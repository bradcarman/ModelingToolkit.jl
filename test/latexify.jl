using Test
using Latexify
using ModelingToolkit

### Tips for generating latex tests:
### Latexify has an unexported macro:
###
### Latexify.@generate_test
###
### which generates a test using a given latexify function.
### For example:
###
### Latexify.@generate_test latexify([1, 2, 3], [4, 5, 6]; env=:mdtable)
###
### This puts a ready-made test in your clipboard which you can paste into the
### test file.
###
### Just be sure to remove all such macros before you commit a change since it
### will cause issues with Travis.

@parameters t σ ρ β
@variables x(t) y(t) z(t)
@derivatives D'~t

eqs = [D(x) ~ σ*(y-x)*D(x-y)/D(z),
       0 ~ σ*x*(ρ-z)/10-y,
       D(z) ~ x*y^(2//3) - β*z]

@test latexify(eqs) == raw"""\begin{align}
\frac{dx(t)}{dt} =& \frac{\sigma \left( y\left( t \right) - x\left( t \right) \right) \frac{d\left(x\left( t \right) - y\left( t \right)\right)}{dt}}{\frac{dz(t)}{dt}} \\
0 =& \frac{\sigma x\left( t \right) \left( \rho - z\left( t \right) \right)}{10} - y\left( t \right) \\
\frac{dz(t)}{dt} =& x\left( t \right) \left( y\left( t \right) \right)^{\frac{2}{3}} - \beta z\left( t \right)
\end{align}
"""
@parameters t p[1:3]
@variables u[1:3](t)
@derivatives D'~t

eqs = [D(u[1]) ~ p[3]*(u[2]-u[1]),
       0 ~ p[2]*p[3]*u[1]*(p[1]-u[1])/10-u[2],
       D(u[3]) ~ u[1]*u[2]^(2//3) - p[3]*u[3]]

@test latexify(eqs) ==
raw"\begin{align}
\frac{du_{1(t)}}{dt} =& p_{3} \left( \mathrm{u_2}\left( t \right) - \mathrm{u_1}\left( t \right) \right) \\
0 =& \frac{p_{2} p_{3} \mathrm{u_1}\left( t \right) \left( p_{1} - \mathrm{u_1}\left( t \right) \right)}{10} - \mathrm{u_2}\left( t \right) \\
\frac{du_{3(t)}}{dt} =& \mathrm{u_1}\left( t \right) \left( \mathrm{u_2}\left( t \right) \right)^{\frac{2}{3}} - p_{3} \mathrm{u_3}\left( t \right)
\end{align}
"

eqs = [D(u[1]) ~ p[3]*(u[2]-u[1]),
       D(u[2]) ~ p[2]*p[3]*u[1]*(p[1]-u[1])/10-u[2],
       D(u[3]) ~ u[1]*u[2]^(2//3) - p[3]*u[3]]

sys = ODESystem(eqs)

@test latexify(eqs) ==
raw"\begin{align}
\frac{du_{1(t)}}{dt} =& p_{3} \left( \mathrm{u_2}\left( t \right) - \mathrm{u_1}\left( t \right) \right) \\
\frac{du_{2(t)}}{dt} =& \frac{p_{2} p_{3} \mathrm{u_1}\left( t \right) \left( p_{1} - \mathrm{u_1}\left( t \right) \right)}{10} - \mathrm{u_2}\left( t \right) \\
\frac{du_{3(t)}}{dt} =& \mathrm{u_1}\left( t \right) \left( \mathrm{u_2}\left( t \right) \right)^{\frac{2}{3}} - p_{3} \mathrm{u_3}\left( t \right)
\end{align}
"
