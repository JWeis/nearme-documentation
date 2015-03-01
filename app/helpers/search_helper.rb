module SearchHelper
  # Special geolocation fields for the search form(s)
  def search_geofields
    %w(lat lng nx ny sx sy country state city suburb street postcode)
  end

  def search_availability_date(date)
    date ? date.strftime('%b %e') : ''
  end

  def search_availability_quantity
    params[:availability].present? && params[:availability][:quantity].to_i || 1
  end

  def search_amenities
    params[:amenities].present? && params[:amenities].map(&:to_i) || []
  end

  def search_price_min
    (params[:price].present? && params[:price][:min]) || 0
  end

  def search_price_max
    params[:price].present? && params[:price][:max] || PriceRange::MAX_SEARCHABLE_PRICE
  end

  def price_information(listing)
    if listing.schedule_booking?
      money_without_cents_and_with_symbol(listing.fixed_price)
    else
      if listing.action_hourly_booking? && !listing.hourly_price.to_f.zero?
        "From #{money_without_cents_and_with_symbol(listing.hourly_price)} / hour"
      elsif !listing.daily_price.to_f.zero?
        "From #{money_without_cents_and_with_symbol(listing.daily_price)} / day"
      elsif !listing.weekly_price.to_f.zero?
        "From #{money_without_cents_and_with_symbol(listing.weekly_price)} / week"
      elsif !listing.monthly_price.to_f.zero?
        "From #{money_without_cents_and_with_symbol(listing.monthly_price)} / month"
      end
    end
  end

  def individual_listing_price_information(listing, filter_pricing = [])
    if listing.schedule_booking?
      money_without_cents_and_with_symbol(listing.fixed_price)
    else
      listing_price = listing.lowest_price_with_type(filter_pricing)
      if listing_price
        periods = {:monthly => 'month', :weekly => 'week', :daily => 'day', :hourly => 'hour'}
        "From <span>#{money_without_cents_and_with_symbol(listing_price[0])}</span> / #{periods[listing_price[1]]}".html_safe
      end
    end
  end

  def meta_title_for_search(platform_context, search, transactable_type_name = '')
    location_types_names = search.lntypes.blank? ? [] : search.lntypes.pluck(:name)
    listing_types_names = search.lgtypes.blank? ? [] : search.lgtypes

    title = (location_types_names.empty? && listing_types_names.empty?) ? (transactable_type_name.try(:pluralize).presence || platform_context.bookable_noun.pluralize) : ''

    title += %Q{#{location_types_names.join(', ')} #{listing_types_names.join(', ')}}
    search_location = []
    search_location << search.city
    search_location << (search.is_united_states? ? search.state_short : search.state)
    search_location.reject!{|sl| sl.blank?}
    if not search_location.empty?
      title += %Q{ in #{search_location.join(', ')}}
    end

    if not search.is_united_states?
      title += search_location.empty? ? ' in ' : ', '
      title += search.country.to_s
    end

    title + (additional_meta_title.present? ? " | " + additional_meta_title : '')
  end

  def meta_description_for_search(platform_context, search)
    description = %Q{#{search.city}, #{search.is_united_states? ? search.state_short : search.state}}
    if not search.is_united_states?
      description << ", #{search.country}"
    end
    description
  end

  def display_search_result_subheader_for?(location)
    location.name != "#{location.company.name} @ #{location.street}"
  end

  def display_taxonomies(root_taxon, current_taxon=nil)
    return '' if root_taxon.children.empty?
    content_tag :ul, class: 'taxons-list' do
      root_taxon.children.map do |taxon|
        css_class = (current_taxon && current_taxon == taxon) ? 'current' : nil
        content_tag :li do
          link_to(taxon.name, buy_sell_taxon_path(taxon), class: css_class) +
            display_taxonomies(taxon, current_taxon)
        end
      end.join("\n").html_safe
    end
  end

end
