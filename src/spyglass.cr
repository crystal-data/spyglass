require "./img/frame"

module Spyglass
  VERSION = "0.1.0"
end

img = Image.from_file("./static/rider.png", 1)
gray = img.grayscale
gray.save("./static/gray_rider.png")

img = Image.from_file("./static/stop.jpg", 1)
binary = img.otsu
binary.save("./static/binary_stop.png")
