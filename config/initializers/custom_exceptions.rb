Dir[Rails.root.join("lib/custom_exceptions/**/*.rb")].each { |except| require except }

puts "CUSTOM EXCEPTIONS LOADED".green