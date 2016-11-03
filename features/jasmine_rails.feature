Feature: Specs page

Scenario:
  When I open the specs page
  Then I should see ".jasmine_html-reporter"
  And I should see ".jasmine-bar.jasmine-passed" or ".bar.passed"
  And I should see "#blanket-main"
  And the page should display "application"
  And the page should not display "underscore"
