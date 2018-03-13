# -*- coding: utf-8 -*-
"""
Created on Sat Jun 10 12:55:51 2017

@author: Marija Bebic

v0.6 MJB 201706xx
Cleanup -- limit the number of parameters passed to the plotting functions
def OutputCirclePageC(pltPdf, R, AreaNames, MaxFlows, left_tally, right_tally)
the function will figure out:
    the circle from R, 
    the number of areas from len(AreaNames)
    whether the branches esxist based on MaxFlows
    position of left and right arc based on left/right talies

v0.5 MJB 20170611
Calculate left and right tallies for each area
left_tally[i] = sum of flows for points j seen to the left of the center looking from point i
right_tally[i] = sum of flows for points j seen to the right of the center looking from point i

v0.4 MJB 20170611
Place plotting code into a separate functions

v0.3 JZB 20170611
Added output to log file and conditional plotting into pdf file

v0.2 MJB 20170611
Calculated if points are to the left or right; 
Added arcs;
Calculated golden section control points to style the arcs

v0.1 MJB 20170611
Plotted circle and placed dots for areas;
The number of dots coorespond to the points in the matrix
"""

#%% Strings for the log file
codeName = 'base_frame.py'
codeVersion = '0.5'
codeCopyright = 'Copyright (C) Marija Bebic 2017'
dirout = 'Results/'
fnameLog = 'base_frame.log'

OutputPlots = True # set to False if you don't want the pdf file output

#%% Preliminaries
import numpy as np
from numpy import cos, sin

#import matplotlib.path as mpath
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
from matplotlib.path import Path

import matplotlib.backends.backend_pdf as dpdf
from datetime import datetime # time stamps
import os # operating system interface
import sys # enables exit on error

#%% Function definitions
def OutputCirclePage(pltPdf, x, y, x1, y1, x2, y2, AreaNames, MaxFlows):
    fig, (ax) = plt.subplots(nrows=1, ncols=1,
                             figsize=(6,6),
                             sharex=True)
    title = 'Transfer Limits'
    fig.suptitle(title) # This titles the figure
    
    ax.plot(x,y)
    # ax.scatter(x1,y1, c='lime')
    ax.scatter(x1,y1, c='#535353')
    #ax.scatter(x2,y2, c='red')
    ax.scatter(x3,y3, c='blue')
    ax.scatter(x4,y4, c='red')
    #ax.annotate('marija', xy=(0,0), xytext=(0,0), horizontalalignment='center', verticalalignment='center', rotation=30.0)
    #ax.annotate(['marija','jovan'], xy=((0,0),(0,1)), horizontalalignment='center', verticalalignment='center', rotation=[30.0, 60.0])
    for i in range(0, MaxFlows.shape[0]):
        ax.annotate(AreaNames[i], xy=(x1a[i], y1a[i]), 
                    horizontalalignment='center',
                    verticalalignment='center')
                    #rotation=th1[i]*180/np.pi)
    for i in range(0, MaxFlows.shape[0]):
        for j in range(i+1, MaxFlows.shape[1]):
            if not np.isnan(MaxFlows[i,j]):
                print('arc exists between: %d , %d' %(i,j))
                #midpoint (golden section) calculation
                print('x1 = %g, x2 = %g, y1 = %g, y2 = %g' %(x1[i], x1[j], y1[i], y1[j]))
                mdptx = (x1[i]+x1[j])/2
                mdpty = (y1[i]+y1[j])/2
                print('Midpoint between i and j is %g, %g' %(mdptx, mdpty))
                
                goldsectx = mdptx/2
                goldsecty = mdpty/2
                print('Golden section point equals: %g, %g' %(goldsectx, goldsecty))
                
                verts = [
                        (x1[i], y1[i]),
                        (goldsectx, goldsecty),
                        (goldsectx, goldsecty),
                        (x1[j], y1[j])]
        
                #Bezier Curve beginning
                
                codes = [Path.MOVETO,
                         Path.CURVE4,
                         Path.CURVE4,
                         Path.CURVE4,
                         ]
                
                path = Path(verts, codes)
                
                patch = mpatches.PathPatch(path, facecolor='none', lw=2)
                ax.add_patch(patch)
                
                ax.set_xlim(xlims)
                ax.set_ylim(ylims)
                ax.axis('equal')
                ax.grid()
    if OutputPlots:
        pltPdf.savefig() # Saves fig to pdf
        plt.close() # Closes fig to clean up memory
    else:
        plt.show()
    return
            
#%%this function uses lesser pull on control points

def OutputCirclePageB(pltPdf, x, y, x1, y1, x2, y2, AreaNames, MaxFlows):
    fig, (ax) = plt.subplots(nrows=1, ncols=1,
                             figsize=(6,6),
                             sharex=True)
    title = 'Transfer Limits'
    fig.suptitle(title) # This titles the figure
    
    ax.plot(x,y)
    # ax.scatter(x1,y1, c='lime')
    ax.scatter(x1,y1, c='#535353')
    #ax.scatter(x2,y2, c='red')
    ax.scatter(x3,y3, c='blue')
    ax.scatter(x4,y4, c='red')
    #ax.annotate('marija', xy=(0,0), xytext=(0,0), horizontalalignment='center', verticalalignment='center', rotation=30.0)
    #ax.annotate(['marija','jovan'], xy=((0,0),(0,1)), horizontalalignment='center', verticalalignment='center', rotation=[30.0, 60.0])
    for i in range(0, MaxFlows.shape[0]):
        ax.annotate(AreaNames[i], xy=(x1a[i], y1a[i]), 
                    horizontalalignment='center',
                    verticalalignment='center')
                    #rotation=th1[i]*180/np.pi)
    for i in range(0, MaxFlows.shape[0]):
        for j in range(i+1, MaxFlows.shape[1]):
            if not np.isnan(MaxFlows[i,j]):
                print('arc exists between: %d , %d' %(i,j))
                #midpoint (golden section) calculation
                print('x1 = %g, x2 = %g, y1 = %g, y2 = %g' %(x1[i], x1[j], y1[i], y1[j]))
                mdptx = (x1[i]+x1[j])/2
                mdpty = (y1[i]+y1[j])/2
                print('Midpoint between i and j is %g, %g' %(mdptx, mdpty))
                
                goldsectx = 2.*mdptx/3.
                goldsecty = 2.*mdpty/3.
                print('Golden section point equals: %g, %g' %(goldsectx, goldsecty))
                
                verts = [
                        (x1[i], y1[i]),
                        (goldsectx, goldsecty),
                        (goldsectx, goldsecty),
                        (x1[j], y1[j])]
        
                #Bezier Curve beginning
                
                codes = [Path.MOVETO,
                         Path.CURVE4,
                         Path.CURVE4,
                         Path.CURVE4,
                         ]
                
                path = Path(verts, codes)
                
                patch = mpatches.PathPatch(path, facecolor='none', lw=2)
                ax.add_patch(patch)
                
                ax.set_xlim(xlims)
                ax.set_ylim(ylims)
                ax.axis('equal')
                ax.grid()
    if OutputPlots:
        pltPdf.savefig() # Saves fig to pdf
        plt.close() # Closes fig to clean up memory
    else:
        plt.show()
    return

#%%function to draw the arcs between the gray and red points

def ArcsBetweenPoints(pltPdf, x, y, x1, y1, x2, y2, AreaNames, MaxFlows):
    fig, (ax) = plt.subplots(nrows=1, ncols=1,
                             figsize=(6,6),
                             sharex=True)
    title = 'Transfer Limits'
    fig.suptitle(title) # This titles the figure
    
    ax.plot(x,y) #places circle
    # ax.scatter(x1,y1, c='lime')
    ax.scatter(x1,y1, c='#535353') #places gray dots
    #ax.scatter(x2,y2, c='red') #places red dots
    ax.scatter(x3,y3, c='blue')
    ax.scatter(x4,y4, c='red')
    #ax.annotate('marija', xy=(0,0), xytext=(0,0), horizontalalignment='center', verticalalignment='center', rotation=30.0)
    #ax.annotate(['marija','jovan'], xy=((0,0),(0,1)), horizontalalignment='center', verticalalignment='center', rotation=[30.0, 60.0])
    for i in range(0, MaxFlows.shape[0]):
        ax.annotate(AreaNames[i], xy=(x1a[i], y1a[i]), 
                    horizontalalignment='center',
                    verticalalignment='center')
                    #rotation=th1[i]*180/np.pi)
    for i in range(0, MaxFlows.shape[0]):
        for j in range(i+1, MaxFlows.shape[1]):
            if not np.isnan(MaxFlows[i,j]):
                print('arc exists between: %d , %d' %(i,j))
                #midpoint (golden section) calculation
                print('x1 = %g, x2 = %g, y1 = %g, y2 = %g' %(x1[i], x1[j], y1[i], y1[j]))
                mdptx = (x1[i]+x1[j])/2
                mdpty = (y1[i]+y1[j])/2
                print('Midpoint between i and j is %g, %g' %(mdptx, mdpty))
                
                goldsectx = 2.*mdptx/3.
                goldsecty = 2.*mdpty/3.
                print('Golden section point equals: %g, %g' %(goldsectx, goldsecty))
                
                print('x2 and y2 values are : %g, %g' %(x2[i], y2[i]))
                
                #vector translation for arc angle
                #distPoint1 = np.sqrt([((x1[i]-0)*(x1[i]-0))+((y1[i]-0)*(y1[i]-0))])
                #distPoint2 = np.sqrt([((x2[i]-0)^2)+((y2[i]-0)^2)])
                
                #print('distance between points are: %g' %(distPoint1))
                
                verts = [
                        (x1[i], y1[i]),
                        (goldsectx, goldsecty),
                        (goldsectx, goldsecty),
                        (x1[j], y1[j])]
        
                #Bezier Curve beginning
                
                codes = [Path.MOVETO,
                         Path.CURVE4,
                         Path.CURVE4,
                         Path.CURVE4,
                         ]
                
                path = Path(verts, codes)
                
                patch = mpatches.PathPatch(path, facecolor='none', lw=2.)
                ax.add_patch(patch)
                
                ax.set_xlim(xlims)
                ax.set_ylim(ylims)
                ax.axis('equal')
                ax.grid()
    if OutputPlots:
        pltPdf.savefig() # Saves fig to pdf
        plt.close() # Closes fig to clean up memory
    else:
        plt.show()
    return
            

#%% Capture start time of code execution and open log file
codeTstart = datetime.now()
foutLog = open(os.path.join(dirout, fnameLog), 'w')

#%% Output log file header information
foutLog.write('This is %s %s\n' %(codeName, codeVersion))
foutLog.write('%s\n\n' %(codeCopyright))
foutLog.write('Run started on: %s\n\n' %(str(codeTstart)))

#%% Define colors, scaling, etc
atu = 0.9 # Angle to use as a relative value to 2*pi
R = 2 # radius for the perimeter of the chart
kr = 1.2
xlims = [-R*kr,R*kr]
ylims = [-R*kr,R*kr]
kl = 1.1

#%% Hard code samples of input data
# Flows between areas, defined as a matrix
#AreaNames= ['A', 'B', 'C']
#MaxFlows = np.array([[np.nan, 100.  , 200.],
#                     [100.  , np.nan, 400.],
#                     [200.  , 400.  , np.nan]])
                    
#AreaNames= ['A', 'B', 'C', 'D']
#MaxFlows = np.array([[np.nan, 100.  , 200.  , 400.],
#                     [100.  , np.nan, 200.  , np.nan],
#                     [200.  , 200.  , np.nan, 600.],
#                     [400.  , np.nan, 600.  , np.nan]])

AreaNames= ['A', 'B', 'C', 'D', 'E']
MaxFlows = np.array([[np.nan, 100. , 100. , np.nan, 100.],
                     [100. , np.nan, 200. , np.nan, 100.],
                     [100. , 200. , np.nan, 100. , np.nan],
                     [np.nan, np.nan, 100. , np.nan, 100.],
                     [100. , 100. , np.nan, 100. , np.nan]])

#%% Calculate angle scale for flows
# Take max angle from MaxFlows array and the number of flows and divide the 
# circle into segments that represent flows. 
flowScale = 2.*np.pi*atu/np.nansum(MaxFlows) # rad/MW
print ('flowScale: %.3f (rad/MW)' %(flowScale))
print ('flowScale: %g (rad/MW)' %(flowScale))
print ('flowScale: %.3f (rad/MW), %.3f (deg/MW)' %(flowScale, flowScale*180./np.pi))

#%% Calculate reference points for flow areas
nAr = MaxFlows.shape[0] # Number of areas in input data
aStep = np.pi*2/nAr 
th1 = np.arange(0, 2*np.pi, aStep)
x1 = R*cos(th1) #x coordinates for ref. angles of area
y1 = R*sin(th1) #y coordinates for ref. angles of area
x1a = kl*R*cos(th1)
y1a = kl*R*sin(th1)

#echo input data to log file
foutLog.write('The MaxFlows matrix has %d rows and %d columns\n' %(MaxFlows.shape[0], MaxFlows.shape[1]))
foutLog.write('There are %d area names: ' %(len(AreaNames)))
for a in AreaNames:
    foutLog.write('%s, ' %(a))
foutLog.write('\n\n')

# Error checking
if MaxFlows.shape[0] != MaxFlows.shape[1]:
    foutLog.write('MaxFlows matrix is not square, exiting...\n')
    sys.exit('MaxFlows matrix is not square, exiting')
if MaxFlows.shape[0] != len(AreaNames):
    foutLog.write('Number of area names does not match the dimension of MaxFlows matrix, exiting...\n')
    sys.exit('Number of area names does not match the dimension of MaxFlows matrix, exiting')

#%% Drawing the arcs
subDegs = np.linspace(10, 40, nAr)
subRads = subDegs*np.pi/180
#th2 = np.arange(0, 2*np.pi, np.pi*2/nAr)
x2 = R*cos(th1-subRads)
y2 = R*sin(th1-subRads)

#%% For loop determing if the vector from i to j passes to right/left relative to center, looking from i

# initialize flow tallies
left_tally = np.zeros((nAr))
right_tally = np.zeros((nAr))

for i in range(0, nAr):
    for j in range(0, nAr):
        #print('x[%d] = %g; y[%d] = %g' %(j, x1[j], j, y1[j]))
        if not np.isnan(MaxFlows[i,j]):
            print('Point i = %d, point j = %d' %(i, j))
            foutLog.write('Point i = %d, point j = %d\n' %(i, j))
            Pijx = x1[j] - x1[i]
            Pijy = y1[j] - y1[i]
            PiCx = 0 - x1[i]
            PiCy = 0 - y1[i]
            
            print('x[%d] = %g, y[%d] = %g, x to origin = %g, y to origin = %g' %(i, Pijx, j, Pijy, PiCx, PiCy))
            foutLog.write('x[%d] = %g, y[%d] = %g, x to origin = %g, y to origin = %g\n' %(i, Pijx, j, Pijy, PiCx, PiCy))
            
            kCom = (Pijx*PiCy) - (Pijy*PiCx)
            #print('k value in vector = %g' %(kCom))

            if kCom < 0:
                # print('K value points to the left')
                left_tally[i] = left_tally[i] + MaxFlows[i,j]
            else:
                #print('K value points to the right')
                right_tally[i] = right_tally[i] + MaxFlows[i,j]
    print('Point %d, Left tally total: %g; Right tally total: %g' %(i, left_tally[i], right_tally[i]))
    foutLog.write('Point %d, Left tally total: %g; Right tally total: %g\n' %(i, left_tally[i], right_tally[i]))

#if j = y , skip calculation
#%%Calculating the right/left tally arcs and theta array value
#left tally
k3 = 0.9
#x3 = k3*R*cos(th1-(left_tally*flowScale))
#y3 = k3*R*sin(th1-(left_tally*flowScale))

th3 = th1 - left_tally*flowScale
x3a = k3*R*cos(th3)
y3a = k3*R*sin(th3)

#right tally
k4 = 0.95
#x4 = k4*R*cos(th1+(right_tally*flowScale))
#y4 = k4*R*sin(th1+(right_tally*flowScale))

th4 = th1 + right_tally*flowScale
x4a = k3*R*cos(th4)
y4a = k3*R*sin(th4)

#%%defines a circle
th = np.arange(0, 2*np.pi, np.pi/100)
x = R*cos(th)
y = R*sin(th)

#%%drawing arcs
def arcDrawing(pltPdf, x, y, x1, y1, x2, y2, AreaNames, MaxFlows):
    fig, (ax) = plt.subplots(nrows=1, ncols=1,
                             figsize=(6,6),
                             sharex=True)
    title = 'Transfer Limits'
    fig.suptitle(title) # This titles the figure
    
    # ax.plot(x,y)
    # ax.scatter(x1,y1, c='lime')
    ax.scatter(x1,y1, c='#535353')
    #ax.scatter(x2,y2, c='red')
    ax.scatter(x3a,y3a, c='blue')
    ax.scatter(x4a,y4a, c='red')
    #ax.annotate('marija', xy=(0,0), xytext=(0,0), horizontalalignment='center', verticalalignment='center', rotation=30.0)
    #ax.annotate(['marija','jovan'], xy=((0,0),(0,1)), horizontalalignment='center', verticalalignment='center', rotation=[30.0, 60.0])

                #arc drawing
    for a in np.arange(0, nAr):
        #right tally; going from th1 to th4 
        pac = mpatches.Arc([0, 0], 2.1*R, 2.1*R, angle=0, theta1=th1[a]*180/np.pi, theta2=th4[a]*180/np.pi, color='r')
        ax.add_patch(pac)
        
        #left tally; going from th3 to th1
        pac = mpatches.Arc([0, 0], 1.9*R, 1.9*R, angle=0, theta1=th3[a]*180/np.pi, theta2=th1[a]*180/np.pi, color='b')
        ax.add_patch(pac)
        
    ax.set_xlim(xlims)
    ax.set_ylim(ylims)
    ax.set_aspect("equal")
    ax.axis('equal')
    ax.grid()
    if OutputPlots:
        pltPdf.savefig() # Saves fig to pdf
        plt.close() # Closes fig to clean up memory
    else:
        plt.show()
    return
# fig, ax = plt.subplots(1, 1)
# Place the circle on the axes
#ax.plot(x,y, alpha=1.0)
    
# ax.axis([-2.2, 2.2, -2.2, 2.2])

# fig.canvas.draw()
#%% checking the right/left tallies

print('The right tally mark at point 0 is: %g' %(right_tally[0]))

def tallyDrawing(pltPdf, x, y, x1, y1, x2, y2, AreaNames, MaxFlows):
    fig, (ax) = plt.subplots(nrows=1, ncols=1,
                             figsize=(6,6),
                             sharex=True)
    title = 'Transfer Limits'
    fig.suptitle(title) # This titles the figure
    
    # ax.plot(x,y)
    # ax.scatter(x1,y1, c='lime')
    ax.scatter(x1,y1, c='#535353')
    #ax.scatter(x2,y2, c='red')
    ax.scatter(x3a,y3a, c='blue')
    ax.scatter(x4a,y4a, c='red')
    #ax.annotate('marija', xy=(0,0), xytext=(0,0), horizontalalignment='center', verticalalignment='center', rotation=30.0)
    #ax.annotate(['marija','jovan'], xy=((0,0),(0,1)), horizontalalignment='center', verticalalignment='center', rotation=[30.0, 60.0])

                #arc drawing
    for a in np.arange(0, nAr):
        #right tally; going from th1 to th4 
        pac = mpatches.Arc([0, 0], 2*R, 2*R, angle=0, theta1=th1[a]*180/np.pi, theta2=th4[a]*180/np.pi, color='r')
        ax.add_patch(pac)
        
        #left tally; going from th3 to th1
        pac = mpatches.Arc([0, 0], 1.9*R, 1.9*R, angle=0, theta1=th3[a]*180/np.pi, theta2=th1[a]*180/np.pi, color='b')
        ax.add_patch(pac)
        
#        #splitting up right tally(at least, the attempt to)
#        for b in np.arange(0, nAr):
#            for c in np.arange(b, nAr):
#                if right_tally[b]>right_tally[c]:
#                    pac = mpatches.Arc([0, 0], 1.9*R, 1.9*R, angle=0, theta1=th1[a]*180/np.pi, theta2=right_tally[b], color='green')
#                    ax.add_patch(pac)
#                    
#        #splitting up left tally(at least, the attempt to)
#        for d in np.arange(0, nAr):
#            for e in np.arange(b, nAr):
#                if left_tally[d]>left_tally[e]:
#                    pac = mpatches.Arc([0, 0], 1.9*R, 1.9*R, angle=0, theta1=left_tally[d], theta2=th1[a]*180/np.pi, color='yellow')
#                    ax.add_patch(pac)
#        
        #right tally
        pac = mpatches.Arc([0, 0], 2*R, 2*R, angle=0, theta1=th1[0], theta2=right_tally[2], color='green')
        ax.add_patch(pac)
        
        verts = [
                (x1[0], y1[0]),
                (0., 0.),
                (0., 0.),
                (x1[1], right_tally[1])]
        
                #Bezier Curve beginning
                
        codes = [Path.MOVETO,
                 Path.CURVE4,
                 Path.CURVE4,
                 Path.CURVE4,
                 ]
        
        path = Path(verts, codes)
        
        patch = mpatches.PathPatch(path, facecolor='none', lw=2., color='yellow')
        ax.add_patch(patch)
#        
#        #left tally
#        pac = mpatches.Arc([0, 0], 2*R, 2*R, angle=0, theta1=left_tally[a], theta2=x1[a], color='yellow')
#        ax.add_patch(pac)
        
    ax.set_xlim(xlims)
    ax.set_ylim(ylims)
    ax.set_aspect("equal")
    ax.axis('equal')
    ax.grid()
    if OutputPlots:
        pltPdf.savefig() # Saves fig to pdf
        plt.close() # Closes fig to clean up memory
    else:
        plt.show()
    return
                

#%% Preparing pdf file
if OutputPlots:
    foutLog.write('\nStarting to plot at: %s\n' %(str(datetime.now())))
    print('Opening plot files')     
    pltPdf1 = dpdf.PdfPages(os.path.join(dirout,'Plots1.pdf'))
    
#OutputCirclePage(pltPdf1, x, y, x1, y1, x2, y2, AreaNames, MaxFlows)
#OutputCirclePageB(pltPdf1, x, y, x1, y1, x2, y2, AreaNames, MaxFlows)
#ArcsBetweenPoints(pltPdf1, x, y, x1, y1, x2, y2, AreaNames, MaxFlows)
arcDrawing(pltPdf1, x, y, x1, y1, x2, y2, AreaNames, MaxFlows)
tallyDrawing(pltPdf1, x, y, x1, y1, x2, y2, AreaNames, MaxFlows)
    
#%% Closing plot files
if OutputPlots:
    print("Closing plot files")
    pltPdf1.close()

#%% time stamp and close log file
codeTfinish = datetime.now()
foutLog.write('\nRun finished at: %s\n' %(str(codeTfinish)))
codeTdelta = codeTfinish - codeTstart
foutLog.write('Run lasted: %s seconds\n' %(str(codeTdelta.seconds)))
foutLog.close()
