try:
  from sys import argv
  from LoadPageModule  import *

  if __name__ == '__main__':
    load(argv[1:])
except ImportError as e:
    pass
