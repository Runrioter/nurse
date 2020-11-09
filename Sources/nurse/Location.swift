//
//  Location.swift
//

struct Location: Codable {

    /// Name of the location
    var title: String

    /// Location type
    var locationType: String

    /// Comma separated lattitude and longitude e.g. "36.96,-122.02".
    var lattLong: LattLong

    /// Where On Earth ID
    var woeid: Int

    /// Distance - Only returned on a lattlong search
    var distance: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case lattLong = "latt_long"
        case woeid
        case distance
    }

    struct LattLong: Codable, CustomStringConvertible {

        private var lattitude: Double

        private var longitude: Double

        var description: String {
            return "<\(lattitude),\(longitude)>"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let lattLong = try container.decode(String.self)
            let lattAndLongSlice = lattLong.split(separator: ",")
            lattitude = Double(lattAndLongSlice[0])!
            longitude = Double(lattAndLongSlice[1])!
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode("\(lattitude),\(longitude)")
        }

    }
}
