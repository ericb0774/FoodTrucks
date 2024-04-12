//
//  FoodTruck.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import Foundation

///
/// A Food Truck model
///
/// Food truck data that is downloaded via the ApiClient is decoded into an
/// array of this model. Only the properties that are required for displaying
/// details about a food truck are included.
///
struct FoodTruck: Identifiable, Hashable {
    let id: Int
    let name: String
    let location: String
    let details: String?
    let startTime: String
    let endTime: String
    let latitude: Double
    let longitude: Double
}

extension FoodTruck: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "locationid"
        case name = "applicant"
        case location
        case details = "optionaltext"
        case startTime = "starttime"
        case endTime = "endtime"
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // id (locationid) is an int, but encoded as a string.
        var stringValue = try container.decode(String.self, forKey: .id)
        guard let idValue = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "expected id (locationid) to be convertible to an Int, but got: \(stringValue)")
        }
        id = idValue

        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        details = try container.decodeIfPresent(String.self, forKey: .details)
        startTime = try container.decode(String.self, forKey: .startTime)
        endTime = try container.decode(String.self, forKey: .endTime)

        // latitude and longitude are doubles, but encoded as strings.
        stringValue = try container.decode(String.self, forKey: .latitude)
        guard let latitudeValue = Double(stringValue) else {
            throw DecodingError.dataCorruptedError(forKey: .latitude, in: container, debugDescription: "expected latitude to be convertible to a Double, but got: \(stringValue)")
        }
        latitude = latitudeValue

        stringValue = try container.decode(String.self, forKey: .longitude)
        guard let longitudeValue = Double(stringValue) else {
            throw DecodingError.dataCorruptedError(forKey: .longitude, in: container, debugDescription: "expected longitude to be convertible to a Double, but got: \(stringValue)")
        }
        longitude = longitudeValue
    }
}
