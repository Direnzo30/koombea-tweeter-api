Dir[Rails.root.join("lib/custom_modules/**/*.rb")].each { |mod| require mod }

puts "CUSTOM MODULES LOADED".green