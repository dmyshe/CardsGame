import Foundation
import UIKit


class GameViewController: UIViewController {
    
    var viewModel = GameViewModel()
    
    // MARK: Views
    private lazy var spinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: Constants.UI.Image.leftArrow,
                                     style: .plain,
                                     target: navigationController,
                                     action: #selector(UINavigationController.popViewController(animated:)))
        return button
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: Constants.UI.Image.gear,
                                     style: .plain,
                                     target: self,
                                     action: #selector(openMenu))
        button.customView?.isHidden = true
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray6
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        makeConstraints()
        viewModel.createNewRound()
        viewModel.delegate = self
        spinner.style = .large
        spinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.spinner.stopAnimating()
            self.collectionView.isHidden = false
            self.title = self.viewModel.setTitle
            self.navigationItem.rightBarButtonItem = self.settingsButton
        }
    }
    
    @objc func openMenu() {
        let controller = MenuPopUp()
        controller.delegate = self
        view.addSubview(controller)
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .systemGray6

        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = nil
        
        view.addSubview(spinner)
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.UI.Layout.defaultPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.Layout.defaultPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.Layout.defaultPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UICollectionViewDataSource
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.game.cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        
        let card = viewModel.game.cardsArray[indexPath.row]
        cell.configureCell(card: card)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            cell?.flipUp()
            
            if viewModel.firstFlippedCardIndex == nil {
                viewModel.firstFlippedCardIndex = indexPath.row
            } else {
                viewModel.secondFlippedCardIndex = indexPath.row
                viewModel.checkForMatch()
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension  GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.UI.Layout.collectionViewCellWidth,
                      height: Constants.UI.Layout.collectionViewCellHeight)
    }
}

// MARK: GameViewModelDelegate
extension GameViewController: GameViewModelDelegate {
    
    func restartLevel() {
        self.spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.collectionView.reloadData()
        }
    }
    
    func showGameOverPopup() {
        let controller = GameOverPopup()
        view.addSubview(controller)
    }
    
    func reloadData() {
        collectionView.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.title = self.viewModel.setTitle
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
            self.collectionView.isHidden = false
        }
    }
    
    func cardFlipDown() {
        if let  firstFlippedCardIndex = viewModel.firstFlippedCardIndex,
           let secondFlippedCardIndex = viewModel.secondFlippedCardIndex,
           let cardOneCell = collectionView.cellForItem(at: IndexPath(row: firstFlippedCardIndex, section: 0)) as? CardCollectionViewCell,
           let cardTwoCell = collectionView.cellForItem(at: IndexPath(row: secondFlippedCardIndex, section: 0)) as? CardCollectionViewCell {
            
            cardOneCell.flipDown()
            cardTwoCell.flipDown()
        }
    }
    
    func removeCard() {
        if let  firstFlippedCardIndex = viewModel.firstFlippedCardIndex,
           let secondFlippedCardIndex = viewModel.secondFlippedCardIndex,
           let cardOneCell = collectionView.cellForItem(at: IndexPath(row: firstFlippedCardIndex, section: 0)) as? CardCollectionViewCell,
           let cardTwoCell = collectionView.cellForItem(at: IndexPath(row: secondFlippedCardIndex, section: 0)) as? CardCollectionViewCell {
            
            cardOneCell.remove()
            cardTwoCell.remove()
        }
    }
    
}

// MARK: MenuPopUpDelegate
extension GameViewController: MenuPopUpDelegate {
    func restartRound() {
        viewModel.createNewRound()
        reloadData()
    }
}

