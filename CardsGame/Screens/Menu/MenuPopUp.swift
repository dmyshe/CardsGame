import Foundation
import UIKit

protocol MenuPopUpDelegate: AnyObject {
    func restartRound()
}

class MenuPopUp: UIView {
    
    weak var delegate: MenuPopUpDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeStrings.MenuPopUP.menu
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var continueButton:  UIButton = {
        let button = CustomButton(title: LocalizeStrings.MenuPopUP.continueText)
        button.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var restartButton:  UIButton = {
        let button = CustomButton(title: LocalizeStrings.MenuPopUP.restart)
        button.addTarget(self, action: #selector(restartRound), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var container : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [continueButton,restartButton])
        stack.spacing = Constants.UI.Layout.defaultPadding
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        setupUserInterface()
        makeConstraints()
        animateIn() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func continueGame() {
        animateOut()
    }
    
    @objc func restartRound() {
        animateOut()
        delegate?.restartRound()
    }

    private func animateOut() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1, options: .curveEaseIn,
                       animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y:  -self.frame.height)
            self.alpha = 0
        }) { complete in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    private func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y:  -self.frame.height)
        self.alpha = 1
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    private func setupUserInterface() {
        addSubview(container)
        container.addSubview(buttonStack)
        container.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.UI.Layout.defaultPadding),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            buttonStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            buttonStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant:  Constants.UI.Layout.defaultOffset),
            buttonStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant:  -Constants.UI.Layout.defaultOffset),
            buttonStack.heightAnchor.constraint(equalToConstant: Constants.UI.Layout.buttonStackHeight)
        ])
    }
}
