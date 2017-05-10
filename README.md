# DS1307.swift

*A Swift library for the DS1307(also DS1302 and DS3231 w/o enhanced functions)  I2C Real-Time Clock*

<p>
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux-only" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/DS1307.swift/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>
 

# Summary

This library can configure a DS1307 RTC clock and once it's running can retrieve the current date and time.

This component is powered with 5V and requires a 32.768kHz Quartz Crystal oscillator to operate. It exposes an I2C interface that this library uses to interact with it.

![DS1307 diagram](https://github.com/uraimo/DS1307.swift/raw/master/ds1307.png)

If you are not using a backup battery with this RTC, remember to connect Vbatt to GND.

## Supported Boards

Every board supported by [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO): RaspberryPis, BeagleBones, C.H.I.P., etc...

To use this library, you'll need a Linux ARM board with Swift 3.x.

The example below will use a RaspberryPi 2 board but you can easily modify the example to use one the other supported boards, a full working demo projects for the RaspberryPi2 is available in the `Examples` directory.

## Usage

The first thing we need to do is to obtain an instance of `I2CInterface` from SwiftyGPIO and use it to initialize the `DS1307` object:

```swift
import SwiftyGPIO
import DS1307

let i2cs = SwiftyGPIO.hardwareI2Cs(for:.RaspberryPi2)!
let i2c = i2cs[0]

let ds = DS1307(i2c)
```

Once you have an instance of the DS1307 object, you can set and get the time as individual components (day, month, year[0-99], hours, minutes, seconds) or as a Foundation's Date or all the components in one go:

```swift
//Properties of DS1307 (all gettable/settable individually):
//year,month,date,hours,minutes,seconds

ds.setTime(hours: 16, minutes: 25, seconds: 00, date: 10, month: 5, year: 17)
ds.start()

var (hours, minutes, seconds, date, month, year) = ds.getTime()
print("\(year)/\(month)/\(date) \(hours):\(minutes):\(seconds)")

sleep(10)

(hours, minutes, seconds, date, month, year) = ds.getTime()
print("\(year)/\(month)/\(date) \(hours):\(minutes):\(seconds)")

//Also available:
//
//ds.setDate(Date())
//let now = ds.getDate()
```

The functions `start()` and `stop()` resume or pause the clock.

A complete example is available under `Examples/`


## Installation

Please refer to the [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO) readme for Swift installation instructions.

Once your board runs Swift, if your version support the Swift Package Manager, you can simply add this library as a dependency of your project and compile with `swift build`:

```swift
  let package = Package(
      name: "MyProject",
      dependencies: [
        .Package(url: "https://github.com/uraimo/DS1307.swift.git", majorVersion: 1),
      ]
  ) 
```

The directory `Examples` contains sample projects that uses SPM, compile it and run the sample with `./.build/debug/TestRTC`.

If SPM is not supported, you'll need to manually download the library and its dependencies: 

    wget https://raw.githubusercontent.com/uraimo/DS1307.swift/master/Sources/DS1307.swift https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/Sources/SwiftyGPIO.swift https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/Sources/Presets.swift https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/Sources/I2C.swift https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/Sources/SunXi.swift  

And once all the files have been downloaded, create an additional file that will contain the code of your application (e.g. main.swift). When your code is ready, compile it with:

    swiftc *.swift

The compiler will create a **main** executable.

