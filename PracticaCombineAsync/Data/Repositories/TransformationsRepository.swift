
import Foundation

final class TransformationsRepository: TransformationsRepositoryProtocol {
    private var network: NetworkTransformationsProtocol
    
    init(network: NetworkTransformationsProtocol) {
        self.network = network
    }
    
    func getTransformations(id: String) async -> [TransformationsModel] {
        return await network.getTransformations(id: id)
    }
}

final class TransformationsRepositoryFake: TransformationsRepositoryProtocol {
    private var network: NetworkTransformationsProtocol
    
    init(network: NetworkTransformationsProtocol = NetworkTransformationsFake()) {
        self.network = network
    }
    
    func getTransformations(id: String) async -> [TransformationsModel] {
        return await network.getTransformations(id: id)
    }
}

