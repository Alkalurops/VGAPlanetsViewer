## A Viewer for the Echo Cluster of VGAPlanets

The Viewer loads the two files 
  - PLANET.NM
  - xyplan.dat
using AJAX from the same location it was itself loaded.

It uses a Canvas-element to draw the planets at their coordinates. A checkbox toggles the display of routes that can be reached in one turn. Scrolling with the scrollweel zooms into and out of the view. Typing a fragment of a planetname into the searchbox and hitting enter jumps to the planet.  