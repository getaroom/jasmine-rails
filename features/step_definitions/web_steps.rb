Given(/^I open the specs page$/) do
  visit '/specs'
end

Then(/^I should see "(.*?)"( or "(.*?)")?$/) do |selector, dummy, fallback|
  begin
    find(:css, selector)
  rescue
    find(:css, fallback)
    raise unless fallback # raise with no arg re-raises the rescued exception
  end
end

Then(/^the page should display "(.*?)"$/) do |content|
  have_content content
end

Then(/^the page should not display "(.*?)"$/) do |content|
  have_no_content content
end
