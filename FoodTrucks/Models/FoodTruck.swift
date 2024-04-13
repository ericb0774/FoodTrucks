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

extension FoodTruck {
    static var sampleTrucks: [FoodTruck] = {
        let json = """
            [
                {
                    "locationid": "1658363",
                    "applicant": "Treats by the Bay LLC",
                    "optionaltext": "Prepackaged Kettlecorn",
                    "location": "201 02ND ST",
                    "starttime": "6AM",
                    "endtime": "8PM",
                    "longitude": "-122.398191346440996",
                    "latitude": "37.786804480998804"
                },
                {
                    "locationid": "1741751",
                    "applicant": "San Pancho's Tacos",
                    "optionaltext": "Tacos, Burritos, Quesadillas, Tortas, Nachos, Hot Dogs,Soda, Water, Fruit Drinks",
                    "location": "491 BAY SHORE BLVD",
                    "starttime": "6AM",
                    "endtime": "10PM",
                    "longitude": "-122.406909482372015",
                    "latitude": "37.739576790778216"
                },
                {
                    "locationid": "1657804",
                    "applicant": "San Francisco Carts & Concessions, Inc. DBA Stanley's Steamers Hot Dogs",
                    "optionaltext": "Hot dogs, condiments, soft pretzels, soft drinks, coffee, cold beverages, pastries, bakery goods, cookies, ice cream, candy, soups, churros, chestnuts, nuts, fresh fruit, fruit juices, desserts, potato chips and popcorn.",
                    "location": "233 GEARY ST",
                    "starttime": "6AM",
                    "endtime": "12AM",
                    "longitude": "-122.407130420012038",
                    "latitude": "37.787443441472988"
                },
                {
                    "locationid": "1337786",
                    "applicant": "Giant Burrito",
                    "optionaltext": "Tacos, Burritos, Tostadas, Flautas, Tostadas, Tortas, Pozole Menudo",
                    "location": "353 BAY SHORE BLVD",
                    "starttime": "7AM",
                    "endtime": "6PM",
                    "longitude": "-122.405736586445613",
                    "latitude": "37.742140586467507"
                },
                {
                    "locationid": "1585473",
                    "applicant": "San Francisco Street Foods, Inc.",
                    "optionaltext": "Hot dogs, condiments, soft pretzels, soft drinks, coffee, cold beverages, pastries, bakery goods, cookies, ice cream, candy, soups, churros, chestnuts, nuts, fresh fruit, fruit juices, desserts, potato chips and popcorn.",
                    "location": "1 THE EMBARCADERO",
                    "starttime": "6AM",
                    "endtime": "12AM",
                    "longitude": "-122.388426441805734",
                    "latitude": "37.781846487320465"
                },
                {
                    "locationid": "1656382",
                    "applicant": "San Francisco Taco Truck",
                    "optionaltext": "Tacos, Tortas, Burritos",
                    "location": "345 WILLIAMS AVE",
                    "starttime": "7AM",
                    "endtime": "11PM",
                    "longitude": "-122.399162749748584",
                    "latitude": "37.730136110166313"
                },
                {
                    "locationid": "1585476",
                    "applicant": "San Francisco Street Foods, Inc.",
                    "optionaltext": "Hot dogs, condiments, soft pretzels, soft drinks, coffee, cold beverages, pastries, bakery goods, cookies, ice cream, candy, soups, churros, chestnuts, nuts, fresh fruit, fruit juices, desserts, potato chips and popcorn.",
                    "location": "100 POST ST",
                    "starttime": "6AM",
                    "endtime": "12AM",
                    "longitude": "-122.403692234115198",
                    "latitude": "37.788946003107128"
                }
            ]
            """.data(using: .utf8)

        return try! JSONDecoder().decode([FoodTruck].self, from: json!)
    }()
}

