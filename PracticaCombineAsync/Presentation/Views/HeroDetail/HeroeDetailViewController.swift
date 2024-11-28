import UIKit
import Combine

class HeroeDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var heroPhoto: UIImageView!
    @IBOutlet weak var infoHero: UITextView!
    @IBOutlet weak var transformationsContainer: UICollectionView!
    @IBOutlet weak var heroName: UILabel!
    

    private var viewModel: HeroDetailViewModel
    private var suscriptions = Set<AnyCancellable>()
    

    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        bindingUI()
        getTransformations()
    }
    

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
        
        transformationsContainer.register(
            UINib(nibName: "HeroeDetailCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HeroeDetailCollectionViewCell"
        )
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        transformationsContainer.collectionViewLayout = layout
    }
    
    private func bindingUI() {
        self.viewModel.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.transformationsContainer.reloadData()
            }
            .store(in: &suscriptions)
    }
    
    private func getTransformations() {
        Task {
            await self.viewModel.getTransformations()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroeDetailCollectionViewCell", for: indexPath) as? HeroeDetailCollectionViewCell else {
            fatalError("Error en la configuración de celda")
        }
        
        let transformation = viewModel.transformations[indexPath.item]
        cell.configure(with: transformation)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.transformations[indexPath.item]
        print("Selected transformation: \(transformation.name)")
    }
    
    
}

