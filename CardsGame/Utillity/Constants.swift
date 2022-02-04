import Foundation
import UIKit

struct Constants {

    struct UI {
        struct Layout {
            static let padding: CGFloat = 64
            static let defaultPadding: CGFloat = 16
            static let contentSpacing: CGFloat = 4 
        }
        
        struct Image {
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
