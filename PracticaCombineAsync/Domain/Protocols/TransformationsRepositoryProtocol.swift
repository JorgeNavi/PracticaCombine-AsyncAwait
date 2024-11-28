
import Foundation

protocol TransformationsRepositoryProtocol {
    func getTransformations(id: String) async -> [TransformationsModel]
}
