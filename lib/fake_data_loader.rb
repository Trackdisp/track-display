# Put, inside the load method, the necessary code to generate data with DEVELOPMENT PURPOSES.
# Whenever you can, use FactoryBot's methods to keep this code "self updated".
#
# For Example:
#
# Having a country factory in /spec/factories/countries.rb
#
# FactoryBot.define do
#   factory :country do
#     name "Chile"
#     locale "es-CL"
#     currency "$CLP"
#   end
# end
#
# Choose to do this:
#
# create(:country)
#
# Instead of this:
#
# Country.create(name: "Chile", locale: "es-CL", currency: "$CLP")
#

Faker::Config.locale = I18n.locale

module FakeDataLoader
  extend FactoryBot::Syntax::Methods

  def self.load
    load_admin
    Company.destroy_all
    create_companies
    create_brands
  end

  def self.create_brands
    5.times do
      brand = create(:brand)
      create_locations(brand)
    end
  end

  def self.create_companies
    5.times do
      company = create(:company)
      create_campaigns(company)
    end
  end

  def self.create_campaigns(company)
    rand(5).times do
      campaign = create(:campaign, company: company)
      create_devices(campaign)
    end
  end

  def self.create_locations(brand)
    rand(5).times do
      create(:location, brand: brand)
    end
  end

  def self.create_devices(campaign)
    rand(5).times do
      device = create(:device, campaign: campaign)
      create_measures(device)
    end
  end

  def self.create_measures(device)
    rand(30).times { create(:measure, device: device) }
  end

  def self.load_admin
    email = "admin@example.com"
    pass = "password"
    admin = AdminUser.find_by(email: email)
    AdminUser.create!(email: email, password: pass, password_confirmation: pass) unless admin
  end
end
