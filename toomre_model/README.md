# Toomre Model

In this project I simulated galaxy interactions using the Toomre Model. The project was undertaken in 3 parts. The first of which involved testing a simplified case of two particles in mutual orbit and then performing convergence testing on the system. A successful convergence test provided enough confidence in our approach to carry on with single and multi galaxy modelling.

# Part 1: Convergence Testing on 2-body System

A two-body system was simulated and tested with varying input level parameters to generate a thorough convergence testing suite.

## Methodology

The initial conditions of mass and separation distance between the two masses was arbitrarily chosen. From here, the initial velocities were calculated to ensure a circular orbit. To simplify the problem, the particles were assumed to sit at certain distances away from the origin on the x axis. These distances could be determined by assuming that the centre of mass of the system was at the origin.

A convergence test was performed for levels 6, 7, 8 and 9. The x component for the first mass was compared for the varying levels. Error level plots as well as scaled error level plots were generated with the appropriate scaling factor. The results of these tests are discussed below.

## File Descriptions

- two\_body.m: File containing the two\_body function that carries out the two-body simulation as per the derivation above.
- convergence\_testing.m: File containing the convergence tests performed on the two\_body function as well as the appropriate plot generating methods.
- m: Contains a function that calculates the velocities of particles when provided with their respective masses and distances. The equation used within this file is taken directly from what is listed in the Finite Difference Solution of the Gravitational N-Body Problem document.

## Results

The convergence test results for the described levels can be seen in **Figure 1** below. The plot describes the displacement in the x dimension for the first of the two masses in the two body system. The next plot ( **Figure 2** ) is achieved by truncating values such that all 4 levels have the same dimensions and a difference between pairs of them can be taken. Finally, to prove that the FDA converges on the order of , each plot is scaled such that a factor n decrease in can be directly accounted for by a decrease in error. As can be seen from **Figure 3** scaling the 7-8 plot by 4 and the 8-9 plot by 16 results in overlapping plots, confirming the convergent behaviour of the employed FDA.

**Figure 1.**

![alt-text-1](https://github.com/melmatt7/computational_physics/blob/master/toomre_model/results/convergence_testing/displacement.jpg "title-1") ![alt-text-2](https://github.com/melmatt7/computational_physics/blob/master/toomre_model/results/convergence_testing/displacement_zoom.jpg "title-2")

**Figure 2.**

![](RackMultipart20201123-4-13km8e5_html_25db40576d62131.jpg)

**Figure 3.**

![](RackMultipart20201123-4-13km8e5_html_a92930351ffb2c14.jpg)

# Part 2: Achieving Stable Orbit for a Single Galaxy System

In this part, a stable orbit of a significant number of massless stars about a galaxy core was desired.

## Methodology

From the previous section, a level of 8 was deemed to be sufficiently accurate for the purposes of this project. A file toomre\_single.m was written to simulate a single core with a parameterized number of massless stars orbiting at a parameterized maximum and minimum distance. It was observed that if the minimum distance was too small for a given core mass, that a stable orbit could not be achieved. A rather important development in this stage involved abstracting the positions of the objects in the simulation to a 4 dimensional position matrix that took into account the position of the core, the position of every cores respective stars, the x, y, and z dimensions of every position as well as the timestep.

## File Descriptions

- toomre\_single.m: File containing the simulation for 1 galaxy core and a parameterized number of stars.
- toomre\_test.m: Testing parameters to arrive at a stable orbit.

## Results

For the parameters defined in the toomre\_test.m file, a stable orbit was seen for minimum orbital radii grater than 0.6. The technical methodology for the simulation is equivalent to that discussed in part 1, generalized to 1 core and a given number of massless particles. The results folder included in this submission contains the generated .avi files from this section of the project.

# Part 3: Multi-Galaxy Collision Dynamics

In this part, the previous work is further generalized to include a variable number of cores.

## Methodology

The key technical development in this section is the inclusion of the nbodyaccn\_tot file which can calculate the acceleration interactions of each core on each star. The file calculates the affect of each core on the other cores and calculates each cores effect on all stars in the system. This could be carried out with the original nbodyaccn file but resulted in many more loops in the toomre\_multi file. The nbodyacc\_tot approach was found to be more maintainable and efficient. A method of verifying correctness at the early stage involved running the multi-galaxy Toomre file with a single galaxy and ensuring that it produced the same results as the single galaxy Toomre file.

## File Descriptions

- toomre\_multi.m: file containing the multi-galaxy simulation.
- nbodyaccn\_tot.m: file containing the calculations for the gravitational acceleration interactions across all bodies in the system for a given timestep.

## Results

Five interesting cases were observed for the varying parameters: explosion, major collision, minor collision, triple galaxy interactions, and orbiting galaxies. All five of these .avi files can be found in the results folder of the submission. Relevant snapshots can be seen in the figures below:

**Figure 4.** Snapshot from explosion.avi

![](RackMultipart20201123-4-13km8e5_html_35aeffb7d4eff3a6.png)

**Figure 5.** Snapshot from minor\_collision.avi

![](RackMultipart20201123-4-13km8e5_html_d953820f4d052170.png)

**Figure 6.** Snapshot from three\_galaxy.avi

![](RackMultipart20201123-4-13km8e5_html_485e9b5277c2ed26.png)
