require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "creating a Course" do
    visit courses_url
    click_on "New Course"

    fill_in "Client", with: @course.client_id
    fill_in "Comment", with: @course.comment
    fill_in "Driver", with: @course.driver_id
    fill_in "End address", with: @course.end_address
    fill_in "Note", with: @course.note
    fill_in "Price", with: @course.price
    fill_in "Resa date", with: @course.resa_date
    fill_in "Start eddress", with: @course.start_eddress
    fill_in "Status", with: @course.status
    fill_in "User", with: @course.user_id
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "updating a Course" do
    visit courses_url
    click_on "Edit", match: :first

    fill_in "Client", with: @course.client_id
    fill_in "Comment", with: @course.comment
    fill_in "Driver", with: @course.driver_id
    fill_in "End address", with: @course.end_address
    fill_in "Note", with: @course.note
    fill_in "Price", with: @course.price
    fill_in "Resa date", with: @course.resa_date
    fill_in "Start eddress", with: @course.start_eddress
    fill_in "Status", with: @course.status
    fill_in "User", with: @course.user_id
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "destroying a Course" do
    visit courses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Course was successfully destroyed"
  end
end
