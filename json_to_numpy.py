import json
import re
import numpy as num

file_name = "exported.json"

with open(file_name, 'r') as content_file:
  content = content_file.read()
  as_py = json.loads(content)

regex = re.compile("(\\d+)")

data = num.empty((4174,), dtype={"names":('s', 'c', 'level', 'xy',), "formats":('f', 'i', 'i', '(68, 4)f')})


for ii, tup, in enumerate(as_py):
  index_data = regex.split(tup[0])

  data[ii]["s"] = tup[1]["s"]
  data[ii]["c"] = tup[1]["c"]
  xy_shape = num.shape(tup[1]["xy"])
  data[ii]["xy"][:xy_shape[0], :xy_shape[1]] = tup[1]["xy"]
  data[ii]["xy"][xy_shape[0]:, xy_shape[1]:] = -1
  data[ii]["level"] = tup[1]["level"]

  if xy_shape != (68, 4):
    print("Problem with: {0}".format(ii))

num.save("faces_markers.npy", data)
print("DONE")
