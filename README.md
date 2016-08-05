# Domain Model

## Video

Basic unit of video.  Serves as the mechanism to store raw videos.

## Upload

Represents an individual file upload.  The upload references the original Video
and the Camera it belongs to.

## Camera

Allows videos to be grouped together.  The camera is really just a name to
link Videos to Setups.

## Setup

Represents the camera setup; location, range etc.  Setups can be tied to
Strava activities.

## Draft

Represents the slice of an Upload that a user is in.  It compares the user's
activities with camera setups to determine if portions of videos should be in
the users feed.  If the user uploads a headcam or something similar, it should
automatically become a draft.

## Activity

Time series data recording a user's activity; from Strava
