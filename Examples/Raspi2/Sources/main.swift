import SwiftyGPIO
import DS1307
import Foundation

let i2cs = SwiftyGPIO.hardwareI2Cs(for:.RaspberryPi2)!
let i2c = i2cs[1]

let ds = DS1307(i2c)

ds.setTime(hours: 16, minutes: 25, seconds: 00, date: 10, month: 5, year: 17)
ds.start()

var (hours, minutes, seconds, date, month, year) = ds.getTime()
print("\(year)/\(month)/\(date) \(hours):\(minutes):\(seconds)")

sleep(10)

(hours, minutes, seconds, date, month, year) = ds.getTime()
print("\(year)/\(month)/\(date) \(hours):\(minutes):\(seconds)")
