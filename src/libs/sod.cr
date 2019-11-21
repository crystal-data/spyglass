@[Link(ldflags: "#{__DIR__}/../../ext/sod.o")]
lib LibSod

  alias Integer = LibC::Int
  alias Real = LibC::Float
  alias Double = LibC::Double
  alias Logical = LibC::Char
  alias Ftnlen = LibC::Int
  alias LFp = Pointer(Void)
  alias UInt = LibC::SizeT

  struct SodImg
    h : Integer
    w : Integer
    c : Integer
    data : Real*
  end

  struct SodBox
    x : Integer
    y : Integer
    w : Integer
    h : Integer
    score : Real
    z_name : Logical*
    p_user_data : LFp
  end

  struct SodPoints
    x : Integer
    y : Integer
  end

  fun sod_copy_image(input : SodImg) : SodImg
  fun sod_free_image(input : SodImg)
  fun sod_img_load_from_file(file : Logical*, n : Integer) : SodImg
  fun sod_img_set_load_from_directory(path : Logical*, loaded : SodImg*, loaded : Integer*, max_entries : Integer)
  fun sod_img_set_release(loaded : SodImg*, entries : Integer)
  fun sod_img_save_as_png(image : SodImg, file : Logical*)
  fun sod_img_save_as_jpeg(input : SodImg, path : Logical*, quality : Integer)
  fun sod_image_to_blob(input : SodImg) : Logical*
  fun sod_image_free_blob(blob : Logical*)
  fun sod_img_blob_save_as_png(path : Logical*, blob : Logical*, w : Integer, h : Integer, channels : Integer) : Integer
  fun sod_img_blob_save_as_jpeg(path : Logical*, blob : Logical*, w : Integer, h : Integer, channels : Integer, quality : Integer) : Integer
  fun sod_img_blob_save_as_bmp(path : Logical*, blob : Logical*, w : Integer, h : Integer, channels : Integer) : Integer
  fun sod_make_empty_image(w : Integer, h : Integer, c : Integer) : SodImg
  fun sod_make_image(w : Integer, h : Integer, c : Integer) : SodImg
  fun sod_make_random_image(w : Integer, h : Integer, c : Integer) : SodImg
  fun sod_hilditch_thin_image(input : SodImg) : SodImg
  fun sod_minutiae(input : SodImg, p_total : Integer*, pep : Integer*, pbp : Integer*) : SodImg

  fun sod_canny_edge_image(input : SodImg, reduce_noise : Integer) : SodImg

  fun sod_sobel_image(input : SodImg) : SodImg
  fun sod_hough_lines_detect(input : SodImg, threshold : Integer, npts : Integer*) : SodPoints
  fun sod_hough_lines_release(pts : SodPoints)
  fun sod_image_find_blobs(input : SodImg, pa_box : SodBox*, pn_box : Integer*, cb : Int32, Int32 -> Int32) : Integer
  fun sod_image_blob_boxes_release(sod_box : SodBox*)
  fun sod_otsu_binarize_image(input : SodImg) : SodImg
  fun sod_binarize_image(input : SodImg, reverse : Integer) : SodImg
  fun sod_threshold_image(input : SodImg, threshold : Real) : SodImg
  fun sod_dilate_image(input : SodImg, times : Integer) : SodImg
  fun sod_erode_image(input : SodImg, times : Integer) : SodImg
  fun sod_grayscale_image(input : SodImg) : SodImg
  fun sod_grayscale_image_3c(input : SodImg) : SodImg
  fun sod_gaussian_noise_reduce(input : SodImg) : SodImg
  fun sod_equalize_histogram(input : SodImg) : SodImg
  fun sod_composite_image(source : SodImg, dest : SodImg, dx : Integer, dy : Integer)
  fun sod_flip_image(input : SodImg) : SodImg
  fun sod_image_distance(a : SodImg, b : SodImg) : SodImg
  fun sod_embed_image(source : SodImg, dest : SodImg, dx : Integer, dy : Integer)
  fun sod_sharpen_filtering_image(input : SodImg) : SodImg
  fun sod_rotate_crop_image(input : SodImg, degrees : Real, scale : Real, w : Integer, h : Integer, dx : Integer, dy : Integer, ratio : Real) : SodImg
  fun sod_image_draw_box(input : SodImg, x1 : Integer, y1 : Integer, x2 : Integer, y2 : Integer, r : Real, g : Real, b : Real)
  fun sod_image_draw_box_grayscale(input : SodImg, x1 : Integer, y1 : Integer, x2 : Integer, y2 : Integer, g : Real)
  fun sod_image_draw_bbox(input : SodImg, bbox : SodBox, r : Real, g : Real, b : Real)
  fun sod_image_draw_bbox_width(input : SodImg, bbox : SodBox, width : Integer, r : Real, g : Real, b : Real)
  fun sod_image_draw_line(input : SodImg, start : SodPoints, last : SodPoints, r : Real, g : Real, b : Real)
  fun sod_image_draw_circle(input : SodImg, x0 : Integer, y0 : Integer, radius : Integer, r : Real, g : Real, b : Real)
  fun sod_image_draw_circle_thickness(input : SodImg, x0 : Integer, y0 : Integer, radius : Integer, width : Integer, r : Real, g : Real, b : Real)
  fun sod_resize_image(input : SodImg, w : Integer, h : Integer) : SodImg
  fun sod_resize_max(input : SodImg, max : Integer) : SodImg
  fun sod_resize_min(input : SodImg, min : Integer) : SodImg
  fun sod_random_crop_image(input : SodImg, w : Integer, h : Integer) : SodImg
  fun sod_random_augment_image(input : SodImg, degrees : Real, aspect : Real, low : Integer, high : Integer, size : Integer) : SodImg
  fun sod_translate_image(input : SodImg, s : Real) : SodImg
  fun sod_scale_image(input : SodImg, s : Real) : SodImg
  fun sod_blend_image(fore : SodImg, back : SodImg, alpha : Real) : SodImg
  fun sod_scale_image_channel(input : SodImg, c : Integer, v : Real)
  fun sod_translate_image_channel(input : SodImg, c : Integer, v : Real)
  fun sod_normalize_image(input : SodImg)
  fun sod_transpose_image(input : SodImg)
  fun sod_rotate_image(input : SodImg, degrees : Real) : SodImg
  fun sod_crop_image(input : SodImg, dx : Integer, dy : Integer, w : Integer, h : Integer) : SodImg
end
