# You can require javascript files here. A good place to start is by requiring your application.js.
# require application
#
# Teabag includes some support files, but you can use anything from your own support path too.
# require support/jasmine-jquery
# require support/sinon
# require support/your-support-file
#
# Deferring execution
# If you're using CommonJS, RequireJS or some other asynchronous library you can defer execution. Call Teabag.execute()
# after everything has been loaded. Simple example of a timeout:
#
# Teabag.defer = true
# setTimeout(Teabag.execute, 1000)
#
# Matching files
# By default Teabag will look for files that match _spec.{js,js.coffee,.coffee}. Add a filename_spec.js file in your
# spec path and it'll be included in the default suite automatically. If you want to customize suites, check out the
# configuration in config/initializers/teabag.rb
#
# Manifest
# If you'd rather require your spec files manually (to control order for instance) you can disable the suite matcher in
# the configuration and use this file as a manifest.
#
# For more information: http://github.com/modeset/teabag
#

## Load dependencies (filtering if there are file params), then execute.
#require Teabag.resolveDependenciesFromParams(["app_spec"]), Teabag.execute

#= require require.js
#= require config.js
#= require helpers/sinon
#= require helpers/jasmine-jquery
requirejs.config(baseUrl: "/assets/app")
Teabag.defer = true

# Load dependencies (filtering if there are file params), then execute.
require Teabag.resolveDependenciesFromParams([
  'models/location_spec',
  'models/listing_spec',
  'collections/location_spec',
  'collections/listing_spec',
  'views/locations/list_spec',
  'views/locations/item_spec',
  'views/listings/item_spec'

]) , Teabag.execute
#setTimeout(Teabag.execute,10000)
