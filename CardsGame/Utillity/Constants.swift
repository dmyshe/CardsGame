import Foundation
import UIKit

struct Constants {
    
    struct UI {
        struct Layout {
            static let padding: CGFloat = 64
            static let defaultPadding: CGFloat = 16
            static let contentSpacing: CGFloat = 4
            
            static let defaultOffset: CGFloat = 8
            static let buttonStackHeight: CGFloat = 100
            static let buttonHeight: CGFloat = 50
            static let collectionViewCellHeight: CGFloat = 120
            static let collectionViewCellWidth: CGFloat = 120
        }
        
        struct Image {
            static let backImage = UIImage(named: "back")
            
            static let leftArrow: UIImage = {
                let image = UIImage(systemName: "arrow.left" ,withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))!.withTintColor(.black, renderingMode: .alwaysOriginal)
                return image
            }()
            
            static let gear: UIImage = {
                let image = UIImage(systemName: "gear" ,withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))!.withTintColor(.black, renderingMode: .alwaysOriginal)
                return image
            }()
        }
        
        struct Color {
            static let customYellow = UIColor(named: "customYellow")
        }
    }
}
