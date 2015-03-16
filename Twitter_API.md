## Introduction ##

**test.xmxl** is the test application to demo the public functions in class **Twitter**, which is dependended on **com.twitter.TwitterService**.

## Details ##

  * Class **TwitterService** extends **HTTPServcie**, and issues commands (Twitter REST API) to retrieve (by GET) or update (by POST) statuses.
  * **getUserTimeline()**, **getFriendsTimeline()** and **getReplies()** return arrays of statuses (currently 20 entries).
  * **setLocation()** and **setUpdate()** update the user's location/status message.
  * **username** and **password** should be passed into the constructor of **TwitterService** for authentication.

## Notes ##
  * Currently the getter calls are asynchronous. Each call just get the last cached statuses. It also issues a new HTTP transaction which costs some time to finish and flush the cached value for next time's use.
  * Event-driven call-back for each call may be incorporated to avoid the lag of status update, but will be more complex (more parameter, more functions).
  * Default to retrieve 20 statuses, may use timestamps to get only the new ones.
  * For displaying the retrieved data, post-processing may needed to merge multiple result into a single list for each timeline.