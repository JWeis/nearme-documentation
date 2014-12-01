module Utils
  class SpreeDefaultsLoader

    def initialize(instance)
      @instance = instance
    end

    def load!
      Instance.transaction do
        set_preferences
        load_countries
        load_roles
        load_states_for_us
        load_zones
        load_tax_categories_and_rates
        load_stock_location
        load_shipping_methods
        load_instance_serach_defaults
      end
    end

    private

    def set_preferences
      Spree::Config.site_name = @instance.theme.site_name || @instance.name
      Spree::Config.site_url = @instance.domains.first.name
      Spree::Config.default_meta_description = @instance.theme.description
      Spree::Config.default_meta_keywords = @instance.theme.tagline
      Spree::Config.default_seo_title = @instance.theme.meta_title
      Spree::Config.display_currency = true
      Spree::Config.allow_ssl_in_staging = false
      Spree::Config.currency = 'USD'
      Spree::Config.shipment_inc_vat = true
      Spree::Config.override_actionmailer_config = false
    end

    def load_instance_serach_defaults
      @instance.default_search_view = 'products'
      @instance.save
    end

    def load_roles
      Spree::Role.where(name: "admin").first_or_create
      Spree::Role.where(name: "user").first_or_create
    end

    def load_stock_location
      Spree::StockLocation.create!({
        name: 'default',
        country_id: Spree::Country.find_by_name('United States').id,
        active: true,
        backorderable_default: false,
        propagate_all_variants: true
      })
    end

    def load_zones
      eu_vat = Spree::Zone.create!(name: "EU_VAT", description: "Countries that make up the EU VAT zone.")
      north_america = Spree::Zone.create!(name: "North America", description: "USA + Canada", default_tax: true)

      ["Poland", "Finland", "Portugal", "Romania", "Germany", "France",
        "Slovakia", "Hungary", "Slovenia", "Ireland", "Austria", "Spain",
        "Italy", "Belgium", "Sweden", "Latvia", "Bulgaria", "United Kingdom",
        "Lithuania", "Cyprus", "Luxembourg", "Malta", "Denmark", "Netherlands",
        "Estonia"].
        each do |name|
        eu_vat.zone_members.create!(zoneable: Spree::Country.find_by!(name: name))
        end

      ["United States", "Canada"].each do |name|
        north_america.zone_members.create!(zoneable: Spree::Country.find_by!(name: name))
      end
    end

    def load_tax_categories_and_rates
      tax_category = Spree::TaxCategory.create!({
        name: 'default',
        description: 'default',
        is_default: true
      })

      Spree::Zone.all.each do |zone|
        calculator = Spree::Calculator::DefaultTax.create!
        Spree::TaxRate.create!({
          amount: 0,
          zone: zone,
          tax_category: tax_category,
          name: '0',
          calculator: calculator
        })
      end

      Spree::TaxRate.update_all(included_in_price: true)
    end

    def load_shipping_methods
      shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'default')

      calculator = Spree::Calculator::Shipping::FlatRate.create!
      shipping_method = {
        name: 'default',
        zones: Spree::Zone.all,
        calculator: calculator,
        shipping_categories: [shipping_category],
        display_on: 'both'
      }
      shipping_method = Spree::ShippingMethod.create!(shipping_method)
      shipping_method.calculator.preferred_amount = 0
      shipping_method.calculator.preferred_currency = 'USD'
      shipping_method.calculator.calculable_type = 'Spree::ShippingMethod'
      shipping_method.calculator.calculable_id = shipping_method.id
      shipping_method.save!
    end

    def load_states_for_us
      country = Spree::Country.find_by(name: 'United States')
      Spree::State.create!([
        { name: 'Michigan', abbr: 'MI', country: country },
        { name: 'South Dakota', abbr: 'SD', country: country },
        { name: 'Washington', abbr: 'WA', country: country },
        { name: 'Wisconsin', abbr: 'WI', country: country },
        { name: 'Arizona', abbr: 'AZ', country: country },
        { name: 'Illinois', abbr: 'IL', country: country },
        { name: 'New Hampshire', abbr: 'NH', country: country },
        { name: 'North Carolina', abbr: 'NC', country: country },
        { name: 'Kansas', abbr: 'KS', country: country },
        { name: 'Missouri', abbr: 'MO', country: country },
        { name: 'Arkansas', abbr: 'AR', country: country },
        { name: 'Nevada', abbr: 'NV', country: country },
        { name: 'District of Columbia', abbr: 'DC', country: country },
        { name: 'Idaho', abbr: 'ID', country: country },
        { name: 'Nebraska', abbr: 'NE', country: country },
        { name: 'Pennsylvania', abbr: 'PA', country: country },
        { name: 'Hawaii', abbr: 'HI', country: country },
        { name: 'Utah', abbr: 'UT', country: country },
        { name: 'Vermont', abbr: 'VT', country: country },
        { name: 'Delaware', abbr: 'DE', country: country },
        { name: 'Rhode Island', abbr: 'RI', country: country },
        { name: 'Oklahoma', abbr: 'OK', country: country },
        { name: 'Louisiana', abbr: 'LA', country: country },
        { name: 'Montana', abbr: 'MT', country: country },
        { name: 'Tennessee', abbr: 'TN', country: country },
        { name: 'Maryland', abbr: 'MD', country: country },
        { name: 'Florida', abbr: 'FL', country: country },
        { name: 'Virginia', abbr: 'VA', country: country },
        { name: 'Minnesota', abbr: 'MN', country: country },
        { name: 'New Jersey', abbr: 'NJ', country: country },
        { name: 'Ohio', abbr: 'OH', country: country },
        { name: 'California', abbr: 'CA', country: country },
        { name: 'North Dakota', abbr: 'ND', country: country },
        { name: 'Maine', abbr: 'ME', country: country },
        { name: 'Indiana', abbr: 'IN', country: country },
        { name: 'Texas', abbr: 'TX', country: country },
        { name: 'Oregon', abbr: 'OR', country: country },
        { name: 'Wyoming', abbr: 'WY', country: country },
        { name: 'Alabama', abbr: 'AL', country: country },
        { name: 'Iowa', abbr: 'IA', country: country },
        { name: 'Mississippi', abbr: 'MS', country: country },
        { name: 'Kentucky', abbr: 'KY', country: country },
        { name: 'New Mexico', abbr: 'NM', country: country },
        { name: 'Georgia', abbr: 'GA', country: country },
        { name: 'Colorado', abbr: 'CO', country: country },
        { name: 'Massachusetts', abbr: 'MA', country: country },
        { name: 'Connecticut', abbr: 'CT', country: country },
        { name: 'New York', abbr: 'NY', country: country },
        { name: 'South Carolina', abbr: 'SC', country: country },
        { name: 'Alaska', abbr: 'AK', country: country },
        { name: 'West Virginia', abbr: 'WV', country: country },
        { name: 'U.S. Armed Forces - Americas', abbr: 'AA', country: country },
        { name: 'U.S. Armed Forces - Europe', abbr: 'AE', country: country },
        { name: 'U.S. Armed Forces - Pacific', abbr: 'AP', country: country }
      ])
    end

    def load_countries
      Spree::Country.create!([
        { name: "Chad", iso3: "TCD", iso: "TD", iso_name: "CHAD", numcode: "148" },
        { name: "Faroe Islands", iso3: "FRO", iso: "FO", iso_name: "FAROE ISLANDS", numcode: "234" },
        { name: "India", iso3: "IND", iso: "IN", iso_name: "INDIA", numcode: "356", states_required: true },
        { name: "Nicaragua", iso3: "NIC", iso: "NI", iso_name: "NICARAGUA", numcode: "558" },
        { name: "Saint Lucia", iso3: "LCA", iso: "LC", iso_name: "SAINT LUCIA", numcode: "662" },
        { name: "Fiji", iso3: "FJI", iso: "FJ", iso_name: "FIJI", numcode: "242" },
        { name: "Indonesia", iso3: "IDN", iso: "ID", iso_name: "INDONESIA", numcode: "360" },
        { name: "Niger", iso3: "NER", iso: "NE", iso_name: "NIGER", numcode: "562" },
        { name: "Saint Pierre and Miquelon", iso3: "SPM", iso: "PM", iso_name: "SAINT PIERRE AND MIQUELON", numcode: "666" },
        { name: "Finland", iso3: "FIN", iso: "FI", iso_name: "FINLAND", numcode: "246" },
        { name: "Nigeria", iso3: "NGA", iso: "NG", iso_name: "NIGERIA", numcode: "566", states_required: true },
        { name: "Saint Vincent and the Grenadines", iso3: "VCT", iso: "VC", iso_name: "SAINT VINCENT AND THE GRENADINES", numcode: "670" },
        { name: "France", iso3: "FRA", iso: "FR", iso_name: "FRANCE", numcode: "250" },
        { name: "Iran, Islamic Republic of", iso3: "IRN", iso: "IR", iso_name: "IRAN, ISLAMIC REPUBLIC OF", numcode: "364" },
        { name: "Niue", iso3: "NIU", iso: "NU", iso_name: "NIUE", numcode: "570" },
        { name: "Samoa", iso3: "WSM", iso: "WS", iso_name: "SAMOA", numcode: "882" },
        { name: "French Guiana", iso3: "GUF", iso: "GF", iso_name: "FRENCH GUIANA", numcode: "254" },
        { name: "Iraq", iso3: "IRQ", iso: "IQ", iso_name: "IRAQ", numcode: "368", states_required: true },
        { name: "San Marino", iso3: "SMR", iso: "SM", iso_name: "SAN MARINO", numcode: "674" },
        { name: "Ireland", iso3: "IRL", iso: "IE", iso_name: "IRELAND", numcode: "372" },
        { name: "Sao Tome and Principe", iso3: "STP", iso: "ST", iso_name: "SAO TOME AND PRINCIPE", numcode: "678" },
        { name: "Israel", iso3: "ISR", iso: "IL", iso_name: "ISRAEL", numcode: "376" },
        { name: "Saudi Arabia", iso3: "SAU", iso: "SA", iso_name: "SAUDI ARABIA", numcode: "682" },
        { name: "Italy", iso3: "ITA", iso: "IT", iso_name: "ITALY", numcode: "380" },
        { name: "Senegal", iso3: "SEN", iso: "SN", iso_name: "SENEGAL", numcode: "686" },
        { name: "Jamaica", iso3: "JAM", iso: "JM", iso_name: "JAMAICA", numcode: "388" },
        { name: "Japan", iso3: "JPN", iso: "JP", iso_name: "JAPAN", numcode: "392" },
        { name: "Jordan", iso3: "JOR", iso: "JO", iso_name: "JORDAN", numcode: "400" },
        { name: "Belgium", iso3: "BEL", iso: "BE", iso_name: "BELGIUM", numcode: "56" },
        { name: "Belize", iso3: "BLZ", iso: "BZ", iso_name: "BELIZE", numcode: "84" },
        { name: "Kazakhstan", iso3: "KAZ", iso: "KZ", iso_name: "KAZAKHSTAN", numcode: "398" },
        { name: "Uganda", iso3: "UGA", iso: "UG", iso_name: "UGANDA", numcode: "800" },
        { name: "Benin", iso3: "BEN", iso: "BJ", iso_name: "BENIN", numcode: "204" },
        { name: "Kenya", iso3: "KEN", iso: "KE", iso_name: "KENYA", numcode: "404" },
        { name: "Ukraine", iso3: "UKR", iso: "UA", iso_name: "UKRAINE", numcode: "804" },
        { name: "Bermuda", iso3: "BMU", iso: "BM", iso_name: "BERMUDA", numcode: "60" },
        { name: "Kiribati", iso3: "KIR", iso: "KI", iso_name: "KIRIBATI", numcode: "296" },
        { name: "Mexico", iso3: "MEX", iso: "MX", iso_name: "MEXICO", numcode: "484", states_required: true },
        { name: "United Arab Emirates", iso3: "ARE", iso: "AE", iso_name: "UNITED ARAB EMIRATES", numcode: "784", states_required: true },
        { name: "Bhutan", iso3: "BTN", iso: "BT", iso_name: "BHUTAN", numcode: "64" },
        { name: "Cuba", iso3: "CUB", iso: "CU", iso_name: "CUBA", numcode: "192" },
        { name: "North Korea", iso3: "PRK", iso: "KP", iso_name: "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF", numcode: "408" },
        { name: "Micronesia, Federated States of", iso3: "FSM", iso: "FM", iso_name: "MICRONESIA, FEDERATED STATES OF", numcode: "583", states_required: true },
        { name: "United Kingdom", iso3: "GBR", iso: "GB", iso_name: "UNITED KINGDOM", numcode: "826" },
        { name: "Bolivia", iso3: "BOL", iso: "BO", iso_name: "BOLIVIA", numcode: "68" },
        { name: "Cyprus", iso3: "CYP", iso: "CY", iso_name: "CYPRUS", numcode: "196" },
        { name: "South Korea", iso3: "KOR", iso: "KR", iso_name: "KOREA, REPUBLIC OF", numcode: "410" },
        { name: "Moldova, Republic of", iso3: "MDA", iso: "MD", iso_name: "MOLDOVA, REPUBLIC OF", numcode: "498" },
        { name: "United States", iso3: "USA", iso: "US", iso_name: "UNITED STATES", numcode: "840", states_required: true },
        { name: "Bosnia and Herzegovina", iso3: "BIH", iso: "BA", iso_name: "BOSNIA AND HERZEGOVINA", numcode: "70" },
        { name: "Czech Republic", iso3: "CZE", iso: "CZ", iso_name: "CZECH REPUBLIC", numcode: "203" },
        { name: "Kuwait", iso3: "KWT", iso: "KW", iso_name: "KUWAIT", numcode: "414" },
        { name: "Monaco", iso3: "MCO", iso: "MC", iso_name: "MONACO", numcode: "492" },
        { name: "Uruguay", iso3: "URY", iso: "UY", iso_name: "URUGUAY", numcode: "858" },
        { name: "Botswana", iso3: "BWA", iso: "BW", iso_name: "BOTSWANA", numcode: "72" },
        { name: "Denmark", iso3: "DNK", iso: "DK", iso_name: "DENMARK", numcode: "208" },
        { name: "Guadeloupe", iso3: "GLP", iso: "GP", iso_name: "GUADELOUPE", numcode: "312" },
        { name: "Kyrgyzstan", iso3: "KGZ", iso: "KG", iso_name: "KYRGYZSTAN", numcode: "417" },
        { name: "Mongolia", iso3: "MNG", iso: "MN", iso_name: "MONGOLIA", numcode: "496" },
        { name: "Philippines", iso3: "PHL", iso: "PH", iso_name: "PHILIPPINES", numcode: "608" },
        { name: "Brazil", iso3: "BRA", iso: "BR", iso_name: "BRAZIL", numcode: "76", states_required: true },
        { name: "Djibouti", iso3: "DJI", iso: "DJ", iso_name: "DJIBOUTI", numcode: "262" },
        { name: "Guam", iso3: "GUM", iso: "GU", iso_name: "GUAM", numcode: "316" },
        { name: "Lao People's Democratic Republic", iso3: "LAO", iso: "LA", iso_name: "LAO PEOPLE'S DEMOCRATIC REPUBLIC", numcode: "418" },
        { name: "Montserrat", iso3: "MSR", iso: "MS", iso_name: "MONTSERRAT", numcode: "500" },
        { name: "Pitcairn", iso3: "PCN", iso: "PN", iso_name: "PITCAIRN", numcode: "612" },
        { name: "Uzbekistan", iso3: "UZB", iso: "UZ", iso_name: "UZBEKISTAN", numcode: "860" },
        { name: "Brunei Darussalam", iso3: "BRN", iso: "BN", iso_name: "BRUNEI DARUSSALAM", numcode: "96" },
        { name: "Dominica", iso3: "DMA", iso: "DM", iso_name: "DOMINICA", numcode: "212" },
        { name: "Guatemala", iso3: "GTM", iso: "GT", iso_name: "GUATEMALA", numcode: "320" },
        { name: "Morocco", iso3: "MAR", iso: "MA", iso_name: "MOROCCO", numcode: "504" },
        { name: "Poland", iso3: "POL", iso: "PL", iso_name: "POLAND", numcode: "616" },
        { name: "Vanuatu", iso3: "VUT", iso: "VU", iso_name: "VANUATU", numcode: "548" },
        { name: "Dominican Republic", iso3: "DOM", iso: "DO", iso_name: "DOMINICAN REPUBLIC", numcode: "214" },
        { name: "Mozambique", iso3: "MOZ", iso: "MZ", iso_name: "MOZAMBIQUE", numcode: "508" },
        { name: "Portugal", iso3: "PRT", iso: "PT", iso_name: "PORTUGAL", numcode: "620" },
        { name: "Sudan", iso3: "SDN", iso: "SD", iso_name: "SUDAN", numcode: "736", states_required: true },
        { name: "Venezuela", iso3: "VEN", iso: "VE", iso_name: "VENEZUELA", numcode: "862", states_required: true },
        { name: "Ecuador", iso3: "ECU", iso: "EC", iso_name: "ECUADOR", numcode: "218" },
        { name: "Guinea", iso3: "GIN", iso: "GN", iso_name: "GUINEA", numcode: "324" },
        { name: "Myanmar", iso3: "MMR", iso: "MM", iso_name: "MYANMAR", numcode: "104" },
        { name: "Puerto Rico", iso3: "PRI", iso: "PR", iso_name: "PUERTO RICO", numcode: "630" },
        { name: "Suriname", iso3: "SUR", iso: "SR", iso_name: "SURINAME", numcode: "740" },
        { name: "Viet Nam", iso3: "VNM", iso: "VN", iso_name: "VIET NAM", numcode: "704" },
        { name: "Egypt", iso3: "EGY", iso: "EG", iso_name: "EGYPT", numcode: "818" },
        { name: "Guinea-Bissau", iso3: "GNB", iso: "GW", iso_name: "GUINEA-BISSAU", numcode: "624" },
        { name: "Namibia", iso3: "NAM", iso: "NA", iso_name: "NAMIBIA", numcode: "516" },
        { name: "Qatar", iso3: "QAT", iso: "QA", iso_name: "QATAR", numcode: "634" },
        { name: "Svalbard and Jan Mayen", iso3: "SJM", iso: "SJ", iso_name: "SVALBARD AND JAN MAYEN", numcode: "744" },
        { name: "El Salvador", iso3: "SLV", iso: "SV", iso_name: "EL SALVADOR", numcode: "222" },
        { name: "Guyana", iso3: "GUY", iso: "GY", iso_name: "GUYANA", numcode: "328" },
        { name: "Reunion", iso3: "REU", iso: "RE", iso_name: "REUNION", numcode: "638" },
        { name: "Haiti", iso3: "HTI", iso: "HT", iso_name: "HAITI", numcode: "332" },
        { name: "Romania", iso3: "ROM", iso: "RO", iso_name: "ROMANIA", numcode: "642" },
        { name: "Swaziland", iso3: "SWZ", iso: "SZ", iso_name: "SWAZILAND", numcode: "748" },
        { name: "Holy See (Vatican City State)", iso3: "VAT", iso: "VA", iso_name: "HOLY SEE (VATICAN CITY STATE)", numcode: "336" },
        { name: "Russian Federation", iso3: "RUS", iso: "RU", iso_name: "RUSSIAN FEDERATION", numcode: "643", states_required: true },
        { name: "Sweden", iso3: "SWE", iso: "SE", iso_name: "SWEDEN", numcode: "752" },
        { name: "Honduras", iso3: "HND", iso: "HN", iso_name: "HONDURAS", numcode: "340" },
        { name: "Rwanda", iso3: "RWA", iso: "RW", iso_name: "RWANDA", numcode: "646" },
        { name: "Switzerland", iso3: "CHE", iso: "CH", iso_name: "SWITZERLAND", numcode: "756" },
        { name: "Hong Kong", iso3: "HKG", iso: "HK", iso_name: "HONG KONG", numcode: "344" },
        { name: "Syrian Arab Republic", iso3: "SYR", iso: "SY", iso_name: "SYRIAN ARAB REPUBLIC", numcode: "760" },
        { name: "Taiwan", iso3: "TWN", iso: "TW", iso_name: "TAIWAN, PROVINCE OF CHINA", numcode: "158" },
        { name: "Tajikistan", iso3: "TJK", iso: "TJ", iso_name: "TAJIKISTAN", numcode: "762" },
        { name: "Tanzania, United Republic of", iso3: "TZA", iso: "TZ", iso_name: "TANZANIA, UNITED REPUBLIC OF", numcode: "834" },
        { name: "Armenia", iso3: "ARM", iso: "AM", iso_name: "ARMENIA", numcode: "51" },
        { name: "Aruba", iso3: "ABW", iso: "AW", iso_name: "ARUBA", numcode: "533" },
        { name: "Australia", iso3: "AUS", iso: "AU", iso_name: "AUSTRALIA", numcode: "36", states_required: true },
        { name: "Thailand", iso3: "THA", iso: "TH", iso_name: "THAILAND", numcode: "764" },
        { name: "Austria", iso3: "AUT", iso: "AT", iso_name: "AUSTRIA", numcode: "40" },
        { name: "Madagascar", iso3: "MDG", iso: "MG", iso_name: "MADAGASCAR", numcode: "450" },
        { name: "Togo", iso3: "TGO", iso: "TG", iso_name: "TOGO", numcode: "768" },
        { name: "Azerbaijan", iso3: "AZE", iso: "AZ", iso_name: "AZERBAIJAN", numcode: "31" },
        { name: "Chile", iso3: "CHL", iso: "CL", iso_name: "CHILE", numcode: "152" },
        { name: "Malawi", iso3: "MWI", iso: "MW", iso_name: "MALAWI", numcode: "454" },
        { name: "Tokelau", iso3: "TKL", iso: "TK", iso_name: "TOKELAU", numcode: "772" },
        { name: "Bahamas", iso3: "BHS", iso: "BS", iso_name: "BAHAMAS", numcode: "44" },
        { name: "China", iso3: "CHN", iso: "CN", iso_name: "CHINA", numcode: "156" },
        { name: "Malaysia", iso3: "MYS", iso: "MY", iso_name: "MALAYSIA", numcode: "458" },
        { name: "Tonga", iso3: "TON", iso: "TO", iso_name: "TONGA", numcode: "776" },
        { name: "Bahrain", iso3: "BHR", iso: "BH", iso_name: "BAHRAIN", numcode: "48" },
        { name: "Colombia", iso3: "COL", iso: "CO", iso_name: "COLOMBIA", numcode: "170" },
        { name: "Maldives", iso3: "MDV", iso: "MV", iso_name: "MALDIVES", numcode: "462" },
        { name: "Trinidad and Tobago", iso3: "TTO", iso: "TT", iso_name: "TRINIDAD AND TOBAGO", numcode: "780" },
        { name: "Bangladesh", iso3: "BGD", iso: "BD", iso_name: "BANGLADESH", numcode: "50" },
        { name: "Comoros", iso3: "COM", iso: "KM", iso_name: "COMOROS", numcode: "174", states_required: true },
        { name: "French Polynesia", iso3: "PYF", iso: "PF", iso_name: "FRENCH POLYNESIA", numcode: "258" },
        { name: "Mali", iso3: "MLI", iso: "ML", iso_name: "MALI", numcode: "466" },
        { name: "Norfolk Island", iso3: "NFK", iso: "NF", iso_name: "NORFOLK ISLAND", numcode: "574" },
        { name: "Tunisia", iso3: "TUN", iso: "TN", iso_name: "TUNISIA", numcode: "788" },
        { name: "Barbados", iso3: "BRB", iso: "BB", iso_name: "BARBADOS", numcode: "52" },
        { name: "Congo", iso3: "COG", iso: "CG", iso_name: "CONGO", numcode: "178" },
        { name: "Gabon", iso3: "GAB", iso: "GA", iso_name: "GABON", numcode: "266" },
        { name: "Malta", iso3: "MLT", iso: "MT", iso_name: "MALTA", numcode: "470" },
        { name: "Northern Mariana Islands", iso3: "MNP", iso: "MP", iso_name: "NORTHERN MARIANA ISLANDS", numcode: "580" },
        { name: "Turkey", iso3: "TUR", iso: "TR", iso_name: "TURKEY", numcode: "792" },
        { name: "Congo, the Democratic Republic of the", iso3: "COD", iso: "CD", iso_name: "CONGO, THE DEMOCRATIC REPUBLIC OF THE", numcode: "180" },
        { name: "Marshall Islands", iso3: "MHL", iso: "MH", iso_name: "MARSHALL ISLANDS", numcode: "584" },
        { name: "Norway", iso3: "NOR", iso: "NO", iso_name: "NORWAY", numcode: "578" },
        { name: "Turkmenistan", iso3: "TKM", iso: "TM", iso_name: "TURKMENISTAN", numcode: "795" },
        { name: "Belarus", iso3: "BLR", iso: "BY", iso_name: "BELARUS", numcode: "112" },
        { name: "Cook Islands", iso3: "COK", iso: "CK", iso_name: "COOK ISLANDS", numcode: "184" },
        { name: "Gambia", iso3: "GMB", iso: "GM", iso_name: "GAMBIA", numcode: "270" },
        { name: "Martinique", iso3: "MTQ", iso: "MQ", iso_name: "MARTINIQUE", numcode: "474" },
        { name: "Oman", iso3: "OMN", iso: "OM", iso_name: "OMAN", numcode: "512" },
        { name: "Seychelles", iso3: "SYC", iso: "SC", iso_name: "SEYCHELLES", numcode: "690" },
        { name: "Turks and Caicos Islands", iso3: "TCA", iso: "TC", iso_name: "TURKS AND CAICOS ISLANDS", numcode: "796" },
        { name: "Georgia", iso3: "GEO", iso: "GE", iso_name: "GEORGIA", numcode: "268" },
        { name: "Mauritania", iso3: "MRT", iso: "MR", iso_name: "MAURITANIA", numcode: "478" },
        { name: "Pakistan", iso3: "PAK", iso: "PK", iso_name: "PAKISTAN", numcode: "586", states_required: true },
        { name: "Sierra Leone", iso3: "SLE", iso: "SL", iso_name: "SIERRA LEONE", numcode: "694" },
        { name: "Tuvalu", iso3: "TUV", iso: "TV", iso_name: "TUVALU", numcode: "798" },
        { name: "Costa Rica", iso3: "CRI", iso: "CR", iso_name: "COSTA RICA", numcode: "188" },
        { name: "Germany", iso3: "DEU", iso: "DE", iso_name: "GERMANY", numcode: "276" },
        { name: "Mauritius", iso3: "MUS", iso: "MU", iso_name: "MAURITIUS", numcode: "480" },
        { name: "Palau", iso3: "PLW", iso: "PW", iso_name: "PALAU", numcode: "585" },
        { name: "Cote D'Ivoire", iso3: "CIV", iso: "CI", iso_name: "COTE D'IVOIRE", numcode: "384" },
        { name: "Panama", iso3: "PAN", iso: "PA", iso_name: "PANAMA", numcode: "591" },
        { name: "Singapore", iso3: "SGP", iso: "SG", iso_name: "SINGAPORE", numcode: "702" },
        { name: "Croatia", iso3: "HRV", iso: "HR", iso_name: "CROATIA", numcode: "191" },
        { name: "Ghana", iso3: "GHA", iso: "GH", iso_name: "GHANA", numcode: "288" },
        { name: "Papua New Guinea", iso3: "PNG", iso: "PG", iso_name: "PAPUA NEW GUINEA", numcode: "598" },
        { name: "Slovakia", iso3: "SVK", iso: "SK", iso_name: "SLOVAKIA", numcode: "703" },
        { name: "Gibraltar", iso3: "GIB", iso: "GI", iso_name: "GIBRALTAR", numcode: "292" },
        { name: "Paraguay", iso3: "PRY", iso: "PY", iso_name: "PARAGUAY", numcode: "600" },
        { name: "Slovenia", iso3: "SVN", iso: "SI", iso_name: "SLOVENIA", numcode: "705" },
        { name: "Greece", iso3: "GRC", iso: "GR", iso_name: "GREECE", numcode: "300" },
        { name: "Peru", iso3: "PER", iso: "PE", iso_name: "PERU", numcode: "604" },
        { name: "Solomon Islands", iso3: "SLB", iso: "SB", iso_name: "SOLOMON ISLANDS", numcode: "90" },
        { name: "Greenland", iso3: "GRL", iso: "GL", iso_name: "GREENLAND", numcode: "304" },
        { name: "Somalia", iso3: "SOM", iso: "SO", iso_name: "SOMALIA", numcode: "706", states_required: true },
        { name: "Grenada", iso3: "GRD", iso: "GD", iso_name: "GRENADA", numcode: "308" },
        { name: "South Africa", iso3: "ZAF", iso: "ZA", iso_name: "SOUTH AFRICA", numcode: "710" },
        { name: "Spain", iso3: "ESP", iso: "ES", iso_name: "SPAIN", numcode: "724" },
        { name: "Sri Lanka", iso3: "LKA", iso: "LK", iso_name: "SRI LANKA", numcode: "144" },
        { name: "Afghanistan", iso3: "AFG", iso: "AF", iso_name: "AFGHANISTAN", numcode: "4" },
        { name: "Albania", iso3: "ALB", iso: "AL", iso_name: "ALBANIA", numcode: "8" },
        { name: "Algeria", iso3: "DZA", iso: "DZ", iso_name: "ALGERIA", numcode: "12" },
        { name: "Latvia", iso3: "LVA", iso: "LV", iso_name: "LATVIA", numcode: "428" },
        { name: "American Samoa", iso3: "ASM", iso: "AS", iso_name: "AMERICAN SAMOA", numcode: "16" },
        { name: "Bulgaria", iso3: "BGR", iso: "BG", iso_name: "BULGARIA", numcode: "100" },
        { name: "Lebanon", iso3: "LBN", iso: "LB", iso_name: "LEBANON", numcode: "422" },
        { name: "Andorra", iso3: "AND", iso: "AD", iso_name: "ANDORRA", numcode: "20" },
        { name: "Burkina Faso", iso3: "BFA", iso: "BF", iso_name: "BURKINA FASO", numcode: "854" },
        { name: "Lesotho", iso3: "LSO", iso: "LS", iso_name: "LESOTHO", numcode: "426" },
        { name: "Angola", iso3: "AGO", iso: "AO", iso_name: "ANGOLA", numcode: "24" },
        { name: "Burundi", iso3: "BDI", iso: "BI", iso_name: "BURUNDI", numcode: "108" },
        { name: "Liberia", iso3: "LBR", iso: "LR", iso_name: "LIBERIA", numcode: "430" },
        { name: "Virgin Islands, British", iso3: "VGB", iso: "VG", iso_name: "VIRGIN ISLANDS, BRITISH", numcode: "92" },
        { name: "Anguilla", iso3: "AIA", iso: "AI", iso_name: "ANGUILLA", numcode: "660" },
        { name: "Cambodia", iso3: "KHM", iso: "KH", iso_name: "CAMBODIA", numcode: "116" },
        { name: "Equatorial Guinea", iso3: "GNQ", iso: "GQ", iso_name: "EQUATORIAL GUINEA", numcode: "226" },
        { name: "Libyan Arab Jamahiriya", iso3: "LBY", iso: "LY", iso_name: "LIBYAN ARAB JAMAHIRIYA", numcode: "434" },
        { name: "Nauru", iso3: "NRU", iso: "NR", iso_name: "NAURU", numcode: "520" },
        { name: "Virgin Islands, U.S.", iso3: "VIR", iso: "VI", iso_name: "VIRGIN ISLANDS, U.S.", numcode: "850" },
        { name: "Antigua and Barbuda", iso3: "ATG", iso: "AG", iso_name: "ANTIGUA AND BARBUDA", numcode: "28" },
        { name: "Cameroon", iso3: "CMR", iso: "CM", iso_name: "CAMEROON", numcode: "120" },
        { name: "Liechtenstein", iso3: "LIE", iso: "LI", iso_name: "LIECHTENSTEIN", numcode: "438" },
        { name: "Nepal", iso3: "NPL", iso: "NP", iso_name: "NEPAL", numcode: "524", states_required: true },
        { name: "Wallis and Futuna", iso3: "WLF", iso: "WF", iso_name: "WALLIS AND FUTUNA", numcode: "876" },
        { name: "Western Sahara", iso3: "ESH", iso: "EH", iso_name: "WESTERN SAHARA", numcode: "732" },
        { name: "Argentina", iso3: "ARG", iso: "AR", iso_name: "ARGENTINA", numcode: "32" },
        { name: "Canada", iso3: "CAN", iso: "CA", iso_name: "CANADA", numcode: "124", states_required: true },
        { name: "Eritrea", iso3: "ERI", iso: "ER", iso_name: "ERITREA", numcode: "232" },
        { name: "Lithuania", iso3: "LTU", iso: "LT", iso_name: "LITHUANIA", numcode: "440" },
        { name: "Netherlands", iso3: "NLD", iso: "NL", iso_name: "NETHERLANDS", numcode: "528" },
        { name: "Yemen", iso3: "YEM", iso: "YE", iso_name: "YEMEN", numcode: "887" },
        { name: "Cape Verde", iso3: "CPV", iso: "CV", iso_name: "CAPE VERDE", numcode: "132" },
        { name: "Estonia", iso3: "EST", iso: "EE", iso_name: "ESTONIA", numcode: "233" },
        { name: "Luxembourg", iso3: "LUX", iso: "LU", iso_name: "LUXEMBOURG", numcode: "442" },
        { name: "Netherlands Antilles", iso3: "ANT", iso: "AN", iso_name: "NETHERLANDS ANTILLES", numcode: "530" },
        { name: "Saint Helena", iso3: "SHN", iso: "SH", iso_name: "SAINT HELENA", numcode: "654" },
        { name: "Zambia", iso3: "ZMB", iso: "ZM", iso_name: "ZAMBIA", numcode: "894" },
        { name: "Cayman Islands", iso3: "CYM", iso: "KY", iso_name: "CAYMAN ISLANDS", numcode: "136" },
        { name: "Ethiopia", iso3: "ETH", iso: "ET", iso_name: "ETHIOPIA", numcode: "231", states_required: true },
        { name: "Hungary", iso3: "HUN", iso: "HU", iso_name: "HUNGARY", numcode: "348" },
        { name: "Macao", iso3: "MAC", iso: "MO", iso_name: "MACAO", numcode: "446" },
        { name: "New Caledonia", iso3: "NCL", iso: "NC", iso_name: "NEW CALEDONIA", numcode: "540" },
        { name: "Zimbabwe", iso3: "ZWE", iso: "ZW", iso_name: "ZIMBABWE", numcode: "716" },
        { name: "Central African Republic", iso3: "CAF", iso: "CF", iso_name: "CENTRAL AFRICAN REPUBLIC", numcode: "140" },
        { name: "Falkland Islands (Malvinas)", iso3: "FLK", iso: "FK", iso_name: "FALKLAND ISLANDS (MALVINAS)", numcode: "238" },
        { name: "Iceland", iso3: "ISL", iso: "IS", iso_name: "ICELAND", numcode: "352" },
        { name: "Macedonia", iso3: "MKD", iso: "MK", iso_name: "MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF", numcode: "807" },
        { name: "New Zealand", iso3: "NZL", iso: "NZ", iso_name: "NEW ZEALAND", numcode: "554" },
        { name: "Saint Kitts and Nevis", iso3: "KNA", iso: "KN", iso_name: "SAINT KITTS AND NEVIS", numcode: "659", states_required: true },
        { name: "Serbia", iso3: "SRB", iso: "RS", "iso_name" => "SERBIA", numcode: "999" },
        { name: "Montenegro", iso3: "MNE", iso: "ME", iso_name: "MONTENEGRO", numcode: "499" },
        { name: "Jersey", iso3: "JEY", iso: "JE", iso_name: "JERSEY", numcode: "44" }
      ])
      Spree::Config[:default_country_id] = Spree::Country.find_by(name: "United States").id
    end
  end
end
