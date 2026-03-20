# Library of models

## Pharmacokinetic models

### Compartmental models and parameters

Six parameters are common to one, two or three compartment models:

- $V$ or $V_{1}$, the volume of distribution in the central compartment
- $k$, the elimination rate constant
- $CL$, the clearance of elimination
- $V_{m}$, the maximum elimination rate for Michaelis-Menten elimination
- $K_{m}$, the Michaelis-Menten constant
- $k_{a}$, the absorption rate constant for oral administration

### One-compartment models

There are two parameterisations implemented in PFIM for one-compartment
models, $\left( V{\mspace{6mu}\text{and}\mspace{6mu}}k \right)$ or
$\left( V{\mspace{6mu}\text{and}\mspace{6mu}}CL \right)$. The equations
are given for the first parameterisation $(V,k)$. For extra-vascular
administration, $V$ and $CL$ are apparent volume and clearance. The
equations for the second parameterisation $(V,CL)$ are derived using
$k = \frac{CL}{V}$.

### Models with linear elimination

#### One-compartment models

##### Intravenous bolus

- single dose

$$\begin{array}{r}
{C(t) = \frac{D}{V}e^{-k{(t - t_{D})}}}
\end{array}$$

- multiple doses

$$\begin{aligned}
 & {C(t) = \sum\limits_{i = 1}^{n}\frac{D_{i}}{V}e^{-k{(t - t_{D_{i}})}}} \\
 & 
\end{aligned}$$

- Library of models

``` r
Linear1BolusSingleDose_kV
Linear1BolusSingleDose_ClV
```

- steady state

\$\$\begin {equation}
C(t)=\frac{D}{V}\frac{e^{-k(t-t_D)}}{1-e^{-k\tau}}\\ \end {equation}\$\$

``` r
Linear1BolusSteadyState_kVtau
Linear1BolusSteadyState_ClVtau
```

##### Infusion

- single dose

\$\$\begin{equation} C\left(t\right)= \begin{cases}
{\frac{D}{Tinf}\frac{1}{kV}\left(1-e^{-k\left(t-t\_{D}\right)}\right)} &
\text{if \$t-t\_{D}\leq Tinf\$,}\\\[0.5cm\]
{\frac{D}{Tinf}\frac{1}{kV}\left(1-e^{-kTinf}\right)e^{-k\left(t-t\_{D}-Tinf\right)}}
& \text{if not.}\\ \end{cases}\\ \end{equation}\$\$

- multiple doses

$$C(t) = \begin{cases}
\begin{aligned}
{\sum\limits_{i = 1}^{n - 1}\frac{D_{i}}{Tinf_{i}}\frac{1}{kV}} & {\left( 1 - e^{-kTinf_{i}} \right)e^{-k{(t - t_{D_{i}} - Tinf_{i})}}} \\
 & {+\frac{D_{n}}{Tinf_{n}}\frac{1}{kV}\left( 1 - e^{-k{(t - t_{D_{n}})}} \right)}
\end{aligned} & {{\text{if}\mspace{6mu}}{t - t_{D_{n}} \leq Tinf_{n}}\text{,}} \\
{{\sum\limits_{i = 1}^{n}\frac{D_{i}}{Tinf_{i}}\frac{1}{kV}}\left( 1 - e^{-kTinf_{i}} \right)e^{-k{(t - t_{D_{i}} - Tinf_{i})}}} & \text{if not.} \\
 & 
\end{cases}$$

``` r
Linear1InfusionSingleDose_kV
Linear1InfusionSingleDose_ClV
```

- steady state

$$\begin{aligned}
 & {C(t) = \begin{cases}
{{\frac{D}{Tinf}\frac{1}{kV}}\left\lbrack \left( 1 - e^{-k{(t - t_{D})}} \right) + e^{-k\tau}\frac{\left( 1 - e^{-kTinf} \right)e^{-k{(t - t_{D} - Tinf)}}}{1 - e^{-k\tau}} \right\rbrack} & {{\text{if}\mspace{6mu}}{\left( t - t_{D} \right) \leq Tinf}\text{,}} \\
{\frac{D}{Tinf}\frac{1}{kV}\frac{\left( 1 - e^{-kTinf} \right)e^{-k{(t - t_{D} - Tinf)}}}{1 - e^{-k\tau}}} & \text{if not.} \\
 & 
\end{cases}} \\
 & 
\end{aligned}$$

``` r
Linear1InfusionSteadyState_kVtau
Linear1InfusionSteadyState_ClVtau
```

##### First order absorption

- single dose

$$C(t) = \frac{D}{V}\frac{k_{a}}{k_{a} - k}\left( e^{-k{(t - t_{D})}} - e^{-k_{a}{(t - t_{D})}} \right)$$

- multiple doses

$$C(t) = \sum\limits_{i = 1}^{n}\frac{D_{i}}{V}\frac{k_{a}}{k_{a} - k}\left( e^{-k{(t - t_{D_{i}})}} - e^{-k_{a}{(t - t_{D_{i}})}} \right)$$

``` r
Linear1FirstOrderSingleDose_kakV
Linear1FirstOrderSingleDose_kaClV
```

- steady state

$$C(t) = \frac{D}{V}\frac{k_{a}}{k_{a} - k}\left( \frac{e^{-k{(t - t_{D})}}}{1 - e^{-k\tau}} - \frac{e^{-k_{a}{(t - t_{D})}}}{1 - e^{-k_{a}\tau}} \right)$$

``` r
Linear1FirstOrderSteadyState_kakVtau
Linear1FirstOrderSteadyState_kaClVtau
```

#### Two-compartment models

For two-compartment model equations, $C(t) = C_{1}(t)$ represent the
drug concentration in the first compartment and $C_{2}(t)$ represents
the drug concentration in the second compartment.

As well as the previously described PK parameters, the following PK
parameters are used for the two-compartment models:

- $V_{2}$, the volume of distribution of second compartment
- $k_{12}$, the distribution rate constant from compartment 1 to
  compartment 2
- $k_{21}$, the distribution rate constant from compartment 2 to
  compartment 1
- $Q$, the inter-compartmental clearance
- $\alpha$, the first rate constant
- $\beta$, the second rate constant
- $A$, the first macro-constant
- $B$, the second macro-constant

There are two parameterisations implemented in PFIM for two-compartment
models:
$\left( V{\text{,}\mspace{6mu}}k{\text{,}\mspace{6mu}}k_{12}{\mspace{6mu}\text{and}\mspace{6mu}}k_{21} \right)$,
or
$\left( CL{\text{,}\mspace{6mu}}V_{1}{\text{,}\mspace{6mu}}Q{\mspace{6mu}\text{and}\mspace{6mu}}V_{2} \right)$.
For extra-vascular administration, $V_{1}$ ($V$), $V_{2}$, $CL$, and $Q$
are apparent volumes and clearances.

The second parameterisation terms are derived using:

- $V_{1} = V$
- $CL = k \times V_{1}$
- $Q = k_{12} \times V_{1}$
- $V_{2} = \frac{k_{12}}{k_{21}} \times V_{1}$

For readability, the equations for two-compartment models with linear
elimination are given using the variables
$\alpha{\text{,}\mspace{6mu}}\beta{\text{,}\mspace{6mu}}A{\mspace{6mu}\text{and}\mspace{6mu}}B$
defined by the following expressions:

$$\alpha = \frac{k_{21}k}{\beta} = \frac{\frac{Q}{V_{2}}\frac{CL}{V_{1}}}{\beta}$$

$$\beta = \left\{ \begin{array}{l}
{\frac{1}{2}\left\lbrack k_{12} + k_{21} + k - \sqrt{\left( k_{12} + k_{21} + k \right)^{2} - 4k_{21}k} \right\rbrack} \\
{\frac{1}{2}\left\lbrack \frac{Q}{V_{1}} + \frac{Q}{V_{2}} + \frac{CL}{V_{1}} - \sqrt{\left( \frac{Q}{V_{1}} + \frac{Q}{V_{2}} + \frac{CL}{V_{1}} \right)^{2} - 4\frac{Q}{V_{2}}\frac{CL}{V_{1}}} \right\rbrack}
\end{array} \right.$$

The link between A and B, and the PK parameters of the first and second
parameterisations depends on the input and are given in each subsection.

##### Intravenous bolus

For intravenous bolus, the link between $A$ and $B$, and the parameters
($V$, $k$, $k_{12}$ and $k_{21}$), or ($CL$, $V_{1}$, $Q$ and $V_{2}$)
is defined as follows:

$$A = {\frac{1}{V}\frac{\alpha - k_{21}}{\alpha - \beta}} = {\frac{1}{V_{1}}\frac{\alpha - \frac{Q}{V_{2}}}{\alpha - \beta}}$$

$$B = {\frac{1}{V}\frac{\beta - k_{21}}{\beta - \alpha}} = {\frac{1}{V_{1}}\frac{\beta - \frac{Q}{V_{2}}}{\beta - \alpha}}$$

- single dose

$$C(t) = D\left( Ae^{-\alpha{(t - t_{D})}} + Be^{-\beta{(t - t_{D})}} \right)$$

- multiples doses

$$C(t) = \sum\limits_{i = 1}^{n}D_{i}\left( Ae^{-\alpha{(t - t_{D_{i}})}} + Be^{-\beta{(t - t_{D_{i}})}} \right)$$

``` r
Linear2BolusSingleDose_ClQV1V2
Linear2BolusSingleDose_kk12k21V
```

- steady state

$$C(t) = D\left( \frac{Ae^{-\alpha t}}{1 - e^{-\alpha\tau}} + \frac{Be^{-\beta t}}{1 - e^{-\beta\tau}} \right)$$

``` r
Linear2BolusSteadyState_ClQV1V2tau
Linear2BolusSteadyState_kk12k21Vtau
```

##### Infusion

For infusion, the link between $A$ and $B$, and the parameters ($V$,
$k$, $k_{12}$ and $k_{21}$), or ($CL$, $V_{1}$, $Q$ and $V_{2}$) is
defined as follows:

$$A = {\frac{1}{V}\frac{\alpha - k_{21}}{\alpha - \beta}} = {\frac{1}{V_{1}}\frac{\alpha - \frac{Q}{V_{2}}}{\alpha - \beta}}$$

$$B = {\frac{1}{V}\frac{\beta - k_{21}}{\beta - \alpha}} = {\frac{1}{V_{1}}\frac{\beta - \frac{Q}{V_{2}}}{\beta - \alpha}}$$

- single dose

$$C(t) = \begin{cases}
{\frac{D}{Tinf}\left\lbrack \begin{array}{r}
{\frac{A}{\alpha}\left( 1 - e^{-\alpha{(t - t_{D})}} \right)} \\
{+\frac{B}{\beta}\left( 1 - e^{-\beta{(t - t_{D})}} \right)}
\end{array} \right\rbrack} & {{\text{if}\mspace{6mu}}{t - t_{D} \leq Tinf}\text{,}} \\
{\frac{D}{Tinf}\left\lbrack \begin{array}{r}
{\frac{A}{\alpha}\left( 1 - e^{-\alpha Tinf} \right)e^{-\alpha{(t - t_{D} - Tinf)}}} \\
{+\frac{B}{\beta}\left( 1 - e^{-\beta Tinf} \right)e^{-\beta{(t - t_{D} - Tinf)}}}
\end{array} \right\rbrack} & \text{if not.} \\
 & 
\end{cases}$$

- multiple doses

$$C(t) = \begin{cases}
\begin{aligned}
\sum\limits_{i = 1}^{n - 1} & {\frac{D_{i}}{Tinf_{i}}\left\lbrack \begin{array}{r}
{\frac{A}{\alpha}\left( 1 - e^{-\alpha Tinf_{i}} \right)e^{-\alpha{(t - t_{D_{i}} - Tinf_{i})}}} \\
{+\frac{B}{\beta}\left( 1 - e^{-\beta Tinf_{i}} \right)e^{-\beta{(t - t_{D_{i}} - Tinf_{i})}}}
\end{array} \right\rbrack} \\
 & {+\frac{D}{Tinf_{n}}\left\lbrack \begin{array}{r}
{\frac{A}{\alpha}\left( 1 - e^{-\alpha{(t - t_{D_{n}})}} \right)} \\
{+\frac{B}{\beta}\left( 1 - e^{-\beta{(t - t_{D_{n}})}} \right)}
\end{array} \right\rbrack}
\end{aligned} & {{\text{if}\mspace{6mu}}{t - t_{D_{n}} \leq Tinf}\text{,}} \\
{{\sum\limits_{i = 1}^{n}\frac{D_{i}}{Tinf_{i}}}\left\lbrack \begin{array}{r}
{\frac{A}{\alpha}\left( 1 - e^{-\alpha Tinf_{i}} \right)e^{-\alpha{(t - t_{D_{i}} - Tinf_{i})}}} \\
{+\frac{B}{\beta}\left( 1 - e^{-\beta Tinf_{i}} \right)e^{-\beta{(t - t_{D_{i}} - Tinf_{i})}}}
\end{array} \right\rbrack} & \text{if not.}
\end{cases}$$

``` r
Linear2InfusionSingleDose_kk12k21V,
Linear2InfusionSingleDose_ClQV1V2,
```

- steady state

\$\$\$\$

``` r
Linear2InfusionSteadyState_kk12k21Vtau
Linear2InfusionSteadyState_ClQV1V2tau
```

##### First-order absorption

For first order absorption, the link between $A$ and $B$, and the
parameters ($k_{a}$, $V$, $k$, $k_{12}$ and $k_{21}$), or
$\left( k_{a}{\text{,}\mspace{6mu}}CL{\text{,}\mspace{6mu}}V_{1}{\text{,}\mspace{6mu}}Q{\mspace{6mu}\text{and}\mspace{6mu}}V_{2} \right)$
is defined as follows:

$$A = {\frac{k_{a}}{V}\frac{k_{21} - \alpha}{\left( k_{a} - \alpha \right)(\beta - \alpha)}} = {\frac{k_{a}}{V_{1}}\frac{\frac{Q}{V_{2}} - \alpha}{\left( k_{a} - \alpha \right)(\beta - \alpha)}}$$

$$B = {\frac{k_{a}}{V}\frac{k_{21} - \beta}{\left( k_{a} - \beta \right)(\alpha - \beta)}} = {\frac{k_{a}}{V_{1}}\frac{\frac{Q}{V_{2}} - \beta}{\left( k_{a} - \beta \right)(\alpha - \beta)}}$$

- single dose

$$C(t) = D\left( Ae^{-\alpha{(t - t_{D})}} + Be^{-\beta{(t - t_{D})}} - (A + B)e^{-k_{a}{(t - t_{D})}} \right)$$

- multiple doses

$$C(t) = \sum\limits_{i = 1}^{n}D_{i}\left( Ae^{-\alpha{(t - t_{D_{i}})}} + Be^{-\beta{(t - t_{D_{i}})}} - (A + B)e^{-k_{a}{(t - t_{D_{i}})}} \right)$$

``` r
Linear2FirstOrderSingleDose_kaClQV1V2
Linear2FirstOrderSingleDose_kakk12k21V
```

- steady state

$$C(t) = D\left( \frac{Ae^{-\alpha{(t - t_{D})}}}{1 - e^{-\alpha\tau}} + \frac{Be^{-\beta{(t - t_{D})}}}{1 - e^{-\beta\tau}} - \frac{(A + B)e^{-k_{a}{(t - t_{D})}}}{1 - e^{-k_{a}\tau}} \right)$$

``` r
Linear2FirstOrderSteadyState_kaClQV1V2tau
Linear2FirstOrderSteadyState_kakk12k21Vtau
```

### Models with Michaelis-Menten elimination

#### One-compartment models

##### Intravenous bolus

- single dose

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}\begin{cases}
{C(t)} & {= 0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D}}}} \\
{C\left( t_{D} \right)} & {= \frac{D}{V}} \\
 & 
\end{cases}} \\
 & {\frac{dC}{dt} = -\frac{V_{m} \times C}{K_{m} + C}} \\
 & 
\end{aligned}$$

``` r
MichaelisMenten1BolusSingleDose_VmKmV
```

##### Infusion

- single dose

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}C(t) = 0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D}}}} \\
 & {\frac{dC}{dt} = -\frac{V_{m} \times C}{K_{m} + C} + input} \\
 & {input(t) = \begin{cases}
{\frac{D}{Tinf}\frac{1}{V}} & {{\text{if}\mspace{6mu}}{0 \leq t - t_{D} \leq Tinf}} \\
0 & \text{if not.}
\end{cases}}
\end{aligned}$$

- multiple doses

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}C(t) = 0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D_{1}}}}} \\
 & {\frac{dC}{dt} = -\frac{V_{m} \times C}{K_{m} + C} + input} \\
 & {input(t) = \begin{cases}
{\frac{D_{i}}{Tinf_{i}}\frac{1}{V}} & {{\text{if}\mspace{6mu}}{0 \leq t - t_{D_{i}} \leq Tinf_{i}}\text{,}} \\
0 & \text{if not.}
\end{cases}}
\end{aligned}$$

``` r
??????
```

##### First order absorption

- single dose

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}C(t) = 0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D}}}} \\
 & {\frac{dC}{dt} = -\frac{V_{m} \times C}{K_{m} + C} + input} \\
 & {input(t) = \frac{D}{V}k_{a}e^{-k_{a}{(t - t_{D})}}}
\end{aligned}$$

- multiple doses

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}C(t) = 0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D_{1}}}}} \\
 & {\frac{dC}{dt} = -\frac{V_{m} \times C}{K_{m} + C} + input} \\
 & {input(t) = \sum\limits_{i = 1}^{n}\frac{D_{i}}{V}k_{a}e^{-k_{a}{(t - t_{D_{i}})}}}
\end{aligned}$$

``` r
MichaelisMenten1FirstOrderSingleDose_kaVmKmV,
MichaelisMenten2FirstOrderSingleDose_kaVmKmk12k21V1V2
```

#### Two-compartment models

##### Intravenous bolus

- single dose

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}\begin{cases}
{C_{1}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D}}}} \\
{C_{2}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t \leq t_{D}}}} \\
{C_{1}\left( t_{D} \right) =} & \frac{D}{V} \\
 & 
\end{cases}} \\
 & {\frac{dC_{1}}{dt} = -\frac{V_{m} \times C_{1}}{K_{m} + C_{1}} - k_{12}C_{1} + \frac{k_{21}V_{2}}{V}C_{2}} \\
 & {\frac{dC_{2}}{dt} = \frac{k_{12}V}{V_{2}}C_{1} - k_{21}C_{2}} \\
 & 
\end{aligned}$$

``` r
MichaelisMenten2BolusSingleDose_VmKmk12k21V1V2
```

##### Infusion

- single dose

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}\begin{cases}
{C_{1}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D}}}} \\
{C_{2}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t \leq t_{D}}}} \\
 & 
\end{cases}} \\
 & {\frac{dC_{1}}{dt} = -\frac{V_{m} \times C_{1}}{K_{m} + C_{1}} - k_{12}C_{1} + \frac{k_{21}V_{2}}{V}C_{2} + input} \\
 & {\frac{dC_{2}}{dt} = \frac{k_{12}V}{V_{2}}C_{1} - k_{21}C_{2}} \\
 & {input(t) = \begin{cases}
{\frac{D}{Tinf}\frac{1}{V}} & {{\text{if}\mspace{6mu}}{0 \leq t - t_{D} \leq Tinf}} \\
0 & \text{if not.}
\end{cases}}
\end{aligned}$$

- multiple doses

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}\begin{cases}
{C_{1}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D_{1}}}}} \\
{C_{2}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t \leq t_{D_{1}}}}} \\
 & 
\end{cases}} \\
 & {\frac{dC_{1}}{dt} = -\frac{V_{m} \times C_{1}}{K_{m} + C_{1}} - k_{12}C_{1} + \frac{k_{21}V_{2}}{V}C_{2} + input} \\
 & {\frac{dC_{2}}{dt} = \frac{k_{12}V}{V_{2}}C_{1} - k_{21}C_{2}} \\
 & {input(t) = \begin{cases}
{\frac{D_{i}}{Tinf_{i}}\frac{1}{V}} & {{\text{if}\mspace{6mu}}{0 \leq t - t_{D_{i}} \leq Tinf_{i}}\text{,}} \\
0 & \text{if not.}
\end{cases}}
\end{aligned}$$

``` r
MichaelisMenten2InfusionSingleDose_VmKmk12k21V1V2
```

##### First order absorption

- single dose

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}\begin{cases}
{C_{1}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D}}}} \\
{C_{2}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t \leq t_{D}}}} \\
 & 
\end{cases}} \\
 & {\frac{dC_{1}}{dt} = -\frac{V_{m} \times C_{1}}{K_{m} + C_{1}} - k_{12}C_{1} + \frac{k_{21}V_{2}}{V}C_{2} + input} \\
 & {\frac{dC_{2}}{dt} = \frac{k_{12}V}{V_{2}}C_{1} - k_{21}C_{2}} \\
 & {input(t) = \frac{D}{V}k_{a}e^{-k_{a}{(t - t_{D})}}}
\end{aligned}$$

- multiple doses

$$\begin{aligned}
{\text{Initial}\mspace{6mu}} & {{\text{conditions:}\mspace{6mu}}\begin{cases}
{C_{1}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t < t_{D_{1}}}}} \\
{C_{2}(t) =} & {0{{\mspace{6mu}\text{for}\mspace{6mu}}{t \leq t_{D_{1}}}}} \\
 & 
\end{cases}} \\
 & {\frac{dC_{1}}{dt} = -\frac{V_{m} \times C_{1}}{K_{m} + C_{1}} - k_{12}C_{1} + \frac{k_{21}V_{2}}{V}C_{2} + input} \\
 & {\frac{dC_{2}}{dt} = \frac{k_{12}V}{V_{2}}C_{1} - k_{21}C_{2}} \\
 & {input(t) = \sum\limits_{i = 1}^{n}\frac{D_{i}}{V}k_{a}e^{-k_{a}{(t - t_{D_{i}})}}}
\end{aligned}$$

``` r
MichaelisMenten2FirstOrderSingleDose_kaVmKmk12k21V1V2
MichaelisMenten2FirstOrderSingleDose_kaVmKmk12k21V1V2
```

## Pharmacodynamic models

### Immediate response models

For these response models, the effect $E(t)$ is expressed as:

$$E(t) = A(t) + S(t)$$

where $A(t)$ represents the model of drug action and $S(t)$ corresponds
to the baseline/disease model. $A(t)$ is a function of the concentration
$C(t)$ in the central compartment.

The drug action models are presented in section [Drug action
models](#drugactionmodels) for $C(t)$. The baseline/disease models are
presented in section [Baseline/disease models](#baselinediseasemodel).
Any combination of those two models is available in the PFIM library.

Parameters

- $A_{lin}$: constant associated to $C(t)$
- $A_{quad}$: constant associated to the square of $C(t)$
- $A_{log}$: constant associated to the logarithm of $C(t)$
- $E_{max}$: maximal agonistic response
- $I_{max}$: maximal antagonistic response  
- $C_{50}$: concentration to get half of the maximal response ( drug
  potency)
- $\gamma$: sigmoidicity factor
- $S_{0}$: baseline value of the studied effect
- $k_{prog}$: rate constant of disease progression

NB: $V_{m}$ is in concentration per time unit and $K_{m}$ is in
concentration unit.

#### Drug action models

- linear model $$A(t) = A_{lin}C(t)$$

``` r
ImmediateDrugLinear_S0Alin
```

- quadratic model $$A(t) = A_{lin}C(t) + A_{quad}C(t)^{2}$$

``` r
ImmediateDrugImaxQuadratic_S0AlinAquad
```

- logarithmic model $$A(t) = A_{log}log\left( C(t) \right)$$

``` r
ImmediateDrugImaxLogarithmic_S0Alog
```

- $E_{max}$ model $$A(t) = \frac{E_{max}C(t)}{C(t) + C_{50}}$$

``` r
ImmediateDrugEmax_S0EmaxC50
```

- sigmoïd $E_{max}$ model
  $$A(t) = \frac{E_{max}C(t)^{\gamma}}{C(t)^{\gamma} + C_{50}^{\gamma}}$$

``` r
ImmediateDrugSigmoidEmax_S0EmaxC50gamma
```

- $I_{max}$ model $$A(t) = 1 - \frac{I_{max}C(t)}{C(t) + C_{50}}$$

``` r
ImmediateDrugImax_S0ImaxC50
```

- sigmoïd $I_{max}$ model
  $$A(t) = 1 - \frac{I_{max}C(t)^{\gamma}}{C(t)^{\gamma} + C_{50}^{\gamma}}$$

``` r
ImmediateDrugImax_S0ImaxC50_gamma
```

- full $I_{max}$ model $$A(t) = -\frac{C(t)}{C(t) + C_{50}}$$

- sigmoïd full $I_{max}$ model
  $$A(t) = -\frac{C(t)^{\gamma}}{C(t)^{\gamma} + C_{50}^{\gamma}}$$

``` r
ImmediateDrugImax_S0ImaxC50_gamma
```

#### Baseline/disease models

- null baseline

$$S(t) = 0$$

``` r
ImmediateBaselineConstant_S0
```

- constant baseline with no disease progression

$$S(t) = S_{0}$$

``` r
ImmediateBaselineConstant_S0
```

- linear disease progression

$$S(t) = S_{0} + k_{prog}t$$

``` r
ImmediateBaselineLinear_S0kprog
```

- exponential disease increase

$$S(t) = S_{0}e^{-k_{prog}t}$$

``` r
ImmediateBaselineExponentialincrease_S0kprog
```

- exponential disease decrease

$$S(t) = S_{0}\left( 1 - e^{-k_{prog}t} \right)$$

``` r
ImmediateBaselineExponentialdecrease_S0kprog
```

### Turnover response models

In these models, the drug is not acting on the effect $E$ directly but
rather on $R_{in}$ or $k_{out}$.

Thus the system is described with differential equations, given
$\frac{dE}{dt}$ as a function of $R_{in}$, $k_{out}$ and $C(t)$ the drug
concentration at time t.

The initial condition is: while $C(t) = 0$,
$E(t) = \frac{R_{in}}{k_{out}}$.

Parameters

- $E_{max}$: maximal agonistic response
- $I_{max}$: maximal antagonistic response  
- $C_{50}$: concentration to get half of the maximal response (=drug
  potency)
- $\gamma$: sigmoidicity factor
- $R_{in}$: input (synthesis) rate
- $k_{out}$: output (elimination) rate constant

#### Models with impact on the input $\left( R_{in} \right)$

- $E_{max}$ model
  $$\frac{dE}{dt} = R_{in}\left( 1 + \frac{E_{max}C}{C + C_{50}} \right) - k_{out}E$$

``` r
TurnoverRinEmax_RinEmaxCC50koutE
```

- sigmoïd $E_{max}$ model
  $$\frac{dE}{dt} = R_{in}\left( 1 + \frac{E_{max}C^{\gamma}}{C^{\gamma} + C_{50}^{\gamma}} \right) - k_{out}E$$

``` r
TurnoverRinSigmoidEmax_RinEmaxCC50koutE
```

- $I_{max}$ model
  $$\frac{dE}{dt} = R_{in}\left( 1 - \frac{I_{max}C}{C + C_{50}} \right) - k_{out}E$$

``` r
TurnoverRinFullImax_RinCC50koutE
```

- sigmoïd $I_{max}$ model
  $$\frac{dE}{dt} = R_{in}\left( 1 - \frac{I_{max}C^{\gamma}}{C^{\gamma} + C_{50}^{\gamma}} \right) - k_{out}E$$

``` r
TurnoverRinImax_RinImaxCC50koutE
```

- full $I_{max}$ model
  $$\frac{dE}{dt} = R_{in}\left( 1 - \frac{C}{C + C_{50}} \right) - k_{out}E$$

``` r
TurnoverRinSigmoidImax_RinImaxCC50koutE
```

- sigmoïd full $I_{max}$ model
  $$\frac{dE}{dt} = R_{in}\left( 1 - \frac{C^{\gamma}}{C^{\gamma} + C_{50}^{\gamma}} \right) - k_{out}E$$

``` r
TurnoverRinFullImax_RinCC50koutE
```

#### Models with impact on the output $\left( k_{out} \right)$

- $E_{max}$ model
  $$\frac{dE}{dt} = R_{in} - k_{out}\left( 1 + \frac{E_{max}C}{C + C_{50}} \right)E$$

``` r
TurnoverkoutEmax_RinEmaxCC50koutE
```

- sigmoïd $E_{max}$ model
  $$\frac{dE}{dt} = R_{in} - k_{out}\left( 1 + \frac{E_{max}C^{\gamma}}{C^{\gamma} + C_{50}^{\gamma}} \right)E$$

``` r
TurnoverkoutSigmoidEmax_RinEmaxCC50koutEgamma
```

- $I_{max}$ model
  $$\frac{dE}{dt} = R_{in} - k_{out}\left( 1 - \frac{I_{max}C}{C + C_{50}} \right)E$$

``` r
TurnoverkoutImax_RinImaxCC50koutE
```

- sigmoïd $I_{max}$ model
  $$\frac{dE}{dt} = R_{in} - k_{out}\left( 1 - \frac{I_{max}C^{\gamma}}{C^{\gamma} + C_{50}^{\gamma}} \right)E$$

``` r
TurnoverkoutSigmoidImax_RinImaxCC50koutEgamma
```

- full $I_{max}$ model
  $$\frac{dE}{dt} = R_{in} - k_{out}\left( 1 - \frac{C}{C + C_{50}} \right)E$$

``` r
TurnoverkoutFullImax_RinCC50koutE
```

- sigmoïd full $I_{max}$ model
  $$\frac{dE}{dt} = R_{in} - k_{out}\left( 1 - \frac{C^{\gamma}}{C^{\gamma} + C_{50}^{\gamma}} \right)E$$

``` r
TurnoverkoutSigmoidFullImax_RinCC50koutE
```
