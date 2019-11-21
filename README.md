# spyglass

A simple wrapper around SOD - An Embedded Computer Vision & Machine Learning Library, that provides
access to powerful low-level image manipulation routines, as well as high level interaction with
images using N-Dimensional Tensors from Bottle.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     spyglass:
       github: crystal-data/spyglass
   ```

2. Run `shards install`

## Usage

```crystal
require "spyglass"
```

Currently, basic manipulations are supported:

Input Image:

<img src="./static/rider.png" width="200">

```crystal
img = Image.from_file("./static/rider.png", 1)
gray = img.grayscale
gray.save("./static/gray_rider.png")
```

<img src="./static/gray_rider" width="200">


## Contributing

1. Fork it (<https://github.com/your-github-user/spyglass/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Zimmerman](https://github.com/your-github-user) - creator and maintainer
