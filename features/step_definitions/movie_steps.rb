# Add a declarative step here for populating the DB with movies.
movies_count = 0

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie) 
    movies_count += 1
  end
 # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Given /^(?:|I) am on (.+)$/ do |page_name|
  visit path_to(page_name)
end


When /I follow 'Movie Title'/ do |sort_choice|
  if sort_choice == "Movie Title"
  click_on("title_header")
  elsif sort_choice == "Release Date"
  click_on("release_date_header")
  end
end

Then /I should see "(.*)" before "(.*)"/ do|e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  astring = page.body.to_s
  if astring.index(e1)!= nil && astring.index(e2)!=nil
    if astring.index(e1)< astring.index(e2)
    else 
      assert false, "jr_fail"
    end
  else 
    assert false, "jr_fail"
  end
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

Then /I should see none of the movies/ do
  rows = page.all('#movies tr').length -1
  assert rows == 0
end

Then /I should see all of the movies/ do
rows = page.all('#movies tr').size -1
assert rows == movies_count
end
