//
//  NSProtocolInterpreter.swift
//  Nest
//
//  Created by Manfred Lau on 11/28/14.
//  Copyright (c) 2014 WeZZard. All rights reserved.
//

import Foundation

// @see: https://stackoverflow.com/a/18777565

/**
 `NSProtocolInterceptor` is a proxy which intercepts messages to the middle man
 which originally intended to send to the receiver.
 
 - Discussion: `NSProtocolInterceptor` is a class cluster which dynamically
 subclasses itself to conform to the intercepted protocols at the runtime.
 */
final public class NSProtocolInterceptor: NSObject {
  
  /// Returns the intercepted protocols
  public private(set) var interceptedProtocols: [Protocol] = []
  
  /// The receiver receives messages
  weak public var receiver: NSObjectProtocol?
  
  /// The middle man intercepts messages
  weak public var middleMan: NSObjectProtocol?
  
  private func doesSelectorBelongToAnyInterceptedProtocol(_ selector: Selector) -> Bool {
    for `protocol` in interceptedProtocols where sel_belongsToProtocol(selector, `protocol`) {
      return true
    }
    return false
  }
  
  /// Returns the object to which unrecognized messages should first be
  /// directed.
  public override func forwardingTarget(for selector: Selector!) -> Any? {
    if let middleMan = middleMan, middleMan.responds(to: selector) && doesSelectorBelongToAnyInterceptedProtocol(selector) {
      return middleMan
    }
    if let receiver = receiver, receiver.responds(to: selector) {
      return receiver
    }
    return super.forwardingTarget(for: selector)
  }
  
  /// Returns a Boolean value that indicates whether the receiver implements
  /// or inherits a method that can respond to a specified message.
  public override func responds(to selector: Selector) -> Bool {
    if let middleMan = middleMan, middleMan.responds(to: selector) && doesSelectorBelongToAnyInterceptedProtocol(selector) {
      return true
    }
    if let receiver = receiver, receiver.responds(to: selector) {
      return true
    }
    return super.responds(to: selector)
  }
  
  /**
   Create a protocol interceptor which intercepts a single Objecitve-C
   protocol.
   
   - Parameter     protocols:  An Objective-C protocol, such as
   UITableViewDelegate.self.
   */
  public class func forProtocol(_ aProtocol: Protocol) -> NSProtocolInterceptor {
    return forProtocols([aProtocol])
  }
  
  /**
   Create a protocol interceptor which intercepts a variable-length sort of
   Objecitve-C protocols.
   
   - Parameter     protocols:  A variable length sort of Objective-C protocol,
   such as UITableViewDelegate.self.
   */
  public class func forProtocols(_ protocols: Protocol...) -> NSProtocolInterceptor {
    return forProtocols(protocols)
  }
  
  /**
   Create a protocol interceptor which intercepts an array of Objecitve-C
   protocols.
   
   - Parameter     protocols:  An array of Objective-C protocols, such as
   [UITableViewDelegate.self].
   */
  public class func forProtocols(_ protocols: [Protocol]) -> NSProtocolInterceptor {
    var protocolNames = protocols.map { NSStringFromProtocol($0) }
    protocolNames.sort()
    let concatenatedName = protocolNames.joined(separator: ",")
    
    let theConcreteClass = concreteClass(protocols, concatenatedName: concatenatedName, salt: nil)
    
    let protocolInterceptor = theConcreteClass.init() as! NSProtocolInterceptor
    protocolInterceptor.interceptedProtocols = protocols
    
    return protocolInterceptor
  }
  
  /**
   Return a subclass of `NSProtocolInterceptor` which conforms to specified
   protocols.
   
   - Parameter     protocols:          An array of Objective-C protocols. The
   subclass returned from this function will conform to these protocols.
   
   - Parameter     concatenatedName:   A string which came from concatenating
   names of `protocols`.
   
   - Parameter     salt:               A UInt number appended to the class name
   which used for distinguishing the class name itself from the duplicated.
   
   - Discussion: The return value type of this function can only be
   `NSObject.Type`, because if you return with `NSProtocolInterceptor.Type`,
   you can only init the returned class to be a `NSProtocolInterceptor` but not
   its subclass.
   */
  private class func concreteClass(_ protocols: [Protocol], concatenatedName: String, salt: UInt?) -> NSObject.Type {
    let className: String = {
      let basicClassName = "_" + NSStringFromClass(NSProtocolInterceptor.self) + "_" + concatenatedName
      
      if let salt = salt {
        return basicClassName + "_\(salt)"
      } else {
        return basicClassName
      }
    }()
    
    let nextSalt = salt.map { $0 + 1 }
    
    if let `class` = NSClassFromString(className) {
      switch `class` {
      case let anInterceptorClass as NSProtocolInterceptor.Type:
        let isClassConformsToAllProtocols: Bool = {
          // Check if the found class conforms to the protocols
          for eachProtocol in protocols where !class_conformsToProtocol(anInterceptorClass, eachProtocol) {
            return false
          }
          return true
        }()
        
        if isClassConformsToAllProtocols {
          return anInterceptorClass
        } else {
          return concreteClass(protocols, concatenatedName: concatenatedName, salt: nextSalt)
        }
      default:
        return concreteClass(protocols, concatenatedName: concatenatedName, salt: nextSalt)
      }
    } else {
      let subclass = objc_allocateClassPair(NSProtocolInterceptor.self, className, 0) as! NSObject.Type
      
      for eachProtocol in protocols {
        class_addProtocol(subclass, eachProtocol)
      }
      
      objc_registerClassPair(subclass)
      
      return subclass
    }
  }
}

/**
 Returns true when the given selector belongs to the given protocol.
 */
public func sel_belongsToProtocol(_ selector: Selector, _ protocol: Protocol) -> Bool {
  for optionBits: UInt in 0..<(1 << 2) {
    let isRequired = optionBits & 1 != 0
    let isInstance = !(optionBits & (1 << 1) != 0)
    let methodDescription = protocol_getMethodDescription(`protocol`, selector, isRequired, isInstance)
    if !objc_method_description_isEmpty(methodDescription) {
      return true
    }
  }
  return false
}

public func objc_method_description_isEmpty(_ methodDescription: objc_method_description) -> Bool {
  let ptr = withUnsafePointer(to: methodDescription) { $0.withMemoryRebound(to: Int8.self, capacity: 8, { $0 }) }
  for offset in 0..<MemoryLayout<objc_method_description>.size {
    if ptr[offset] != 0 {
      return false
    }
  }
  return true
}
