RAILS_VER = ['3.2', '4.0', '4.1', '4.2', '5.0'].freeze
JASMINE_VER = ['2.0', '2.1', '2.2', '2.3', '2.4', '2.5'].freeze

RAILS_VER.each do |rails_ver|
  JASMINE_VER.each do |jasmine_ver|
    appraise "rails-#{rails_ver}-jasmine-#{jasmine_ver}" do
      gem 'rails', "~> #{rails_ver}"
      gem 'jasmine-core', "~> #{jasmine_ver}.0"
    end
  end
end
