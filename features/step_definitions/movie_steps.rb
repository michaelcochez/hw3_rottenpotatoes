#require File.expand_path(File.join(File.dirname(__FILE__),  "web_steps"))


# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |expected1, expected2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #flunk "Unimplemented"
  
  actualTitles = page.all("#movies td:nth-child(1)").map {|el| el.text}
  if actualTitles.index(expected1) == 0 || actualTitles.index(expected2) == 0
    flunk("expected titles not found")
  elsif actualTitles.index(expected1) > actualTitles.index(expected2)
    flunk ("Order is reversed! " + expected2 + " appears before " + expected1)
  end
  
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

#Changed from 'When' to 'Given' and back again
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/,\s*/).each do |rating|
    if uncheck
      step %Q{I uncheck "ratings_#{rating}"}
    else    
      step %Q{I check "ratings_#{rating}"}
    end
  end
end



Then /^movies with these ratings are (not )?visible: (.*)$/ do |negation, rating_list|
  #pending # express the regexp above with the code you wish you had
#  print page.content
  ratings = rating_list.split(/,\s*/)
  found = false
  page.all("#movies td:nth-child(2)").map {|el| el.text}.each do |theRating|
    #print a_rating.text
    #theRating = ratingElement.text
    if ratings.include? theRating
        found = true
    end
  end
  if negation 
    if found 
      flunk("A movie with rating " + theRating + " was found, while movies with ratings " + rating_list + " where not allowed" )
    end
  else #no negation
    if not found
      flunk ("No movies with ratings " + rating_list)
    end
  end
end


#Then /^movies with these ratings are not visible: PG\-(\d+), G$/ do |arg1|
#  pending # express the regexp above with the code you wish you had
#end

Then /^I should see all of the movies$/ do
    expected = Movie.count
    
    #actual = 
    page.all("#movies tbody tr").each do |someTR|
      print someTR
    end
    
    
    #("#movies tbody tr").count
#    if actual != expected
#      flunk "The number of movies shown is " + actual.to_s + " while the expected number was " + expected.to_s
#    end
end
