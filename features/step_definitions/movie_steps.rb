# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.
Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  visit movies_path
  ratings = arg1.split(', ')
  all("input[type='checkbox']").each{|box| box.set(false)}
  ratings.each do |rating|
    print 
    check("ratings_#{rating}")
  end
  click_button("ratings_submit")
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = arg1.split(', ')
  result = true
    all("tr > td:nth-child(2)").each do |tr|
      if !(ratings.include?(tr.text))
       result = false
        break
      end
    end  
    expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  row_count = all("tr").count
  all("input[type='checkbox']").each{|box| box.set(true)}
  click_button("ratings_submit")
  all_count = all("tr").count
  expect(all_count).to eql(row_count)
end

When /^I sort movies alphabetically$/ do
  click_on("title_header")
end

When /^I sort movies order of release date$/ do
  click_on("release_date_header")
end

Then /^I should see "(.*?)" before "(.*?)" in Movie Title$/ do |arg1, arg2|
  items = []
  all("tr > td:nth-child(1)").each do |object|
    items.push(object.text)
  end
  arg1_index = items.index(arg1)
  arg2_index = items.index(arg2)

  expect(arg1_index).to be < arg2_index
end

Then /^I should see "(.*?)" before "(.*?)" in Release Date$/ do |arg1, arg2|
  items = []
  all("tr > td:nth-child(3)").each do |object|
    items.push(object.text)
  end
  arg1_index = items.index(arg1)
  arg2_index = items.index(arg2)

  expect(arg1_index).to be < arg2_index
end


