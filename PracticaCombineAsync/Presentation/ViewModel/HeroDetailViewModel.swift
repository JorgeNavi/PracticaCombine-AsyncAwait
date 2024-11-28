import Foundation


final class HeroDetailViewModel {
    private let useCase: TransformationsUseCaseProtocol

    @Published var transformations: [TransformationsModel] = []
    let hero: HerosModel
    
    init(hero: HerosModel, useCase: TransformationsUseCaseProtocol = TransformationsUseCase()) {
        self.useCase = useCase
        self.hero = hero
        Task {
            await getTransformations()
        }
    }
    
    func getTransformations() async {
        do {
            let result = await useCase.getTransformations(id: hero.id.uuidString)
            DispatchQueue.main.async { [weak self] in
                self?.transformations = result.isEmpty ? [] : result
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.transformations = [] // En caso de error, lista vacía
            }
        }
    }
}
