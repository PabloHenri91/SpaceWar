//
//  Event.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/29/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

class Event<T> {
    typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [EventHandler]()
    
    func addHandler(_ handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    func raise(_ data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
