# Baburu (バブル)

Minimalistic, native and open-source push notification service for macOS written in Swift 5.

<img src="screenshot.png" align="center">

The application is a [Menu Extra Bar](https://developer.apple.com/design/human-interface-guidelines/macos/extensions/menu-bar-extras/), also known as a “menu bar app”. It allows you to configure access to a self-hosted web API service that stores and delivers JSON objects that are immediately translated into native user notifications. The application calls the web API service every N seconds, where N is a number between 1-86400 (inclusive). The alerts are pushed to the [Notification Center](https://support.apple.com/en-ca/HT204079) which means you have full control over their appearance and visibility. You can also pause the alerts using [Do Not Disturb](https://support.apple.com/en-ca/guide/mac-help/mchl999b7c1a/mac).

## Web API Service

After setting the hostname and credentials from the preferences window, the application will assume the existence of an endpoint that handles the following HTTP request: `GET <hostname>/alerts`. Below is an example of the response that the application is expecting. If the server wants to deliver a user notification, the response must contain a valid JSON object with at least two keys `title` and `text`, both of type String. An optional key `subtitle` forces the application to add a subtitle to the alert.

```json
HTTP/1.1 200 OK
Content-Type: application/json

{
    "title": "Title",
    "subtitle": "Subtitle",
    "text": "Informative Text"
}
```

The application also assumes the alert is marked as “read” once delivered by the server.

## Client Authentication

The application assumes the web API service understands [Basic Access Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication), but you are responsible to enforce the verification of the user credentials both pushing and fetching the alerts. The application combines the username and password with a single colon (`:`) _(make sure the username does not contains a colon)_. The resulting string is encoded into an octet sequence; the character set to use for this encoding is by default unspecified, as long as it is compatible with US-ASCII, but the server may suggest use of UTF-8 by sending the charset parameter. The resulting string is encoded using a variant of Base64. The authorization method and a space (e.g. "Basic ") is then prepended to the encoded string.

You can increase the level of security by restricting access to the server to a specific IP address.

## Multiple Clients

Delivery of the same alerts to multiple devices is out of the scope of this project. The application assumes each alert is unique and delivered once, but you can decide to implement a web API service that delivers the same alert to multiple devices by checking the `X-Unique-User-ID` HTTP header. In this scenario, you must create a queue of alerts for each device, then dequeue the alert from the queue that matches the user ID.

## Additional Details

You are free to implement the web API service in any programming language and data storage you are comfortable with.

However, because the application is limited to 86400 alerts per day _—as it only shows one per second—_ you should consider a simple solution, specially for the data storage. My suggestion is to use an in-memory data structure maybe on [Redis](https://en.wikipedia.org/wiki/Redis), [SQLite](https://en.wikipedia.org/wiki/SQLite), [CouchDB](https://en.wikipedia.org/wiki/Apache_CouchDB), [RethinkDB](https://en.wikipedia.org/wiki/RethinkDB), [Amazon ElasticCache](https://en.wikipedia.org/wiki/Amazon_ElastiCache), [Memcached](https://en.wikipedia.org/wiki/Memcached), [MongoDB](https://en.wikipedia.org/wiki/MongoDB) or any database engine you have access to.

You can self-host using [Amazon Web Services Free Tier](https://aws.amazon.com/free/), [Google Cloud Platform Free Tier](https://cloud.google.com/free/) or [Microsoft Azure Free Tier](https://azure.microsoft.com/en-us/free/).
