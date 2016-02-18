defmodule Exremit.SettingsTest do
  use Exremit.AcceptanceCase

  test "can save settings on the client" do
    navigate_to_settings_page

    # Default usage explaination
    assert usage_explaination == "If your name is \"Charles Babbage\", a commit authored e.g. by \"Charles Babbage\" or by \"Ada Lovelace and Charles Babbage\" will be considered yours."

    # Fill in details
    fill_in "email", with: "joe@example.com"
    fill_in "name", with: "Joe"

    # WIP:

    # Your details are used in an example
    #assert usage_explaination == "A commit authored e.g. by \"Joe\" or by \"Ada Lovelace and Joe\" will be considered yours."

    # Is still around when the page reloads
    #navigate_to_settings_page
    #assert usage_explaination == "A commit authored e.g. by \"Joe\" or by \"Ada Lovelace and Joe\" will be considered yours."
  end

  defp usage_explaination, do: find_element(:css, ".test-usage-explanation") |> inner_text

  defp navigate_to_settings_page, do: navigate_to "/settings?auth_key=secret"

  defp fill_in(field, with: value), do: find_element(:name, field) |> fill_field(value)

  defp click_save, do: find_element(:type, "submit") |> click
end