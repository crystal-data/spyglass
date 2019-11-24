module Spyglass
  struct Points
    # The x-coordinate, in logical units of the point offset.
    getter x : Int32

    # The y-coordinate, in logical units of the point offset.
    getter y : Int32

    def initialize(@x, @y)
    end

    def self.from_sodpts(pts : LibSod::SodPts)
      new(pts.x.to_i, pts.y.to_i)
    end

    def to_sodpts
      pts = LibSod::SodPts.new
      pts.x = @x
      pts.y = @y
      pts
    end
  end
end
