import Foundation
import UIKit


class GameViewController: UIViewController {
    
    var viewModel = GameViewModel()
    
    // MARK: Views
    private lazy var spinner = UIActivityIndicatorView()
    
    private lazy  var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .red
        progressView.progressTintColor = .systemBlue
        progressView.setProgress(0, animated: false)
        progressView.isHidden = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
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
                                     action: #selector(openSettings))
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
        viewModel.generateCardsForGame()
        
        spinner.style = .large
        spinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.spinner.hidesWhenStopped = true
            self.spinner.stopAnimating()
            self.collectionView.isHidden = false
            self.navigationItem.rightBarButtonItem = self.settingsButton
        }
        
    }
    
    @objc func openSettings() {
        let controller = MenuPopUp()
        view.addSubview(controller)
    }
    
    private func setupUserInterface() {        
        view.backgroundColor = .systemGray6
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = nil
        navigationController?.interactivePopGestureRecognizer?.delegate = self
       
        view.addSubview(progressView)
        navigationItem.titleView = progressView
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
        viewModel.cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell

        let card = viewModel.cardsArray[indexPath.row]
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
                viewModel.firstFlippedCardIndex = indexPath
            } else {
                viewModel.checkForMatch(indexPath, in: collectionView)
            }
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout
extension  GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 150, height: 150)
       }
}

// MARK: UIGestureRecognizerDelegate
extension GameViewController:  UIGestureRecognizerDelegate {
    
}


extension GameViewController: GameViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
}
