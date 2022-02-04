import Foundation
import UIKit



class MenuPopUp: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var continueButton:  UIButton = {
        let button = UIButton()
        button.configure(title: LocalizeStrings.MenuPopUP.continueText)
        button.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var restartButton:  UIButton = {
        let button = UIButton()
        button.configure(title: LocalizeStrings.MenuPopUP.restart)
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
    
    private lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,
                                                   buttonStack])
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
        
    }
    
    
    
    private func animateOut() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
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
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    private func setupUserInterface() {
        self.addSubview(container)
        container.addSubview(buttonStack)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
            
            buttonStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant:  8),
            buttonStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant:  -8),
            buttonStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
