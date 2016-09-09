defmodule Exremit.CommentsTest do
  use Exremit.AcceptanceCase
  import Exremit.Factory

  test "shows a list of comments, with the newest on top" do
    comment1 = insert(:comment)
    comment2 = insert(:comment)
    comment3 = insert(:comment)

    navigate_to_comments_page

    elements = find_all_elements(:css, ".test-comment")
    assert length(elements) == 3

    comment_ids = elements
      |> Enum.map(fn e ->
        attribute_value(e, :id)
      end)

    assert comment_ids == [
      "comment-#{comment3.id}",
      "comment-#{comment2.id}",
      "comment-#{comment1.id}",
    ]
  end

  test "comments can be filtered" do
    joe = insert(:author, name: "Joe")
    jane = insert(:author, name: "Jane")
    fred = insert(:author, name: "Fred")

    your_comment = insert(:comment, author: joe)
    resolved_comment = insert(:comment, resolved_by_author: jane)

    commit = insert(:commit, author: fred)
    other_people_comment_on_other_peoples_commit = insert(:comment, author: jane, commit: commit)

    navigate_to_settings_page
    fill_in "name", with: "Joe"

    navigate_to_comments_page
    assert comment_visible?(your_comment)
    assert comment_visible?(resolved_comment)
    assert comment_visible?(other_people_comment_on_other_peoples_commit)

    uncheck "test-comments-i-wrote"

    #assert !comment_visible?(your_comment)
    #assert comment_visible?(resolved_comment)
    #assert comment_visible?(other_people_comment_on_other_peoples_commit)

    # TODO: test persistence of settings
  end

  defp uncheck(checkbox_class) do
    checkbox = find_element(:css, ".#{checkbox_class}")
    assert selected?(checkbox)
    click(checkbox)
    assert !selected?(checkbox)
  end

  defp comment_visible?(comment) do
    find_element(:id, "comment-#{comment.id}")
  end
end
