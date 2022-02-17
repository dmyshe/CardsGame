import Foundation
import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CardCollectionViewCell"
    var card: Card?
  
    // MARK: Views
    private lazy var frontImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.UI.Image.backImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(card:Card) {
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched  {
            backImageView.alpha = 0
            frontImageView.alpha = 0
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }

        card.isFlipped ? flipUp(speed: 0) : flipDown(speed: 0, delay: 0)
    }
    
    func flipUp(speed: TimeInterval = 0.3) {

        UIView.transition(from: backImageView,
                          to: frontImageView,
                          duration: speed,
                          options: [.showHideTransitionViews,.transitionFlipFromLeft],
                          completion: nil)

        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        card?.isFlipped = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.frontImageView,
                              to: self.backImageView,
                              duration: speed,
                              options: [.showHideTransitionViews,.transitionFlipFromLeft],
                              completion: nil)
        }
    }
    
    func remove() {
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
    
    private func setupUserInterface() {
        addSubviewForAutoLayout(frontImageView)
        addSubviewForAutoLayout(backImageView)
    }
    
   private func makeConstraints() {
        NSLayoutConstraint.activate([
            frontImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.size.height),
            frontImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.size.width),
           
            backImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.size.height),
            backImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.size.width)
        ])
    }
    
}
