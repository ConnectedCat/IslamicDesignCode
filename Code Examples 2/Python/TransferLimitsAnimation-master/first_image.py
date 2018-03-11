# -*- coding: utf-8 -*-
"""
Spyder Editor

"""
# -*- noplot -*-

SaveMovie = False

import numpy as np
import matplotlib
matplotlib.use("AGG")
import matplotlib.pyplot as plt
if SaveMovie:
    import matplotlib.animation as manimation

print('Preparing data for sine function')
x = np.arange(-np.pi, np.pi, np.pi/100.)
y = np.sin(x)

print('Starting')
if SaveMovie:
    FFMpegWriter = manimation.writers['ffmpeg']
    metadata = dict(title='Movie Test', artist='Matplotlib',
                    comment='Movie support!')
    writer = FFMpegWriter(fps=15, metadata=metadata)

# fig = plt.figure()
fig, ax0 = plt.subplots()

# l, = plt.plot([], [], 'r-o')
ax0.plot(x,y, 'k')

ax0.set_xlim([-5,5])
ax0.set_ylim([-5,5])
#plt.xlim(-5, 5)
#plt.ylim(-5, 5)
#plt.grid(b=True)

x0, y0 = 0, 0
# l.set_data(x0, y0)
fig.show()

if SaveMovie:
    with writer.saving(fig, "writer_test.mp4", 100):
        for i in range(100):
            x0 += 0.3 * np.random.randn()
            y0 += 0.1 * np.random.randn()
            l.set_data(x0, y0)
            writer.grab_frame()
            print('Saving', i)

print('Exiting')
