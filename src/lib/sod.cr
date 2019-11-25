@[Link(ldflags: "#{__DIR__}/../../ext/sod.o")]
lib LibSod
  enum SodCnnConfig
    SodCnnNetworkOutput      =  1
    SodCnnDetectionThreshold =  2
    SodCnnNms                =  3
    SodCnnDetectionClasses   =  4
    SodCnnRandSeed           =  5
    SodCnnHierThreshold      =  6
    SodCnnTemperature        =  7
    SodCnnLogCallback        =  8
    SodRnnCallback           =  9
    SodRnnTextLength         = 10
    SodRnnDataLength         = 11
    SodRnnSeed               = 12
  end

  enum SodRealnetModelConfig
    SodRealnetModelMinsize            = 1
    SodRealnetModelMaxsize            = 2
    SodRealnetModelScalefactor        = 3
    SodRealnetModelStridefactor       = 4
    SodRelanetModelDetectionThreshold = 5
    SodRealnetModelNms                = 6
    SodRealnetModelDiscardNullBoxes   = 7
    SodRealnetModelName               = 8
    SodRealnetModelAboutInfo          = 9
  end

  fun sod_binarize_image(im : SodImg, reverse : LibC::Int) : SodImg
  fun sod_blend_image(fore : SodImg, back : SodImg, alpha : LibC::Float) : SodImg
  fun sod_canny_edge_image(im : SodImg, reduce_noise : LibC::Int) : SodImg
  fun sod_cnn_config(p_net : SodCnn, conf : SodCnnConfig, ...) : LibC::Int
  fun sod_cnn_create(pp_out : SodCnn*, z_arch : LibC::Char*, z_model_path : LibC::Char*, pz_err : LibC::Char**) : LibC::Int
  fun sod_cnn_destroy(p_net : SodCnn)
  fun sod_cnn_get_network_size(p_net : SodCnn, p_width : LibC::Int*, p_height : LibC::Int*, p_channels : LibC::Int*) : LibC::Int
  fun sod_cnn_predict(p_net : SodCnn, p_input : LibC::Float*, pa_box : SodBox**, pn_box : LibC::Int*) : LibC::Int
  fun sod_cnn_prepare_image(p_net : SodCnn, in : SodImg) : LibC::Float*
  fun sod_composite_image(source : SodImg, dest : SodImg, dx : LibC::Int, dy : LibC::Int)
  fun sod_copy_image(m : SodImg) : SodImg
  fun sod_crop_image(im : SodImg, dx : LibC::Int, dy : LibC::Int, w : LibC::Int, h : LibC::Int) : SodImg
  fun sod_dilate_image(im : SodImg, times : LibC::Int) : SodImg
  fun sod_embed_image(source : SodImg, dest : SodImg, dx : LibC::Int, dy : LibC::Int)
  fun sod_equalize_histogram(im : SodImg) : SodImg
  fun sod_erode_image(im : SodImg, times : LibC::Int) : SodImg
  fun sod_flip_image(input : SodImg)
  fun sod_free_image(m : SodImg)
  fun sod_gaussian_noise_reduce(grayscale : SodImg) : SodImg
  fun sod_grayscale_image(im : SodImg) : SodImg
  fun sod_grayscale_image_3c(im : SodImg)
  fun sod_grow_image(p_img : SodImg*, w : LibC::Int, h : LibC::Int, c : LibC::Int) : LibC::Int
  fun sod_hilditch_thin_image(im : SodImg) : SodImg
  fun sod_hough_lines_detect(im : SodImg, threshold : LibC::Int, n_pts : LibC::Int*) : SodPts*
  fun sod_hough_lines_release(p_lines : SodPts*)
  fun sod_image_blob_boxes_release(p_box : SodBox*)
  fun sod_image_distance(a : SodImg, b : SodImg) : SodImg
  fun sod_image_draw_bbox(im : SodImg, bbox : SodBox, r : LibC::Float, g : LibC::Float, b : LibC::Float)
  fun sod_image_draw_bbox_width(im : SodImg, bbox : SodBox, width : LibC::Int, r : LibC::Float, g : LibC::Float, b : LibC::Float)
  fun sod_image_draw_box(im : SodImg, x1 : LibC::Int, y1 : LibC::Int, x2 : LibC::Int, y2 : LibC::Int, r : LibC::Float, g : LibC::Float, b : LibC::Float)
  fun sod_image_draw_box_grayscale(im : SodImg, x1 : LibC::Int, y1 : LibC::Int, x2 : LibC::Int, y2 : LibC::Int, g : LibC::Float)
  fun sod_image_draw_circle(im : SodImg, x0 : LibC::Int, y0 : LibC::Int, radius : LibC::Int, r : LibC::Float, g : LibC::Float, b : LibC::Float)
  fun sod_image_draw_circle_thickness(im : SodImg, x0 : LibC::Int, y0 : LibC::Int, radius : LibC::Int, width : LibC::Int, r : LibC::Float, g : LibC::Float, b : LibC::Float)
  fun sod_image_draw_line(im : SodImg, start : SodPts, _end : SodPts, r : LibC::Float, g : LibC::Float, b : LibC::Float)
  fun sod_image_find_blobs(im : SodImg, pa_box : SodBox**, pn_box : LibC::Int*, x_filter : (LibC::Int, LibC::Int -> LibC::Int)) : LibC::Int
  fun sod_image_free_blob(z_blob : UInt8*)
  fun sod_image_to_blob(im : SodImg) : UInt8*
  fun sod_img_add_pixel(m : SodImg, x : LibC::Int, y : LibC::Int, c : LibC::Int, val : LibC::Float)
  fun sod_img_bgr_to_rgb(im : SodImg)
  fun sod_img_blob_save_as_bmp(z_path : LibC::Char*, z_blob : UInt8*, width : LibC::Int, height : LibC::Int, n_channels : LibC::Int) : LibC::Int
  fun sod_img_blob_save_as_jpeg(z_path : LibC::Char*, z_blob : UInt8*, width : LibC::Int, height : LibC::Int, n_channels : LibC::Int, quality : LibC::Int) : LibC::Int
  fun sod_img_blob_save_as_png(z_path : LibC::Char*, z_blob : UInt8*, width : LibC::Int, height : LibC::Int, n_channels : LibC::Int) : LibC::Int
  fun sod_img_get_layer(m : SodImg, l : LibC::Int) : SodImg
  fun sod_img_get_pixel(m : SodImg, x : LibC::Int, y : LibC::Int, c : LibC::Int) : LibC::Float
  fun sod_img_hsv_to_rgb(im : SodImg)
  fun sod_img_load_from_file(z_file : LibC::Char*, n_channels : LibC::Int) : SodImg
  fun sod_img_load_from_mem(z_buf : UInt8*, buf_len : LibC::Int, n_channels : LibC::Int) : SodImg
  fun sod_img_rgb_to_bgr(im : SodImg)
  fun sod_img_rgb_to_hsv(im : SodImg)
  fun sod_img_rgb_to_yuv(im : SodImg)
  fun sod_img_save_as_jpeg(input : SodImg, z_path : LibC::Char*, quality : LibC::Int) : LibC::Int
  fun sod_img_save_as_png(input : SodImg, z_path : LibC::Char*) : LibC::Int
  fun sod_img_set_load_from_directory(z_path : LibC::Char*, ap_loaded : SodImg**, pn_loaded : LibC::Int*, max_entries : LibC::Int) : LibC::Int
  fun sod_img_set_pixel(m : SodImg, x : LibC::Int, y : LibC::Int, c : LibC::Int, val : LibC::Float)
  fun sod_img_set_release(a_loaded : SodImg*, n_entries : LibC::Int)
  fun sod_img_yuv_to_rgb(im : SodImg)
  fun sod_lib_copyright : LibC::Char*
  fun sod_make_empty_image(w : LibC::Int, h : LibC::Int, c : LibC::Int) : SodImg
  fun sod_make_image(w : LibC::Int, h : LibC::Int, c : LibC::Int) : SodImg
  fun sod_make_random_image(w : LibC::Int, h : LibC::Int, c : LibC::Int) : SodImg
  fun sod_minutiae(bin : SodImg, p_total : LibC::Int*, p_ep : LibC::Int*, p_bp : LibC::Int*) : SodImg
  fun sod_normalize_image(p : SodImg)
  fun sod_otsu_binarize_image(im : SodImg) : SodImg
  fun sod_random_augment_image(im : SodImg, angle : LibC::Float, aspect : LibC::Float, low : LibC::Int, high : LibC::Int, size : LibC::Int) : SodImg
  fun sod_random_crop_image(im : SodImg, w : LibC::Int, h : LibC::Int) : SodImg
  fun sod_realnet_create(pp_out : SodRealnet*) : LibC::Int
  fun sod_realnet_destroy(p_net : SodRealnet)
  fun sod_realnet_detect(p_net : SodRealnet, z_gray_img : UInt8*, width : LibC::Int, height : LibC::Int, ap_box : SodBox**, pn_box : LibC::Int*) : LibC::Int
  fun sod_realnet_load_model_from_disk(p_net : SodRealnet, z_path : LibC::Char*, p_out_handle : LibC::UInt*) : LibC::Int
  fun sod_realnet_load_model_from_mem(p_net : SodRealnet, p_model : Void*, n_bytes : LibC::UInt, p_out_handle : LibC::UInt*) : LibC::Int
  fun sod_realnet_model_config(p_net : SodRealnet, handle : LibC::UInt, conf : SodRealnetModelConfig, ...) : LibC::Int
  fun sod_resize_image(im : SodImg, w : LibC::Int, h : LibC::Int) : SodImg
  fun sod_resize_max(im : SodImg, max : LibC::Int) : SodImg
  fun sod_resize_min(im : SodImg, min : LibC::Int) : SodImg
  fun sod_rotate_crop_image(im : SodImg, rad : LibC::Float, s : LibC::Float, w : LibC::Int, h : LibC::Int, dx : LibC::Float, dy : LibC::Float, aspect : LibC::Float) : SodImg
  fun sod_rotate_image(im : SodImg, rad : LibC::Float) : SodImg
  fun sod_scale_image(m : SodImg, s : LibC::Float)
  fun sod_scale_image_channel(im : SodImg, c : LibC::Int, v : LibC::Float)
  fun sod_sharpen_filtering_image(im : SodImg) : SodImg
  fun sod_sobel_image(im : SodImg) : SodImg
  fun sod_threshold_image(im : SodImg, thresh : LibC::Float) : SodImg
  fun sod_translate_image(m : SodImg, s : LibC::Float)
  fun sod_translate_image_channel(im : SodImg, c : LibC::Int, v : LibC::Float)
  fun sod_transpose_image(im : SodImg)

  struct SodBox
    x : LibC::Int
    y : LibC::Int
    w : LibC::Int
    h : LibC::Int
    score : LibC::Float
    z_name : LibC::Char*
    p_user_data : Void*
  end

  struct SodImg
    h : LibC::Int
    w : LibC::Int
    c : LibC::Int
    data : LibC::Float*
  end

  struct SodPts
    x : LibC::Int
    y : LibC::Int
  end

  type SodCnn = Void*
  type SodRealnet = Void*
end
