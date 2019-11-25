module Spyglass
  struct Box
    # The x-coordinate of the upper-left corner of the rectangle
    getter x : Int32

    # The y-coordinate of the upper-left corner of the rectangle
    getter y : Int32

    # Rectangle width
    getter width : Int32

    # Rectangle height
    getter height : Int32

    # Confidence threshold. A value between 0..1
    getter score : Float64

    # Detected object name. I.e. person, face, dog, car, plane, cat, bicycle, etc.
    getter name : String

    # External pointer used by some modules such as the face landmarks,
    # NSFW classifier, pose estimator, etc.
    getter user_data : Pointer(Void)

    def initialize(@x, @y, @width, @height, @score, @name, @user_data)
    end

    def self.from_sodbox(box : LibSod::SodBox)
      new(
        box.x.to_i,
        box.y.to_i,
        box.w.to_i,
        box.h.to_i,
        box.score.to_f,
        String.new(box.z_name),
        box.p_user_data
      )
    end

    def to_sodbox
      box = LibSod::SodBox.new
      box.x = @x
      box.y = @y
      box.w = @width
      box.h = @height
      box.score = @score
      box.z_name = @name.to_slice
      box.p_user_data = @user_data
      box
    end
  end
end
