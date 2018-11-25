#  SwiftLogger

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/dotsau/SwiftLogger/blob/master/LICENSE)

A logging framework written in Swift

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

```ruby
github 'dotsau/SwiftLogger'
```

### Manual

Drop `SwiftLogger` folder in your project. When you migrate your project to a new Swift version, SwiftLogger will migrate along with your code. Might be the best approach, cause I might not be interested in updating this thing in timely manner. 

## Usage

In your `AppDelegate.swift`:

```swift
...
import SwiftLogger

let log = SwiftLogger(environment: "production")
...

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: []) {
        ...
        log.addDestination(ConsoleDestination())
        log.addDestination(GELFDestination(endpoint: URL(string: "https://my-graylog-host.com")!))
    }
```

In your whatever:

```swift
log.trace("Move along, nothing interesting here")
log.debug("Hey, this might be interesting")
log.info("Something interesting has happened")
log.warning("It's worrying me!")
log.error("Abort! Abort!")
log.fatal("Aargh!")
```

SwiftLogger uses destinations to write log payloads. Offered completely for free are:
* `ConsoleDestination`. You know what it does.
* `LogstashDestination`. Sends the payload to a Logstash endpoint.
* `GELFDestination`. Sends the payload to any GELF-accepting endpoint.

*NOTE*: `LogstashDestination` and `GELFDestination` don't have any security/credentials support as is, since there are so many ways to secure the endpoints. But those classes are marked as `open`, so you can subclass them like this:

```swift
class BasicAuthLogstashDestination: LogstashDestination {
    var token: String

    init(endpoint: URL, token: String) {
        self.token = token
        super.init(endpoint: endpoint)
    }

    override var configuration: URLSessionConfiguration {
        let conf = super.configuration
        conf.httpAdditionalHeaders?["Authentication"] = "Basic \(token)"
        
        return conf
    }
}
```

## Contributions

Knock yourself out.

## License

[MIT](https://github.com/dotsau/SwiftLogger/blob/master/LICENSE)
