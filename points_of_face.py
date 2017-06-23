import numpy as num
import matplotlib.pyplot as plots

face_index = 592 -1

detected = num.load("faces_markers.npy")
xy = detected[face_index]["xy"]

x = num.mean(xy[:,(0,2,)], axis=1)
y = num.mean(xy[:,(1,3,)], axis=1)

fig = plots.figure()
ax = fig.add_subplot(111)

ax.plot(x, -y)

for ii, xy in enumerate(zip(x, -y)):
  ax.annotate('{0}'.format(ii), xy=xy, textcoords='data')

ax.set_aspect('equal')

plots.show()
