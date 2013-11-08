# Add a declarative step here for populating the DB with movies.
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie) 

  end
 # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page


Given /^(?:|I) am on (.+)$/ do |page_name|
  visit path_to(page_name)
end


When /I follow (.*)/ do |sort_choice|
  if sort_choice == "Movie Title"
  click_on("title_header")
  elsif sort_choice == "Release Date"
  click_on("release_date_header")
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  aString = page.body.to_s
  aString.index(e1).should > aString.index(e2)
end




# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.r
  rating_list.split(', ').each do |rating|
    if uncheck 
      uncheck "ratings_#{rating}"
    else
      check "ratings_#{rating}"
    end
  end
end

When /^I press (.*)$/ do |button|
  click_on(button)
end

Then /^"(.*)" should appear$/ do |title|
  if page.respond_to? :should #checking if the page contains the list of movies
  page.should have_content(title)
  else
    assert page.has_content?(text)
  end
end


Then /^"(.*)" should not appear$/ do |title|
  if page.respond_to? :should #checking if the page contains the list of movies
  page.should have_no_content(title)
  else
    assert page.has_no_content?(text)
  end
end

Then /I should see all of the movies/ do
  rows = page.all('table#movies tbody tr').size
  rows.should == Movie.all.size
end

#Then /I should see none of the movies/ do
 # rows = page.all('table#movies tbody tr').size
 # assert rows == 0
#end

