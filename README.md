# Physics-Engine-and-Integration-Methods

These are codes for my Advanced Physics II (PH162) class project for the Fall semester.

Code in the ``physics_engine`` folder is a recreation of that explained in Ian Millington's ``Game Physics Engine Design`` textbook, written in Processing environment of Java language.
Only Part I: Particle Physics was recreated.
Other folders contain this engine applied to various situations: particle connected to an anchored spring with zero natural length, two particles connected via a spring with nonzero natural length, two particles and gravity acting between them, and a billiard situation as described in Gregory Galperin's paper, ``Playing pool with pi``.

In the four folders, three integration methods - explicit Euler, simpletic Euler, and Verlet - are used to predict the motions.
In addition, the theoretical solution is drawn among the particles in white.
The only exception is the ``pi_collision`` code, where Verlet integration is excluded, for the method of applying impulses in case of collisions could not be implicated there.

The ``rec`` codes in each folder except the ``physics_engine`` folder are applied from Tim Rodenbröker's blog:
https://timrodenbroeker.de/processing-tutorial-video-export/.

The R codes in the ``data`` folders are used for plotting graphs, and was heavily inspired by Winston Chang's boock, ``R Graphics Cookbook``.
