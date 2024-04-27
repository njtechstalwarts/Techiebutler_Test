//
//  EncodableExtension.swift
//  HipaaSafe
//
//  Created by maple on 03/02/21.
//

import Foundation

extension Encodable {
	func asDictionary() -> [String: Any] {
		do {
			let data = try JSONEncoder().encode(self)
			guard var dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return [:] }
            dictionary = dictionary.strippingNulls()
            return dictionary
		} catch {
            DLog(message: error)
		}
		return [:]
	}

	func asDictionary() -> [String: String] {
		do {
			let data = try JSONEncoder().encode(self)
			guard var dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else { return [:] }
            dictionary = dictionary.strippingNulls()
            return dictionary
		} catch {
            DLog(message: error)
		}
		return [:]
	}

    func asString() -> String {
        guard let data = try? JSONEncoder().encode(self) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}

protocol NullStripable {
    func strippingNulls() -> Self
}

extension Array: NullStripable {
    func strippingNulls() -> Self {
        return compactMap {
            DLog(message: $0.self)
            if isEmpty {
                return nil
            } else {
                switch $0 {
                case let strippable as NullStripable:
                    // the forced cast here is necessary as the compiler sees
                    // `strippable` as NullStripable, as we casted it from `Element`
                    return (strippable.strippingNulls() as! Element)
                case is NSNull:
                    return nil
                default:
                    if let arr = $0 as? NSArray {
                        if arr.count == 0 {
                            return nil
                        } else {
                            return $0
                        }
                    }
                    return $0
                }
            }
        }
    }
}

extension Dictionary: NullStripable {
    func strippingNulls() -> Self {
        return compactMapValues {
            DLog(message: $0.self)
            switch $0 {
            case let strippable as NullStripable:
                // the forced cast here is necessary as the compiler sees
                // `strippable` as NullStripable, as we casted it from `Value`
                return (strippable.strippingNulls() as! Value)
            case is NSNull:
                return nil
            default:
                DLog(message: type(of: $0))
                if let arr = $0 as? NSArray {
                    if arr.count == 0 {
                        return nil
                    } else {
                        return $0
                    }
                }
                return $0
            }
        }
    }
}
