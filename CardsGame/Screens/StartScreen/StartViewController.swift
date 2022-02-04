import UIKit

class StartViewController: UIViewController {
    
    // MARK: Views
    private lazy var playGameButton:  UIButton = {
        let button = UIButton()
        button.configure(title: LocalizeStrings.StartViewController.play)
        button.addTarget(self, action: #selector(tapPlayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        makeConstraints()
    }
    

    override func viewWillAppear(_ animated: Bool) {
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .systemGray6
        view.addSubview(playGameButton)
    }
    
   @objc private func tapPlayButton() {
       let controller = GameViewController()

        let transition = CATransition()
       transition.duration = 0.4
       transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(controller, animated: false)
   }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            playGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.Layout.padding),
            playGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.Layout.padding),
            
            playGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


}

