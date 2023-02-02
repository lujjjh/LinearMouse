// MIT License
// Copyright (c) 2021-2023 Jiahao Lu

import Foundation
import SwiftUI

extension Scheme {
    struct Scrolling: Codable, OptionalBindable {
        var reverse: Bidirectional<Bool>?

        var distance: Bidirectional<Distance>?

        var scale: Bidirectional<Decimal>?

        var modifiers: Modifiers?
    }
}

extension Scheme.Scrolling {
    func merge(into scrolling: inout Self) {
        reverse?.merge(into: &scrolling.reverse)
        distance?.merge(into: &scrolling.distance)
        scale?.merge(into: &scrolling.scale)
        modifiers?.merge(into: &scrolling.modifiers)
    }

    func merge(into scrolling: inout Self?) {
        if scrolling == nil {
            scrolling = Self()
        }

        merge(into: &scrolling!)
    }
}

extension Scheme.Scrolling {
    enum Direction {
        case vertical, horizontal
    }

    struct Bidirectional<T: Codable & Equatable>: OptionalBindable {
        private var value: Value

        struct Value: Codable {
            var vertical: T?
            var horizontal: T?
        }

        init() {
            self.init(vertical: nil, horizontal: nil)
        }

        init(vertical: T? = nil, horizontal: T? = nil) {
            value = .init(vertical: vertical, horizontal: horizontal)
        }

        func merge(into: inout Self) {
            if let vertical = value.vertical {
                into.value.vertical = vertical
            }

            if let horizontal = value.horizontal {
                into.value.horizontal = horizontal
            }
        }

        func merge(into: inout Self?) {
            if into == nil {
                into = Self()
            }

            merge(into: &into!)
        }
    }
}

extension Binding {
    func optionalBinding<T>(direction: Scheme.Scrolling.Direction) -> Binding<T?>
        where Value == Scheme.Scrolling.Bidirectional<T>? {
        switch direction {
        case .vertical:
            return optionalBinding(\.vertical)
        case .horizontal:
            return optionalBinding(\.horizontal)
        }
    }
}

extension Scheme.Scrolling.Bidirectional {
    var vertical: T? {
        get {
            value.vertical
        }
        set {
            value.vertical = newValue
        }
    }

    var horizontal: T? {
        get {
            value.horizontal
        }
        set {
            value.horizontal = newValue
        }
    }
}

extension Scheme.Scrolling.Bidirectional: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            value = try container.decode(Value.self)
        } catch {
            let v = try container.decode(T?.self)
            value = .init(vertical: v, horizontal: v)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        if value.vertical == value.horizontal {
            try container.encode(value.vertical)
            return
        }

        try container.encode(value)
    }
}
