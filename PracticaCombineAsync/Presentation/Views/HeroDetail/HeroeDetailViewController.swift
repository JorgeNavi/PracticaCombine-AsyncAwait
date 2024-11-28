import UIKit
import Combine

class HeroeDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var heroPhoto: UIImageView!
    @IBOutlet weak var infoHero: UITextView!
    @IBOutlet weak var transformationsContainer: UICollectionView!
    @IBOutlet weak var heroName: UILabel!
    
    // MARK: - Properties
    private var viewModel: HeroDetailViewModel
    private var suscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        bindingUI()
        fetchTransformations()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        self.heroName.text = self.viewModel.hero.name
        self.infoHero.text = self.viewModel.hero.description
        
        if let url = URL(string: viewModel.hero.photo) {
            self.heroPhoto.loadImageRemote(url: url)
        }
    }
    
    private func configureCollectionView() {
        transformationsContainer.dataSource = self
        transformationsContainer.delegate = self
        
        // Registrar la celda personalizada
        transformationsContainer.register(
            UINib(nibName: "HeroeDetailCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HeroeDetailCollectionViewCell"
        )
        
        // Configurar layout del UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120) // Ajustar tamaño de las celdas
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        transformationsContainer.collectionViewLayout = layout
    }
    
    // MARK: - Bindings
    private func bindingUI() {
        // Vincular transformaciones del ViewModel al CollectionView
        self.viewModel.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.transformationsContainer.reloadData()
            }
            .store(in: &suscriptions)
    }
    
    // MARK: - Fetch Data
    private func fetchTransformations() {
        Task {
            await self.viewModel.getTransformations()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroeDetailCollectionViewCell", for: indexPath) as? HeroeDetailCollectionViewCell else {
            fatalError("Could not dequeue HeroeDetailCollectionViewCell")
        }
        
        let transformation = viewModel.transformations[indexPath.item]
        cell.configure(with: transformation)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate (Opcional)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.transformations[indexPath.item]
        print("Selected transformation: \(transformation.name)")
    }
}

