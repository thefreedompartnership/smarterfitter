# Include your application configuration below

require 'tzinfo/lib/tzinfo' # Use tzinfo library to convert to and from the users timezone
ENV['TZ'] = 'UTC' # This makes Time.now return time in UTC

require 'acts_as_ferret'

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:diary => "%A, %B %e, %Y")
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:mmddyyyy => "%D")
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:mmddyyyy => "%D")
