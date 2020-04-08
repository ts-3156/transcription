require "application_system_test_case"

class TranscriptsTest < ApplicationSystemTestCase
  setup do
    @transcript = transcripts(:one)
  end

  test "visiting the index" do
    visit transcripts_url
    assert_selector "h1", text: "Transcripts"
  end

  test "creating a Transcript" do
    visit transcripts_url
    click_on "New Transcript"

    fill_in "Name", with: @transcript.name
    click_on "Create Transcript"

    assert_text "Transcript was successfully created"
    click_on "Back"
  end

  test "updating a Transcript" do
    visit transcripts_url
    click_on "Edit", match: :first

    fill_in "Name", with: @transcript.name
    click_on "Update Transcript"

    assert_text "Transcript was successfully updated"
    click_on "Back"
  end

  test "destroying a Transcript" do
    visit transcripts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transcript was successfully destroyed"
  end
end
