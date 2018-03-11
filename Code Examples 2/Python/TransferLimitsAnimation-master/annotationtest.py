# -*- coding: utf-8 -*-
"""
Created on Sun Jun 11 12:28:57 2017

@author: Marija Bebic
"""


import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
import numpy as np

#sample code for circle

# You can specify the xypoint and the xytext in different positions and
# coordinate systems, and optionally turn on a connecting line and mark
# the point with a marker.  Annotations work on polar axes too.
# In the example below, the xy point is in native coordinates (xycoords
# defaults to 'data').  For a polar axes, this is in (theta, radius) space.
# The text in the example is placed in the fractional figure coordinate system.
# Text keyword args like horizontal and vertical alignment are respected.
fig = plt.figure()
ax = fig.add_subplot(111, projection='polar')
r = np.arange(0, 1, 0.001)
theta = 2*2*np.pi*r
line, = ax.plot(theta, r)

ind = 800
thisr, thistheta = r[ind], theta[ind]
ax.plot([thistheta], [thisr], 'o')
ax.annotate('a polar annotation',
            xy=(thistheta, thisr),  # theta, radius
            xytext=(0.05, 0.05),    # fraction, fraction
            textcoords='figure fraction',
            arrowprops=dict(facecolor='black', shrink=0.05),
            horizontalalignment='left',
            verticalalignment='bottom')

