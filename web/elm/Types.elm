module Types exposing (..)

type Msg
  = SwitchTab Tab
  | UpdateEnvironment String
  | UpdateSettings Settings
  | UpdateEmail String
  | UpdateName String
  | UpdateCommits (List Commit)
  | UpdateCommit Commit
  | ShowCommit Int
  | StartReview CommitChange
  | AbandonReview CommitChange
  | MarkAsReviewed CommitChange
  | MarkAsNew CommitChange

type Tab
  = CommitsTab
  | CommentsTab
  | SettingsTab

type alias Settings =
  { name : String
  , email : String
  }

type alias Field =
  { id : String
  , label : String
  , name : String
  , value : String
  , onInput : Msg
  }

type alias CommitChange =
  { id : Int
  , byEmail : String
  }

type alias CommitButton =
  { name : String
  , class : String
  , iconClass : String
  , msg : Msg
  }

type alias Commit =
  { id : Int
  , summary : String
  , authorGravatarHash : String
  , pendingReviewerGravatarHash : String
  , reviewerGravatarHash : String
  , repository : String
  , authorName : String
  , timestamp : String
  , isNew : Bool
  , isReviewed : Bool
  , isBeingReviewed : Bool
  , url : String
  }

type alias Model =
  { commits : List Commit
  , settings : Settings
  , exampleAuthor : String
  , lastClickedCommitId : Int
  , environment : String
  , activeTab : Tab
  }