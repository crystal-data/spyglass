require "bottle"
require "./lib/sod"
require "./spyglass/**"

img = Spyglass::Image.open("./in_hough.png")
lines = img.detect_lines
pp lines
