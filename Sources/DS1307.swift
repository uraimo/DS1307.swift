/*
   DS1307.swift

   Copyright (c) 2017 Umberto Raimondi
   Licensed under the MIT license, as follows:

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.)
*/

import SwiftyGPIO  //Comment this when not using the package manager
import Foundation  //Needed for getDate/setDate


public class DS1307{
   var i2c: I2CInterface
   let address = 0x68

   public init(_ i2c: I2CInterface) {
       self.i2c = i2c
   }

   public var seconds: Int {
      get{
         let rv = i2c.readByte(address, command: 0)
         return Int(rv & 0xF + ((rv & 0x70)>>4) * 10)
      }
      set{
         let enable = UInt8(seconds) & (~0x80)
         let v = (newValue/10) << 4 + (newValue % 10)
         i2c.writeByte(address, command: 0, value: enable|UInt8(v))
      }
   }

   public var minutes: Int {
      get{
         let rv = i2c.readByte(address, command: 1)
         return Int(rv & 0xF + ((rv & 0x70)>>4) * 10)
      }
      set{
         let v = (newValue/10) << 4 + (newValue % 10)
         i2c.writeByte(address, command: 1, value: UInt8(v))
      }
   }

   public var hours: Int {
      get{
         let rv = i2c.readByte(address, command: 2)
         if rv & 0x40 > 1 {
            // 24h
            return Int(rv & 0xF + ((rv & 0x30)>>4) * 10)
         }else{
            // AM/PM
            return Int(rv & 0xF + ((rv & 0x20 == 0) ? 12 : 0) )
         }
      }
      set{
         let v = 0x40 + (newValue/10) << 4 + (newValue % 10)
         i2c.writeByte(address, command: 2, value: UInt8(v))
      }
   }

   // Set/get for day of the week not necessary i guess

   public var date: Int {
      get{
         let rv = i2c.readByte(address, command: 4)
         return Int(rv & 0xF + ((rv & 0x30)>>4) * 10)
      }
      set{
         let v = (newValue/10) << 4 + (newValue % 10)
         i2c.writeByte(address, command: 4, value: UInt8(v))
      }
   }

   public var month: Int {
      get{
         let rv = i2c.readByte(address, command: 5)
         return Int(rv & 0xF + ((rv & 0x10)>>4) * 10)
      }
      set{
         let v = (newValue/10) << 4 + (newValue % 10)
         i2c.writeByte(address, command: 5, value: UInt8(v))   
      }
   }

   public var year: Int {
      get{
         let rv = i2c.readByte(address, command: 6)
         return Int(rv & 0xF + ((rv & 0xF0)>>4) * 10)
      }
      set{
         let v = (newValue/10) << 4 + (newValue % 10)
         i2c.writeByte(address, command: 6, value: UInt8(v))
      }
   }

   public func start() {
      let s = UInt8(seconds)
      seconds = Int(s & (~0x80))
   }

   public func stop() {
      let s = UInt8(seconds)
      seconds = Int(s | 0x80)
   }

   public func getTime() -> (hours: Int, minutes: Int, seconds: Int, date: Int, month: Int, year: Int) {
      return (self.hours, self.minutes, self.seconds, self.date, self.month, self.year)
   }

   public func getDate() -> Date {
      let formatter = DateFormatter()
      formatter.dateFormat = "yy/MM/dd HH:mm"
      let (year,month,date,hours,minutes,seconds) = (self.year,self.month,self.date,self.hours,self.minutes,self.seconds)
      let dateStr = String(format:"%02d/%02d/%02d %02d:/%02d:%02d",
                           year,month,date,hours,minutes,seconds)
      return formatter.date(from: dateStr)!
   }

   public func setTime(hours: Int, minutes: Int, seconds: Int, date: Int, month: Int, year: Int) {
      self.year = year
      self.month = month
      self.date = date
      self.hours = hours
      self.minutes = minutes
      self.seconds = seconds
   }

   public func setDate(_ date: Date) {
      let calendar = Calendar.current

      let hours = calendar.component(.hour, from: date)
      let minutes = calendar.component(.minute, from: date)
      let seconds = calendar.component(.second, from: date)
      let year = calendar.component(.year, from: date)
      let month = calendar.component(.month, from: date)
      let date = calendar.component(.day, from: date)
      self.year = year
      self.month = month
      self.date = date
      self.hours = hours
      self.minutes = minutes
      self.seconds = seconds
   }

   // Square wave control register not implemented
}
