module CommitList.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Date exposing (..)
import Date.Format exposing (..)
import String

import CommitList.Types exposing (..)

view model =
  ul [ class "commits-list" ] (List.map (lazyRenderCommit model) model.commits)

-- TODO: figure out if this actually works, the Debug.log is called
--       for each commit even if only one has changed
lazyRenderCommit model commit =
  lazy (renderCommit model) commit

renderCommit model commit =
  li [ id (commitId commit), (commitClassList model commit) ] [
    --a [ class "block-link", href (commitUrl model commit) ] [
    --  div [ class "commit-wrapper", onClick (ShowCommit commit.id)  ] [
    --    div [ class "commit-controls" ] (renderButtons model commit)
    --  , img [ class "commit-avatar", src (avatarUrl commit.authorGravatarHash) ] []
    --  , div [ class "commit-summary-and-details" ] [
    --      div [ class "commit-summary test-summary" ] [ text commit.summary ]
    --    , renderCommitDetails commit
    --    ]
    --  ]
    --]
  ]

--renderCommitDetails : Commit -> Html
--renderCommitDetails commit =
--  div [ class "commit-details" ] [
--    text " in "
--  , strong [] [ text commit.repository ]
--  , span [ class "by-author" ] [
--      text " by "
--    , strong [] [ text commit.authorName ]
--    , text " on "
--    , span [ class "test-timestamp" ] [ text (formattedTime commit.timestamp) ]
--    ]
--  ]
--
---- don't link to github in tests since that makes testing difficult
--commitUrl model commit =
--  if model.environment /= "test" then commit.url else "#"
--
--renderButtons : Model -> Commit -> List Html
--renderButtons model commit =
--  if commit.isNew then
--    [
--      commitButton {
--        name = "Start review"
--      , class = "start-review"
--      , iconClass = "fa-eye"
--      , action = (commitChangeAction StartReview model commit)
--      }
--    ]
--  else if commit.isBeingReviewed then
--    [
--      commitButton {
--        name = "Abandon review"
--      , class = "abandon-review"
--      , iconClass = "fa-eye-slash"
--      , action = (commitChangeAction AbandonReview model commit)
--      }
--    , commitButton {
--        name = "Mark as reviewed"
--      , class = "mark-as-reviewed"
--      , iconClass = "fa-eye-slash"
--      , action = (commitChangeAction MarkAsReviewed model commit)
--      }
--    , img [ class "commit-reviewer-avatar", src (avatarUrl commit.pendingReviewerGravatarHash) ] []
--    ]
--  else if commit.isReviewed then
--    [
--      commitButton {
--        name = "Mark as new"
--      , class = "mark-as-new"
--      , iconClass = "fa-eye-slash"
--      , action = (commitChangeAction MarkAsNew model commit)
--      }
--    , img [ class "commit-reviewer-avatar", src (avatarUrl commit.reviewerGravatarHash) ] []
--    ]
--  else
--    -- This should never happen
--    []
--
--commitChangeAction action model commit =
--  action { byEmail = model.settings.email, id = commit.id }
--
--commitButton : CommitButton -> Html
--commitButton commitButton =
--  button [ class ("small test-button" ++ " " ++ commitButton.class), onClick commitButton.action ] [
--    i [ class ("fa" ++ " " ++ commitButton.iconClass) ] [ text commitButton.name ]
--  ]
--
--#commitClassList : Model -> Commit -> Attribute
commitClassList model commit =
  classList [
    ("commit", True)

  , ("your-last-clicked", model.lastClickedCommitId == commit.id)
  , ("authored-by-you", authoredByYou model commit)

  , ("is-being-reviewed", commit.isBeingReviewed)
  , ("is-reviewed", commit.isReviewed)

  , ("test-is-new", commit.isNew)
  , ("test-is-being-reviewed", commit.isBeingReviewed)
  , ("test-is-reviewed", commit.isReviewed)
  , ("test-commit", True)
  , ("test-authored-by-you", authoredByYou model commit)
  ]

authoredByYou model commit =
  String.contains model.settings.name commit.authorName
--
--formattedTime : String -> String
--formattedTime timestamp =
--  timestamp
--  |> Date.fromString
--  |> Result.withDefault (Date.fromTime 0)
--  |> Date.Format.format "%a %e %b at %H:%M" -- E.g. Wed 3 Feb at 15:14
--
--avatarUrl : String -> String
--avatarUrl gravatarHash =
--  "https://secure.gravatar.com/avatar/" ++ gravatarHash ++ "?size=40&amp;rating=x&amp;default=mm"
--
commitId : Commit -> String
commitId commit =
  "commit-" ++ toString commit.id
