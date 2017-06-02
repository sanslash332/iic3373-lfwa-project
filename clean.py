import os
import sys
import re

folder_path = "./faces_lfwa_3"

current_dir, _, cache, = next(os.walk(folder_path))
regex = re.compile("(\\d+)")
cache = [regex.split(element) for element in cache if not element.startswith('.') and element.endswith('.png')]
cache = [[folder_path + "/" + element[0]] + element[1:] for element in cache]

def tree(paths, limits=None, index=1):
  if limits is None:
    limits = tuple()
  if len(limits) < 1:
    limits = (None,)

  indexes = {}
  min_len = 9000
  cap = limits[0]
  for path in paths:
    min_len = min(len(path), min_len)
    number = int(path[index])
    try:
      indexes[number]
    except:
      indexes[number] = []
    indexes[number].append(path)
  if index+2 < min_len:
    for key, values, in indexes.items():
      indexes[key] = tree(values, limits[1:], index+2)
  else:
    for key, values, in indexes.items():
      used = 0
      if len(values) != 1:
        for ii in range(len(values)):
          if len(values[ii]) < len(values[used]):
            used = ii
        print("Duplicate indexes for files, using the marked one *")
        for ii, line, in enumerate(values):
          if ii == used:
            print("* " + ''.join(line))
          else:
            print("  " + ''.join(line))
        for ii, line, in enumerate(values):
          if ii != used:
            print("  Removing: " + ''.join(line))
            os.remove(''.join(line))
      value = ''.join(values[used])
      indexes[key] = value
  key_list = sorted(list(indexes.keys()))
  if cap is not None:
    key_list = key_list[:cap]
  return [indexes[key] for key in key_list]

result = tree(cache, None)
print("DONE")
