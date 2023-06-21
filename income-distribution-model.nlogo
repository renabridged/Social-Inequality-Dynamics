extensions [csv]
;; defining two globals variables
globals [gini-index-reserve lorenz-points]

;; definig the type of agents of the model
breed [my-agents my-agent]

;; each turtle has its own income
my-agents-own [income]

to setup
  clear-all
  create-my-agents num-agents [
    set color gray
    set shape "person"
    set income random ( 2 * initial-income - initial-income)
    setxy random-xcor random-ycor
  ]
  update-lorenz-and-gini
  reset-ticks
end

to go
  if ticks >= simulation-time [stop]
  interact-my-agents
  update-lorenz-and-gini
  plot-lorenz-curve
  tick
end

to interact-my-agents
  ;; choose a random agent in the world
  ask one-of my-agents [
    let income-of-my-agent income
    ;; get all the chosen agent's (pachs, turtles, etc.) neighbors within a certain distance
    let neighbor my-agents in-radius interaction-radius
    ;; choose all neighbors other than me within a certain distance
    let random-neighbor one-of neighbor with [self != myself]
    let rdn-set (turtle-set random-neighbor)
    if any? rdn-set [
      ;; choose a neighbor other than me within a certain distance
      let rdn-choose one-of rdn-set
      ask rdn-choose [
        let income-of-rdn-choose income
        ;; test which income is lower
        if income-of-rdn-choose < income-of-my-agent [
          ;; define the amount to win and lose based on
          ;; the lowest income value and the chosen percentage
          let amount-to-gain percentage-of-income * income-of-rdn-choose
          let amount-to-lose percentage-of-income * income-of-rdn-choose
          ;; randomly choose a number from [0 1] to determine the winner and loser
          ifelse random 2 = 0 [
            ;; picking the winner
            set income income + amount-to-gain
            set color blue
            ;; picking the loser
            ask myself [
              set income income - amount-to-lose
              set color red
            ]
          ][
            ;; picking the loser
            set income income - amount-to-lose
            set color red
            ask myself [
              ;; picking the winner
              set income income + amount-to-gain
              set color blue
            ]
          ]
        ]
        ;; ;; test which income is lower
        if income-of-rdn-choose > income-of-my-agent [
          ;; define the amount to win and lose based on
          ;; the lowest income value and the chosen percentage
          let amount-to-gain percentage-of-income * income-of-my-agent
          let amount-to-lose percentage-of-income * income-of-my-agent
          ;; randomly choose a number from [0 1] to determine the winner and loser
          ifelse random 2 = 0 [
            ;; picking the winner
            set income income + amount-to-gain
            set color blue
            ask myself [
              ;; picking the loser
              set income income - amount-to-lose
              set color red
            ]
          ][
            ;; picking the loser
            set income income - amount-to-lose
            set color red
            ask myself [
              ;; picking the winner
              set income income + amount-to-gain
              set color blue
            ]
          ]
        ]
      ]
    ]
  ]
  ask my-agents [
    ;; show income of agents if income-my-agents? is True (on)
    ifelse income-my-agents?
    [set label int income]
    [set label ""]
    ;; move and rotate the agents if income-my-agents? is True (on)
    ifelse move-my-agents?
    [fd 1 rt 360]
    []

    if income < 1 [set income 0 set color orange ]
  ]
end

;; create the points for Lorenz Curve
to update-lorenz-and-gini
  let sorted-incomes sort [income] of my-agents
  let total-income sum sorted-incomes
  let income-sum-so-far 0
  let index 0
  set gini-index-reserve 0
  set lorenz-points []

  repeat num-agents [
    set income-sum-so-far (income-sum-so-far + item index sorted-incomes)
    set lorenz-points lput ((income-sum-so-far / total-income) * 100) lorenz-points
    set index (index + 1)
    set gini-index-reserve
      gini-index-reserve +
      (index / num-agents) -
      (income-sum-so-far / total-income)
  ]
end

to step
  repeat 5000 [go]
end

;; a procedure for to plot the Lorenz Curve
to plot-lorenz-curve
  clear-plot
  foreach lorenz-points [[ptx] -> plot (ptx / 100) ]
end
@#$#@#$#@
GRAPHICS-WINDOW
399
65
738
405
-1
-1
10.030303030303031
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
436
417
503
450
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
630
419
693
452
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
761
46
1155
205
# Agents vs. Time
Time
# of agents
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"winners" 1.0 0 -13345367 true "" "plot count my-agents with [color = blue]"
"losers" 1.0 0 -2674135 true "" "plot count my-agents with [color = red]"
"non-participants" 1.0 0 -7500403 true "" "plot count my-agents with [color = gray]"
"with-zero-income" 1.0 0 -955883 true "" "plot count my-agents with [color = orange]"

MONITOR
43
218
147
263
winners
count my-agents with [color = blue]
17
1
11

MONITOR
43
163
147
208
losers
count my-agents with [color = red]
17
1
11

MONITOR
44
109
147
154
non-participants
count my-agents with [color = gray]
17
1
11

SLIDER
192
195
364
228
percentage-of-income
percentage-of-income
0
1
0.8
0.1
1
NIL
HORIZONTAL

PLOT
767
215
956
457
Income histogram
Income
Frequency
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 500.0 1 -16777216 true "" "set-plot-x-range int min [income] of my-agents int max [income] of my-agents\n\nhistogram [income] of my-agents\n"

SLIDER
191
290
363
323
num-agents
num-agents
100
1000
600.0
100
1
NIL
HORIZONTAL

SWITCH
204
50
385
83
income-my-agents?
income-my-agents?
1
1
-1000

SLIDER
192
101
363
134
simulation-time
simulation-time
500
50000
50000.0
500
1
NIL
HORIZONTAL

SLIDER
192
149
364
182
interaction-radius
interaction-radius
1
16
16.0
1
1
NIL
HORIZONTAL

SLIDER
192
243
364
276
initial-income
initial-income
100
1000
1000.0
100
1
NIL
HORIZONTAL

MONITOR
43
273
147
318
income-sum
int sum [income] of my-agents
17
1
11

MONITOR
183
345
324
390
with-zero-income (%)
precision ((count my-agents with [income = 0] / count my-agents) * 100) 2
17
1
11

MONITOR
28
344
169
389
most-richer-than-initial (%)
precision ((count my-agents with [income > 10 * initial-income] / count my-agents) * 100) 2
17
1
11

MONITOR
103
407
243
452
with-non-zero-salary (%)
precision ((count my-agents with [income != 0] / count my-agents) * 100) 2
17
1
11

SWITCH
17
50
186
83
move-my-agents?
move-my-agents?
1
1
-1000

BUTTON
531
418
601
451
step 
repeat 2000 [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
971
215
1151
456
Lorenz Curve
# Agents
Cumulative income (%)
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "set-plot-y-range 0 1\nset-plot-x-range 0 num-agents "

@#$#@#$#@
## WHAT IS IT?

This model simulates income distribution based on random distribution. The idea is to show that, over time, a very small fraction of agents becomes very rich, while a very large fraction becomes very poor. The idea is to see the income distribution, which is a power law distribution (there is no typical income or there are agents with all income values or "The rich get richer and poor get poorer") and the decrease in the approximation between the Lorenz curve and the line of perfect inequality (vertical axis).

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

All agents start in a random position in the environment, are colored gray and have income according to a uniform distribution in the interval 2 * INITIAL-INCOME - INITIAL-INCOME.

An interaction (STEP) of this model has the following rule: a non-interacting agent (gray color) and one of its neighbors (also non-interacting) are randomly selected at a distance initially defined by the INTERACTION-RADIUS slider; for the agent with the lowest income, the two agents bet a percentage (initially defined by the PERCENTAGE-OF-INCOME slider) of that value; the winner will be decided by random choice with equal probability for both. The winning agent updates his income with the value of his old income plus the bet percentage and changes his color to blue (winner). The losing agent (loser) updates his income with his old income minus the bet percentage and changes his color to red. At each interaction, we test whether there are agents with income less than 1. If there are agents with income less than 1, the agent's income is null and its color changes to orange (with-zero-income), but if not there are agents with income less than or equal to 1, nothing is done.


## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

Initially, the observer is asked to define the following variables:

SIMULATION-TIME (slider with value between 500 and 50000);
INTERACTION-RADIUS slider with value between 2 and 16); 
PERCENTAGE-OF-INCOME (slider with value between 0 and 1 and increment of 0.1);
INITIAL-INCOME (slider with value between 100 and 1000);
NUM-AGENTS (slider with value between 100 and 1000);

Enable or disable the following switches to see what happens:

MOVE-MY-AGENTS (moves the agent 1 step forward and rotates it 360 degrees);
INCOME-MY-AGENTS (shows the agent's income).

If the observer chooses to see what happens with each interaction, it is recommended to use the STEP button. (not recommended as the simulation takes a long time)

After choosing the initial conditions, press the go button.

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

In the article, the author proposes an income distribution model when agents do not move and can share their income randomly with all agents in the environment. The author shows that, at the end of the simulation, income distribution obeys a power law implying that the rich get richer and the poor get poorer. However, we don't know what happens when the interactions depend on the distance or the random movement of the agents.

This model attempts to answer the following questions:
 
* What happens to income distribution when interactions take place over short or long distance? 
* What happens to income distribution when agents move?

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

* Try adding a monitor to show the Gini index of the richest 1% and the 20%.

Hint: Pick a point on the Lorenz Curve. The x coordinate gives the number of agents and the y coordinate the cumulative percentage of shared income. Use the following formula the Gini index: 

G = f - u

when  u = (D-x)/D and f = H - y. D is the number of agents in the environment and H = 1 is the maximum shared cumulative income.

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

Note the use of lists in drawing the Lorenz Curve.

## RELATED MODELS

Wealth Distribution by WILENSKY (1999)

 * http://www.netlogoweb.org/launch#http://ccl.northwestern.edu/netlogo/models/models/Sample%20Models/Social%20Science/Economics/Wealth%20Distribution.nlogo .

## CREDITS AND REFERENCES

[1] WILENSKY, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
[2] https://subversion.american.edu/aisaac/notes/netlogoProgramming.html .
[3] CHAKRABORTI, Anirban. Distributions of money in model markets of economy. International Journal of Modern Physics C, v. 13, n. 10, p. 1315-1321, 2002. https://doi.org/10.1142/S0129183102003905 .

## COPYRIGHT AND LICENSE

This model was created as part of the project of the dicipline PCC535 - INTRODUCTION TO AGENT-BASED MODELS carried out in 2023.1 on Departamento de Ciência da Computação - DCC, Universidade fedral de Lavras - UFLA, Lavras, MG. The project gratefully acknowledges the support of the FAPEMIG grant number CEX APQ 00829/21.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Gini index vs. interaction radius experiment 1" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>step</go>
    <timeLimit steps="1"/>
    <metric>lorenz-points</metric>
    <enumeratedValueSet variable="move-my-agents?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-income">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulation-time">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-agents">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-my-agents?">
      <value value="false"/>
    </enumeratedValueSet>
    <steppedValueSet variable="interaction-radius" first="1" step="1" last="16"/>
    <enumeratedValueSet variable="initial-income">
      <value value="1000"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
