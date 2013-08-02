# Typescript-AMD

While there are some existing efforts to bring typescript to the asset
pipeline (and ruby), I didn't find them acceptable for the following
reasons:

 - existing solutions compile to commonJS modules, which are not
   terribly useful for the browser (requirejs is an AMD implementation)

 - Typescript compilation through tsc is crazy slow (2s for a single
   trivial file on my machine). This is because they are massively
   optimizing for interactive compilation

 - Typescript as a language has a bit of a wart -- the `/// <reference
   src='path' />` comments. The typescript team is exploring alternative
   syntaxes, but to get around the clunkyness, all reference files (`.d.ts`) in a
   configured directory (`app/assets/references` by default) will get
   included into every file. This is according to my opinion, which is
   that those comments should only ever be used for `declare`s and possibly
   `interface`s, nothing else.


## Installation

Because it uses an interactive compiler, node.js is required to be
installed and accessible on the `PATH`. It uses the `typescript.api`
node module, which provides the typescript compiler as a service.

Add this line to your application's Gemfile:

    gem 'typescript-amd-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install typescript-amd-rails

## Usage



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
