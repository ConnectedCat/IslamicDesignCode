# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 12:08:05 2017

@author: Marija Bebic

Testing arc drawing
"""

#%% Preliminaries
import numpy as np
from numpy import cos, sin

import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import numpy as np

#%% Defining the circle
R = 2.
th1 = np.pi # 0
th2 = 3*np.pi/2. # 2*np.pi
# th = np.arange(th1, th2, np.pi/100)
th = np.linspace(th1, th2, 5)
x = 1.02*R*cos(th)
y = 1.02*R*sin(th)

fig, ax = plt.subplots(1, 1)
# Place the circle on the axes
ax.plot(x,y, alpha=1.0)

if True:
    #creates an  unfilled arc
    pac = mpatches.Arc([0, 0], 2*R, 2*R, angle=0, theta1=45, theta2=90, color='r')
    ax.add_patch(pac)
else:
    # creates a filled arc
    r=2. #can play around with r and yoff to move arc
    yoff=0
    x=np.arange(-1.,1.05,0.05)
    y=np.sqrt(r-x**2)+yoff
    ax.fill_between(x,y,0)

ax.axis([-2.2, 2.2, -2.2, 2.2])
ax.set_aspect("equal")
ax.grid()
# ax.set_axisbelow()

fig.canvas.draw()

#%%
#creates a circle of arcs
#col='rgbkmcyk'
#theta1=45
#theta2=135
#
#def filled_arc(center,r,theta1,theta2):
#
#    # Range of angles
#    phi=np.linspace(theta1,theta2,100)
#
#    # x values
#    x=center[0]+r*np.sin(np.radians(phi))
#
#    # y values. need to correct for negative values in range theta=90--270
#    yy = np.sqrt(r-x**2)
#    yy = [-yy[i] if phi[i] > 90 and phi[i] < 270 else yy[i] for i in range(len(yy))]
#
#    y = center[1] + np.array(yy)
#
#    # Equation of the chord
#    m=(y[-1]-y[0])/(x[-1]-x[0])
#    c=y[0]-m*x[0]
#    y2=m*x+c
#
#    # Plot the filled arc
#    ax.fill_between(x,y,y2,color=col[theta1/45])
#
## Lets plot a whole range of arcs
#for i in [0,45,90,135,180,225,270,315]:
#    filled_arc([0,0],1,i,i+45)
#
#ax.axis([-2, 2, -2, 2])
#ax.set_aspect("equal")
#fg.savefig('filled_arc.png')
#
