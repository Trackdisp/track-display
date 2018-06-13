namespace :fake_data do
  FAKE_CAMPAIGNS_COUNT = 5
  FAKE_COMMUNES_COUNT = 5
  FAKE_COMPANIES_COUNT = 2
  FAKE_DEVICES_COUNT = 5
  FAKE_MEASURES_COUNT = 30
  FAKE_PASSWORD = 'password'
  FAKE_REGION_COUNT = 3
  FAKE_USERS_COUNT = 5


  desc "Create fake companies"
  task create_companies: :environment do
    puts 'Creating companies ...'

    (1..FAKE_COMPANIES_COUNT).each do
      Company.create!(name: Faker::Company.name)
    end
    puts 'Companies creation complete'
  end

  desc "Create fake campaigns"
  task create_campaigns: :environment do
    puts 'Creating campaigns ...'

    Company.all.each do |company|
      (1..FAKE_CAMPAIGNS_COUNT).each do
        Campaign.create!(
          name: Faker::Commerce.product_name,
          company: company,
          start_date: Faker::Date.between(3.months.ago, Date.today),
          end_date: Faker::Date.between(Date.today, 3.months.from_now)
        )
      end
    end

    puts 'Campaigns creation complete'
  end

  desc "Create fake users"
  task create_users: :environment do
    puts 'Creating users ...'

    Company.all.each do |company|
      (1..FAKE_USERS_COUNT).each do
        User.create!(
          email: Faker::Internet.safe_email,
          password: FAKE_PASSWORD,
          password_confirmation: FAKE_PASSWORD,
          company: company
        )
      end
    end

    puts 'Users creation complete'
  end

  desc "Create fake devices"
  task create_devices: :environment do
    puts 'Creating devices ...'

    Campaign.all.each do |campaign|
      (1..FAKE_DEVICES_COUNT).each do
        Device.create!(
          serial: Faker::Code.imei,
          name: Faker::Space.star,
          campaign: campaign
        )
      end
    end

    puts 'Devices creation complete'
  end

  desc "Create fake measures"
  task create_measures: :environment do
    puts 'Creating measures ...'
    Device.all.each do |device|
      (1..rand(FAKE_MEASURES_COUNT)).each do
        Measure.create!(
          device: device,
          measured_at: Faker::Date.between(3.month.ago, Date.today),
          avg_age: Faker::Number.between(10, 40),
          w_id: Faker::Code.imei,
          presence_duration: Faker::Number.decimal(2, 1).to_f,
          contact_duration: Faker::Number.decimal(1, 1).to_f,
          happiness: Faker::Number.decimal(0, 3).to_f,
          gender: Measure::GENDER_TYPES[Faker::Number.between(0, 2)]
        )
      end
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
