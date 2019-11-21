require "../libs/sod"
require "bottle"

class Image
  @image : LibSod::SodImg
  @data : Bottle::Tensor(Float32)
  @path : String

  getter image

  def self.from_file(filename : String, channels = 0)
    img = LibSod.sod_img_load_from_file(filename, channels)
    shape = [img.h, img.w, img.c]
    strides = [0] * shape.size
    sz = 1

    shape.size.times do |i|
      strides[img.c - i - 1] = sz
      sz *= shape[img.c - i - 1]
    end

    flags = Bottle::Internal::ArrayFlags::Contiguous
    tns = Bottle::Tensor.new(img.data, shape, strides, flags, nil)

    new(img, tns, filename)
  end

  forward_missing_to(@data)

  private def initialize(@image, @data, @path)
  end

  def self.new(img)
    shape = [img.h, img.w, img.c]
    strides = [0] * shape.size
    sz = 1

    shape.size.times do |i|
      strides[img.c - i - 1] = sz
      sz *= shape[img.c - i - 1]
    end

    flags = Bottle::Internal::ArrayFlags::Contiguous
    tns = Bottle::Tensor.new(img.data, shape, strides, flags, nil)

    new(img, tns, "")
  end

  def save(filename : String)
    LibSod.sod_img_save_as_png(@image, filename)
  end

  def hilditch
    Image.new(LibSod.sod_hilditch_thin_image(@image))
  end

  def minutiae
    pt = 0
    pep = 0
    pbp = 0
    Image.new(LibSod.sod_minutiae(@image, pointerof(pt), pointerof(pep), pointerof(pbp)))
  end

  def sobel
    Image.new(LibSod.sod_sobel_image(@image))
  end

  def otsu
    Image.new(LibSod.sod_otsu_binarize_image(@image))
  end

  def binarize(reverse : Int32 = 0)
    Image.new(LibSod.sod_binarize_image(@image, reverse))
  end

  def threshold(threshold : Number = 0.5)
    Image.new(LibSod.sod_threshold_image(@image, Float32.new(threshold)))
  end

  def dilate(times : Int32)
    Image.new(LibSod.sod_dilate_image(@image, times))
  end

  def erode(times : Int32)
    Image.new(LibSod.sod_erode_image(@image, times))
  end

  def grayscale
    Image.new(LibSod.sod_grayscale_image(@image))
  end

  def gray_color_model
    Image.new(LibSod.sod_grayscale_image_3c(@image))
  end

  def gaussian_filter
    Image.new(LibSod.sod_gaussian_noise_reduce(@image))
  end

  def equalize
    Image.new(LibSod.sod_equalize_histogram(@image))
  end

  def flip
    tmp = LibSod.sod_copy_image(@image)
    LibSod.sod_flip_image(tmp)
    Image.new(tmp)
  end

  def distance(other : Image)
    Image.new(LibSod.sod_image_distance(@image, other.image))
  end

  def sharpen_filtering
    Image.new(LibSod.sod_sharpen_filtering_image(@image))
  end

  def rotate_crop(degrees : Number, scale : Number, width : Int32, height : Int32, offset_x : Number, offset_y : Number, aspect : Number)
    img = LibSod.sod_rotate_crop_image(@image, Float32.new(degrees), Float32.new(scale), Int32.new(width), Int32.new(height), Int32.new(offset_x), Int32.new(offset_y), Float32.new(aspect))
    Image.new(img)
  end

  def draw_box(x1 : Int32, y1 : Int32, x2 : Int32, y2 : Int32, r : Number, g : Number, b : Number)
    tmp = LibSod.sod_copy_image(@image)
    LibSod.sod_image_draw_box(tmp, x1, y1, x2, y2, Float32.new(r), Float32.new(g), Float32.new(b))
    Image.new(tmp)
  end
end
