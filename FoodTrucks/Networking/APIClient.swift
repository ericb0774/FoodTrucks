//
//  APIClient.swift
//  FoodTrucks
//
//  Created by Eric Baker on 21.Apr.2022.
//

import Foundation

///
/// Network API client for San Francisco food truck data.
///
struct APIClient {
    enum DownloadError: Error {
        case invalidUrl
        case invalidResponse
        case serverError(_ statusCode: Int)
    }

    ///
    /// Downloads info for food trucks that are in operation during the given
    /// date/time in the San Francisco time zone.
    ///
    /// - Parameter date: The date/time to check for operating food trucks.
    /// - Returns: An array of FoodTruck models.
    ///
    func downloadFoodTruckList(availableAt date: Date = .now) async throws -> [FoodTruck] {
        guard var urlComponents = URLComponents(string: "https://data.sfgov.org/resource/jjew-r69b.json") else {
            throw DownloadError.invalidUrl
        }

        // The server returns time ranges in San Francisco's time zone. We
        // therefore ensure our time is adjusted to match.
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "America/Los_Angeles")

        // Extract 24-hour and minute from date.
        df.dateFormat = "HH:mm"
        let time24 = df.string(from: date)

        // Extract weekday name from date.
        df.dateFormat = "EEEE"
        let dayName = df.string(from: date)

        urlComponents.queryItems = [
            // Request only data needed to fill our FoodTruck model.
            URLQueryItem(name: "$select", value: "locationid,applicant,optionaltext,location,starttime,endtime,longitude,latitude"),

            // Filter food trucks that are available during given date. Let the
            // server do the work.
            URLQueryItem(name: "$where", value: "dayofweekstr == '\(dayName)' and start24 <= '\(time24)' and end24 > '\(time24)'")
        ]

        guard let url = urlComponents.url else {
            throw DownloadError.invalidUrl
        }

        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeInterval(20))

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else { throw DownloadError.invalidResponse }
        guard httpResponse.statusCode == 200 else { throw DownloadError.serverError(httpResponse.statusCode) }

        let jsonDecoder = JSONDecoder()
        let foodTrucks = try jsonDecoder.decode([FoodTruck].self, from: data)
        return foodTrucks
    }
}
