import Foundation
import UIKit

class CustomButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(title: String) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        config.background.backgroundColor = Constants.UI.Color.customYellow
        config.cornerStyle = .large
        
        self.configuration = config
        self.setTitleColor(.black, for: .normal)
        
    }
}
