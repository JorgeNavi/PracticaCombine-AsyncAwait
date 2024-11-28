
import Foundation

protocol TransformationsUseCaseProtocol {
    var repo: TransformationsRepositoryProtocol { get set }
    func getTransformations(id: String) async -> [TransformationsModel]
}

final class TransformationsUseCase: TransformationsUseCaseProtocol {
    var repo: TransformationsRepositoryProtocol
    
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformations())) {
        self.repo = repo
    }
    
    func getTransformations(id: String) async -> [TransformationsModel] {
        return await repo.getTransformations(id: id)
    }
}

final class TransformationsUseCaseFake: TransformationsUseCaseProtocol {
    var repo: TransformationsRepositoryProtocol
    
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformationsFake())) {
        self.repo = repo
    }
    
    func getTransformations(id: String) async -> [TransformationsModel] {
        return await repo.getTransformations(id: id)
    }

}
