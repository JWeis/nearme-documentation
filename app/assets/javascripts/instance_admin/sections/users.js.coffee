class @InstanceAdmin.UsersController extends @JavascriptModule
  @include SearchableAdminResource

  constructor: (@container) ->
    @commonBindEvents()

