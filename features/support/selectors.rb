module HtmlSelectorsHelpers

  def choose_selectize(key, value)
    first("#{key} .selectize-input input").set value
    page.should have_css('.selectize-dropdown-content')
    page.execute_script("$('.selectize-dropdown-content > div:contains(\"#{value}\")').click()")
  end

  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when "the page"
      "html > body"

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #  when /^the (notice|error|info) flash$/
      #    ".flash.#{$1}"

      # You can also return an array to use a different selector
      # type, like:
      #
      #  when /the header/
      #    [:xpath, "//header"]

      # This allows you to provide a quoted selector as the scope
      # for "within" steps as was previously the default for the
      # web steps:

    when "photos"
      "ul#photos li img"

    when "the first photo box"
      "ul#photos li:first-of-type"

    when /a google map/i
      "div.map-container"
    when /^"(.+)"$/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)