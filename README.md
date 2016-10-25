# jasmine-rails gem

[![Build Status](https://travis-ci.org/getaroom/jasmine-rails.svg?branch=refactor-test-suite)](http://travis-ci.org/getaroom/jasmine-rails)

Fork of @searls [jasmine-rails](https://github.com/searls/jasmine-rails)

This fork is intended to play nice with [requirejs](https://github.com/requirejs/requirejs), and includes @alex-seville's [blanket.js](https://github.com/alex-seville/blanket) for coverage reporting. It leverages [phantomjs](http://phantomjs.org/) headless browser, [capybara](https://github.com/jnicklas/capybara) to create a quick server when running from cli, and of course [jasmine-core](https://github.com/jasmine/jasmine)

By bundling this gem and configuring your project, you can expect to:

* Be able to run Jasmine specs in a browser (powered by Rails engine mounted into your application)
* Be able to run Jasmine specs from the command line (powered by
  [PhantomJS](http://phantomjs.org/))
* Write specs or source in [CoffeeScript](http://jashkenas.github.com/coffee-script/), leveraging the [asset pipeline](http://railscasts.com/episodes/279-understanding-the-asset-pipeline) to pre-process it

## Installation

First, add jasmine-rails to your Gemfile, like so

    group :test, :development do
      gem 'jasmine-rails', git: 'https://github.com/getaroom/jasmine-rails'
    end

Next:

```
$ bundle install
```

And finally, run the Rails generator:

```
$ rails generate jasmine_rails:install
```

The generator will create the necessary configuration files and mount a test
runner to [/specs](http://localhost:3000/specs) so that you can get started
writing specs!

## Configuration

Configuring the Jasmine test runner is done in `spec/javascripts/support/jasmine.yml`.

## Asset Pipeline Support

The jasmine-rails gem fully supports the Rails asset pipeline which means you can:

* use `coffee_script` or other Javascript precompilers for source or
  test files
* use sprockets directives to control inclusion/exclusion of dependent
  files
* leverage asset pipeline search paths to include assets from various
  sources/gems

**If you choose to use the asset pipeline support, many of the `jasmine.yml`
configurations become unnecessary** and you can rely on the Rails asset
pipeline to do the hard work of controlling what files are included in
your testsuite.

```yaml
# minimalist jasmine.yml configuration when leveraging asset pipeline
spec_files:
  - "**/*[Ss]pec.{js,coffee}"
```

You can write a spec to test Foo in `spec/javascripts/foo_spec.js`:

```javascript
// include spec/javascripts/helpers/some_helper_file.js and app/assets/javascripts/foo.js
//= require helpers/some_helper_file
//= require foo
describe('Foo', function() {
  it("does something", function() {
    expect(1 + 1).toBe(2);
  });
});
```
\*As noted above, spec_helper and foo.js must be required in order for foo_spec.js to run.

## Spec files in engine

If you have an engine mounted in your project and you need to test the engine's javascript files,
you can instruct jasmine to include and run the spec files from that engine directory.

Given your main project is located in `/workspace/my_project` and your engine in `/workspace/engine`,
you can add the following in the the `jasmine.yml` file:

```yaml
spec_dir:
  - spec/javascripts
  - ../engine/spec/javascripts
```

## Include javascript from external source

If you need to test javascript files that are not part of the assets pipeline (i.e if you have a mobile application
that resides outside of your rails app) you can add the following in the the `jasmine.yml` file:

```yaml
include_dir:
  - ../mobile_app/public/js
```

## Running from the command line

If you were to run:

    RAILS_ENV=test bundle exec rake spec:javascript

You'd hopefully see something like:

    Running Jasmine specs...

    PASS: 0 tests, 0 failures, 0.001 secs.

You can filter execution by passing the `SPEC` option as well:

    RAILS_ENV=test bundle exec rake spec:javascript SPEC=my_test

If you experience an error at this point, the most likely cause is JavaScript being loaded out of order, or otherwise conflicting with other existing JavaScript in your project. See "Debugging" below.

## Running from your browser

Startup your Rails server (ex: `bundle exec rails s`), and navigate to the path you have configured in your routes.rb file (ex: [http://localhost:3000/specs](http://localhost:3000/specs)).
The Jasmine spec runner should appear and start running your testsuite instantly.

## Debugging

Debuging can be a little tricky because of the way that blanketjs works, I recommend that you add the source file giving you trouble to the `exclude_filter` in `jasmine.yml` and then follow the standard debugging practices found in many articles.

```yml

exclude_filter: '["application(.*)?.js"]'
```

### In your browser 

[Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/)
[Firebug](http://getfirebug.com/)

### Command Line Interface

While rare with the way the command line interface is configured to run; Phantomjs connects to a `/specs` being served through a basic capybara server.  There is a possibility that the error could be some form of race condition between phantomjs, your source code and your test. In these cases I generally look to common js lint issues and breaking more complex tests into smaller pieces to find the solution.

### Ajax / XHRs

While I do not recommend AJAX or XHRs they will properly process and be handled.  This is a requirement to use require js, as all src files are loaded via require methods.

### Custom Helpers

If you need to write a custom spec runner template (for example, using requireJS to load components from your specs), you might benefit from
custom helper functions.  The controller will attempt to load `JasmineRails::SpecHelper` if it exists. An example:

```ruby
# in lib/jasmine_rails/spec_helper.rb
module JasmineRails
  module SpecHelper
    def custom_function
      "hello world"
    end
  end
end
```

Create a custom layout in app/views/layouts/jasmine_rails/spec_runner.html.erb and reference your helper:

```erb
<%= custom_function %>
```

### Require JS

To use require js add the following to your application
- make sure that you are using [requirejs-rails](https://github.com/jwhitley/requirejs-rails) or a fork
- create the following file and add the following
```ruby
# in lib/jasmine_rails/spec_helper.rb
module JasmineRails
  module SpecHelper
    # Gives us access to the require_js_include_tag helper
    include RequirejsHelper
  end
end
```

Remove any reference to `src_files` in `spec/javascripts/support/jasmine.yml`, to ensure files aren't loaded prematurely.

Then use require to load any test or src dependencies.

```javascript
// spec/javascripts/my-module.spec.js

define([
  'my/module'
], function (myModule) {
  describe('test my module', function() {
    it('Should...', function (){
      ...
    });
  });
});
```

### Custom Reporter

You can configure custom reporter files to use when running from the
command line in `jasmine.yml`:

```yml
reporters:
  cool-reporter:
    - "cool-reporter.js"
  awesome-reporter:
    - "awesome-part-1.js"
    - "awesome-part-2.js"
```

Then, specify which reporters to use when you run the rake task:

```
RAILS_ENV=test REPORTERS='cool-reporter,awesome-reporter' rake spec:javascripts
```

The console reporter shipped with jasmine-rails will be used by
default, and you can explicitly use it by the name `console`.

See [jasmine-junitreporter][j-junit] for an example with JUnit output.

[j-junit]: https://github.com/shepmaster/jasmine-junitreporter-gem

## PhantomJS binary

By default the [PhantomJS gem](https://github.com/colszowka/phantomjs-gem) will
be responsible for finding and using an appropriate version of PhantomJS. If
however, you wish to manage your own phantom executable you can set:

```yml
use_phantom_gem: false
```

This will then try and use the `phantom` executable on the current `PATH`.

