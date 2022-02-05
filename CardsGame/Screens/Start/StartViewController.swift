import UIKit

class StartViewController: UIViewController {
    
    // MARK: Views
    private lazy var playGameButton:  CustomButton = {
        let button = CustomButton(title: LocalizeStrings.StartViewController.play)
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
    
    @objc private func tapPlayButton() {
        let controller = GameViewController()

         let transition = pushUpViewControllerFromBottom()
         self.navigationController?.view.layer.add(transition, forKey: nil)
         self.navigationController?.pushViewController(controller, animated: false)
    }
    
    private func pushUpViewControllerFromBottom() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        return transition
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .systemGray6
        view.addSubview(playGameButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            playGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.Layout.padding),
            playGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.Layout.padding),
            playGameButton.heightAnchor.constraint(equalToConstant: Constants.UI.Layout.buttonHeight),
        ])
    }
}

