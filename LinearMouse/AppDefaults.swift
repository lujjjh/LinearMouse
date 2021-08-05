//
//  Settings.swift
//  LinearMouse
//
//  Created by lujjjh on 2021/6/12.
//

import SwiftUI

class AppDefaults: ObservableObject {
    public static let shared = AppDefaults()

    @AppStorageCompat(wrappedValue: true, "reverseScrollingOn") var reverseScrollingOn: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat(wrappedValue: true, "linearScrollingOn") var linearScrollingOn: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat(wrappedValue: 3, "scrollLines") var scrollLines: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat(wrappedValue: true, "linearMovementOn") var linearMovementOn: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat(wrappedValue: true, "universalBackForwardOn") var universalBackForwardOn: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat(wrappedValue: true, "showInMenuBar") var showInMenuBar: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat("modifiers.command.action") var modifiersCommandAction = ModifierKeyAction(type: .noAction, speedFactor: 5.0) {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat("modifiers.shift.action") var modifiersShiftAction = ModifierKeyAction(type: .noAction, speedFactor: 2.0) {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat("modifiers.alternate.action") var modifiersAlternateAction = ModifierKeyAction(type: .noAction, speedFactor: 1.0) {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorageCompat("modifiers.control.action") var modifiersControlAction = ModifierKeyAction(type: .noAction, speedFactor: 0.2) {
        willSet {
            objectWillChange.send()
        }
    }
}
