module Spyglass
  class Image
    alias RGBColor = Tuple(Number, Number, Number)

    enum Channel
      Red
      Green
      Blue
    end

    getter image : LibSod::SodImg
    getter data : Bottle::Tensor(Float32)
    getter path : String

    def self.open(filename : String, channels = 0)
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

    def width
      @image.w
    end

    def height
      @image.h
    end

    def channel_count
      @image.c
    end

    def blob
      @image.data
    end

    def save(filename : String)
      ext = File.extname(filename)
      case ext
      when  ".png"
        LibSod.sod_img_save_as_png(@image, filename)
      when ".jpg"
        LibSod.sod_img_save_as_png(@image, filename)
      when ".bmp"
        LibSod.sod_img_save_as_png(@image, filename)
      else
        raise "Unsupported file extension '#{ext}'"
      end
    end

    # hinning of binary images by Hilditch's algorithm. Skeletonization is useful when
    # we are interested not in the size of the pattern but rather in the relative
    # position of the strokes in the pattern (Character Recognition, X, Y
    # Chromosome Recognition, etc.).
    #
    # The target image must be binary (i.e. images whose pixels have only two possible
    # intensity value mostly black or white). You can obtain a binary image via
    # `Image#canny_edge`, `Image#otsu_binarize`, `Image#binarize`, or
    # `Image#threshold`.
    def hilditch
      Image.new(LibSod.sod_hilditch_thin_image(@image))
    end

    # Extracts ridges and bifurcations from a fingerprint image. Minutiae extraction is
    # applied to skeletonized fingerprint image obtained from `Image#thin`.
    def minutiae
      pt = 0
      pep = 0
      pbp = 0
      Image.new(LibSod.sod_minutiae(@image, pointerof(pt), pointerof(pep), pointerof(pbp)))
    end

    # Perform canny edge detection on an input image. This works only on grayscale images.
    # If you want to convert the colorspace of your input picture to the gray color
    # model, call `Image#grayscale` or `Image#grayscale_3c` before or simply
    # load your image from disk using the method `Image.load_grayscale`.
    def canny_edge(reduce_noise : Bool = false)
      reduce_noise = reduce_noise ? 1 : 0
      img = LibSod.sod_canny_edge_image(@image, reduce_noise)
      Image.new(img)
    end

    # Apply sobel operator on an input image. The sobel operator is very similar to Prewitt
    # operator. It is also a derivate mask and is used for edge detection. This works
    # only on grayscale images. If you want to convert the colorspace of your
    # input picture to the gray color model, call Image#grayscale` or
    # `Image#grayscale_3c` before or simply load your image from
    # disk using the method `Image.load_grayscale`.
    def sobel
      Image.new(LibSod.sod_sobel_image(@image))
    end

    # Perform hough line detection on an input image. The target image must be processed
    # via `Image#canny_edge` before this call. When done, you can draw the detected
    # lines via `Image#draw_line`.
    def hough_lines_detect(threshold : Number = 0)
      npts_ptr = Pointer(Int32).malloc
      alines = LibSod.sod_hough_lines_detect(@image, threshold.to_i, npts_ptr)

      npts = npts_ptr.value
      nlines = npts > 1 ? npts // 2 : 0

      pts_arr = Array(LibSod::SodPts).new(nlines) do |i|
        alines[i]
      end
      LibSod.sod_hough_lines_release(alines)

      pts_arr
    end

    # Perform connected component labeling on an input binary image which is useful for finding
    # blobs (i.e. bloc of texts). The target image must be binary (i.e. images whose pixels
    # have only two possible intensity value mostly black or white). You can obtain a
    # binary image via `Image#canny_edge`, `Image#otsu_binarize`, `Image#binarize`
    # or `Image#threshold`. When done, you can draw the blob regions via
    # `Image#draw_box`.
    def find_blobs(filter : Proc(Int32, Int32, Int32)? = nil)
      pabox = Pointer(Pointer(LibSod::SodBox)).malloc
      pnbox = Pointer(Int32).malloc

      LibSod.sod_image_find_blobs(@image, pabox, pnbox, filter)

      blobs = Array(LibSod::SodBox).new(pnbox.value) do |i|
        pabox[0][i]
      end

      LibSod.sod_image_blob_boxes_release(pabox[0])

      blobs
    end

    # ditto
    def find_blobs(&block)
      find_blobs(block)
    end

    # Binarize an input image via Otsu's method. Other thresholding & edge detection methods
    # includes `Image#canny_edge`, `Image#threshold`, `Image#sobel`, etc.
    def otsu
      Image.new(LibSod.sod_otsu_binarize_image(@image))
    end

    # Binarize an input image via fixed thresholding. Other thresholding & edge detection methods
    # includes `Image#canny`, `Image#threshold`, `Image#sobel`, etc.
    def binarize(reverse : Int32 = 0)
      Image.new(LibSod.sod_binarize_image(@image, reverse))
    end

    # Binarize an input image via fixed thresholding. Other thresholding & edge detection methods
    # includes `Image#canny`, `Image#threshold`, `Image#sobel`, etc.
    def threshold(threshold : Number = 0.5)
      Image.new(LibSod.sod_threshold_image(@image, threshold.to_f))
    end

    # Apply [morphological dilation](https://homepages.inf.ed.ac.uk/rbf/HIPR2/dilate.htm) to a an
    # input **binary** image.
    def dilate(times : Int32)
      Image.new(LibSod.sod_dilate_image(@image, times))
    end

    # Apply [morphological erosion](https://homepages.inf.ed.ac.uk/rbf/HIPR2/erode.htm) to an
    # input **binary** image.
    def erode(times : Int32)
      Image.new(LibSod.sod_erode_image(@image, times))
    end

    # Convert a given image to gray color model. A grayscale (or graylevel) image is simply one
    # in which the only colors are shades of gray. Grayscale images are very common & entirely
    # sufficient for many tasks such as face detection and so there is no need to use more
    # complicated and harder-to-process color images.
    def grayscale
      Image.new(LibSod.sod_grayscale_image(@image))
    end

    # Convert a given image colorspace to the gray color model. A grayscale (or graylevel) image
    # is simply one in which the only colors are shades of gray. Grayscale images are very
    # common & entirely sufficient for many tasks such as face detection and so there is
    # no need to use more complicated and harder-to-process color images.
    def grayscale_3c
      Image.new(LibSod.sod_grayscale_image_3c(@image))
    end

    # Gaussian Noise Reduce. That is, apply 5x5 Gaussian convolution filter, shrinks the image
    # by 4 pixels in each direction, using Gaussian filter. This works only on grayscale
    # images. If you want to convert the colorspace of your input picture to the gray
    # color model, call `Image#grayscale` or `Image#grayscale_3c` before.
    def gaussian_filter
      Image.new(LibSod.sod_gaussian_noise_reduce(@image))
    end

    # Equalize the image histogram. This works only on grayscale images. If you want to convert
    # the colorspace of your input picture to the gray color model, call `Image#grayscale`
    # or `Image#grayscale_3c` before.
    def equalize
      Image.new(LibSod.sod_equalize_histogram(@image))
    end

    # Composite one image onto another at the specified offset.
    def composite(source : Image, dest : Image, xpos : Number, ypos : Number)
      source = LibSod.sod_copy_image(source.image)
      dest = LibSod.sod_copy_image(dest.image)
      LibSod.sod_composite_image(source, dest, xpos.to_i, ypos.to_i)
      Image.new(dest)
    end

    # Creates a vertical mirror image by reflecting the pixels around the central X axis.
    def flip
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_flip_image(tmp)
      Image.new(tmp)
    end

    # Compute the difference between two images and return the reconstructed image.
    def distance(other : Image)
      Image.new(LibSod.sod_image_distance(@image, other.image))
    end

    # Embed one image on top of another. For a standard image composite operation, you
    # should rely on `Image.composite` instead.
    def self.embed(source : Image, dest : Image, xpos : Number, ypos : Number)
      source = LibSod.sod_copy_image(source.image)
      dest = LibSod.sod_copy_image(dest.image)
      LibSod.sod_embed_image(source, dest, xpos.to_i, ypos.to_i)
      Image.new(dest)
    end

    # Spatial filtering of image data. That is, apply a sharpening filter by 8-neighbor
    # Laplacian subtraction.T his works only on grayscale images. If you want to convert
    # the colorspace of your input picture to the gray color model, call `Image#grayscale`
    # or `Image#grayscale_3c` before.
    def sharpen_filtering
      Image.new(LibSod.sod_sharpen_filtering_image(@image))
    end

    # Rotates & Crop an image to the specified number of degrees and dimension. For standard
    # image rotation & cropping, you should rely respectively on `Image#rotate`
    # and `Image#crop`.
    def rotate_crop(degrees : Number, scale : Number, width : Number, height : Number, offset_x : Number, offset_y : Number, aspect : Number)
      img = LibSod.sod_rotate_crop_image(@image, degrees.to_f, scale.to_f, width.to_i, height.to_i, offset_x.to_i, offset_y.to_i, aspect.to_f)
      Image.new(img)
    end

    # Draw a single box (i.e. rectangle) on an input image. As of this release, we recommend using
    # the other `Image#draw_box` instead. This function is very useful when working with the
    # CNN/Realnet interfaces for example to mark a detected object (i.e. car,
    # plane, person, etc.) coordinates. When done, you can save the output
    # on disk via `Image#save` for instance.
    def draw_box(x1 : Number, y1 : Number, x2 : Number, y2 : Number, rgb : RGBColor)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_box(tmp, x1.to_i32, y1.to_i32, x2.to_i32, y2.to_i32, rgb[0].to_f, rgb[1].to_f, rgb[2].to_f)
      Image.new(tmp)
    end

    # Draw a single box (i.e. rectangle) on an input grayscale image. See `Image#draw_box`.
    def draw_box_grayscale(x1 : Number, y1 : Number, x2 : Number, y2 : Number, g : Number)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_box_grayscale(tmp, x1.to_i32, y1.to_i32, x2.to_i32, y2.to_i32, g.to_f)
      Image.new(tmp)
    end

    # Draw a single box (i.e. rectangle) on an input image. This function is very useful when working
    # with the CNN/Realnet interfaces for example to mark a detected object (i.e. car, plane,
    # person, etc.) coordinates. When done, you can save the output on disk
    # `Image#save` for instance.
    def draw_box(box : LibSod::SodBox, rgb: RGBColor)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_box(tmp, box, rgb[0].to_f, rgb[1].to_f, rgb[2].to_f)
      Image.new(tmp)
    end

    # Draw a single box (i.e. rectangle) on an input image with a specified width. See `Image#draw_box`.
    def draw_box(box : LibSod::SodBox, width : Number, rgb : RGBColor)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_box_width(tmp, box, width.to_i, rgb[0].to_f, rgb[1].to_f, rgb[2].to_f)
      Image.new(tmp)
    end

    # Draw a single line on an input image.
    def draw_line(start : LibSod::SodPts, stop : LibSod::SodPts, rgb : RGBColor)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_line(tmp, start.to_i, stop.to_i, rgb[0].to_f, rgb[1].to_f, rgb[2].to_f)
      Image.new(tmp)
    end

    # Draw a single circle via the Midpoint Circle Algorithm on an input image. This function is very
    # useful when working with the CNN/Realnet interfaces for example to mark a region of
    # interest (i.e. face) coordinates.
    def draw_circle(x : Number, y : Number, radius : Number, rgb : RGBColor)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_circle(tmp, x.to_i, y.to_i, radius.to_i, rgb[0].to_f, rgb[1].to_f, rgb[2].to_f)
      Image.new(tmp)
    end

    # Draw a single circle with a certain thickness via the Midpoint Circle Algorithm. See `Image.draw_circle`.
    def draw_circle(x : Number, y : Number, radius : Number, width : Number, rgb : RGBColor)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_image_draw_circle(tmp, x.to_i, y.to_i, radius.to_i, width.to_i, rgb[0].to_f, rgb[1].to_f, rgb[2].to_f)
      Image.new(tmp)
    end

    # Scale an input image to the desired dimension.
    def resize(width : Number, height : Number)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_resize_image(tmp, width.to_i, height.to_i)
      Image.new(tmp)
    end

    # Scale an input image to the maximum available dimension (i.e. Pick the maximum value
    # from the image width or height). For standard image resizing, please rely on
    # `Image#resize` instead.
    def resize_max(max : Number)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_resize_max(tmp, max.to_i)
      Image.new(tmp)
    end

    # Scale an input image to the minimum available dimension (i.e. Pick the minimum value
    # from the image width or height). For standard image resizing, please rely on
    # `Image#resize` instead.
    def resize_min(min : Number)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_resize_min(tmp, min.to_i)
      Image.new(tmp)
    end

    # Extract a random region from an input image. For standard image cropping, you should
    # rely on `Image#crop` instead.
    def random_crop(width : Number, height : Number)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_random_crop_image(tmp, width.to_i, height.to_i)
      Image.new(tmp)
    end

    # Perform small perturbations in scale and position to an input image. For standard image
    # cropping, rotation & scaling you should rely respectively on `Image#crop`,
    # `Image#rotate` and `Image#scale`.
    def random_augment(angle : Number, aspect : Number, low : Number, high : Number, size : Number)
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_random_augment_image(tmp, angle.to_f, aspect.to_f, low.to_i, high.to_i, size.to_i)
      Image.new(tmp)
    end

    # Perform constant value addition on each pixel of a given image (Image Arithmetic). If you
    # want to process a single channel, then call `Image.translate_channel` instead.
    def translate(s : Float64)
      unless (0.0..1.0).includes?(s)
        raise "Translate value must be between 0 and 1"
      end

      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_translate_image(tmp, s)
      Image.new(tmp)
    end

    # Perform constant value multiplication on each pixel of a given image (Image Arithmetic). If you
    # want to process a single channel, then call `Image.scale_channel` instead.
    def scale(s : Float64)
      unless (0.0..1.0).includes?(s)
        raise "Scale value must be between 0 and 1"
      end

      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_scale_image(tmp, s.to_f)
      Image.new(tmp)
    end

    # Perform linear blending (i.e. image addition) on an input image.
    def self.blend(fore : Image, back : Image, alpha : Number)
      fore = LibSod.sod_copy_image(fore.image)
      back = LibSod.sod_copy_image(back.image)
      result = LibSod.sod_blend_image(fore, back, alpha.to_f)
      Image.new(result)
    end

    # Perform constant value multiplication on each pixel of a selected color channel unlike
    # `Image#scale` which process the entire image (i.e. all channels).
    def scale_channel(channel : Channel, s : Float64)
      unless (0.0..1.0).includes?(s)
        raise "Scale value must be between 0 and 1"
      end

      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_scale_image_channel(tmp, channel.value, s)
      Image.new(tmp)
    end

    # Perform constant value addition on each pixel of a selected color channel unlike
    # `Image#translate` which process the entire image (i.e. all channels).
    def translate_channel(channel : Channel, s : Float64)
      unless (0.0..1.0).includes?(s)
        raise "Translate value must be between 0 and 1"
      end

      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_translate_image_channel(tmp, channel.value, s)
      Image.new(tmp)
    end

    # Enhances the contrast of a color image by adjusting the pixels color to span the entire
    # range of colors available.
    def normalize
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_normalize_image(tmp)
      Image.new(tmp)
    end

    # Creates a vertical mirror image by reflecting the pixels around the central X axis while
    # rotating them 90-degrees.
    def transpose
      tmp = LibSod.sod_copy_image(@image)
      LibSod.sod_transpose_image(tmp)
      Image.new(tmp)
    end

    # Rotates an image the specified number of degrees (in radians).
    def rotate(degrees : Number)
      tmp = LibSod.sod_copy_image(@image)
      img = LibSod.sod_rotate_image(tmp, degrees.to_f)
      Image.new(img)
    end

    # Extract a region from a given image.
    def crop(width : Number, height : Number, offset_x : Number, offset_y : Number)
      tmp = LibSod.sod_copy_image(@image)
      img = LibSod.sod_crop_image(tmp, width.to_i, height.to_i, offset_x.to_i, offset_y.to_i)
      Image.new(img)
    end
  end
end
