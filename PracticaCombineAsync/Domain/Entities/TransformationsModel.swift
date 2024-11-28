import Foundation

struct TransformationsModel: Codable {
    
    var id: UUID
    var name: String
    var description: String
    var photo: String
    
}

struct TransformationsModelRequest: Codable {
    
    var id: String
}
