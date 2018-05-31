namespace :fake_data do
  FAKE_COMMUNES_COUNT = 5
  FAKE_COMPANIES_COUNT = 2
  FAKE_DEVICES_COUNT = 5
  FAKE_MEASURES_COUNT = 40
  FAKE_PASSWORD = 'password'
  FAKE_REGION_COUNT = 3
  FAKE_USERS_COUNT = 5


  desc "Create fake companies"
  task create_companies: :environment do
    puts 'Creating companies ...'

    (1..FAKE_COMPANIES_COUNT).each do
      Company.create(name: Faker::Company.name)
    end
    puts 'Companies creation complete'
  end

  desc "Create fake users"
  task create_users: :environment do
    puts 'Creating users ...'

    (1..FAKE_USERS_COUNT).each do
      User.create(email: Faker::Internet.safe_email, password: FAKE_PASSWORD,
                  password_confirmation: FAKE_PASSWORD,
                  company_id: Faker::Number.between(1, FAKE_COMPANIES_COUNT))
    end
    puts 'Users creation complete'
  end

  desc "Create fake devices"
  task create_devices: :environment do
    puts 'Creating devices ...'
    (1..FAKE_DEVICES_COUNT).each do
      Device.create(serial: Faker::Code.imei,
                    company_id: Faker::Number.between(1, FAKE_COMPANIES_COUNT))
    end
    puts 'Devices creation complete'
  end

  desc "Create fake measures"
  task create_measures: :environment do
    puts 'Creating measures ...'
    (1..FAKE_MEASURES_COUNT).each do
      Measure.create(
        device_id: Faker::Number.between(1, FAKE_DEVICES_COUNT),
        measured_at: Faker::Date.between(2.month.ago, Date.today),
        people_count: Faker::Number.between(10, 30),
        views_over_5: Faker::Number.between(1, 10),
        views_over_15: Faker::Number.between(1, 10),
        views_over_30: Faker::Number.between(1, 10),
        male_count: Faker::Number.between(1, 10),
        female_count: Faker::Number.between(1, 10),
        avg_age: Faker::Number.between(10, 40),
        happy_count: Faker::Number.between(1, 10)
      )
    end

    puts 'Measures creation complete'
  end

  desc "Create fake regions"
  task create_regions: :environment do
    puts 'Creating regions ...'
    (1..FAKE_REGION_COUNT).each do |num|
      Region.create!(name: "Fake Region #{num}")
    end
    puts 'Regions creation complete'
  end

  desc "Create fake communes"
  task create_communes: :environment do
    puts 'Creating communes ...'
    Region.all.each do |region|
      (1..FAKE_COMMUNES_COUNT).each do |num|
        Commune.create!(
          name: "Fake Commune #{region.id}-#{num}",
          region: region
        )
      end
    end
    puts 'Communes creation complete'
  end
end
