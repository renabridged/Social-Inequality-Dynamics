# Social-Inequality-Dynamics
Social inequality is a complex phenomenon resulting from interactions between individuals within a society. To investigate the influence of interac- tion range on inequality, we propose a simple model of random interactions implemented using the Netlogo platform.

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
