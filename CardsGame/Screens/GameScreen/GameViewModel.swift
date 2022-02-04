import Foundation
import UIKit

protocol GameViewModelDelegate: AnyObject {
    func reloadData()
}

class GameViewModel {
    
    weak var delegate: GameViewModelDelegate?
    
    var cardsArray = [Card]()
    var firstFlippedCardIndex: IndexPath?
    var game = Game()
    var numberOfCards = 4
    
    func generateCardsForGame() {
        cardsArray = self.generateCards()
        cardsArray.shuffle()
    }
    
    private func generateCards() -> [Card] {
        var generatedNumbers = [Int]()
        var generatedCards = [Card]()
        
        while generatedNumbers.count < numberOfCards {
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                let cardOne = Card()
                let cardTwo = Card()
                
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCards += [cardOne, cardTwo]
                
                generatedNumbers.append(randomNumber)
            }
        }
        return generatedCards
    }
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath, in collectionView: UICollectionView) {
        
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell

        if cardOne.imageName == cardTwo.imageName {
 
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkForGameEnd()
        }
        else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        for card in cardsArray {
            if card.isMatched == false {
                game.isWin = false
                break
            }
        }
        
        if game.isWin == true && game.round != 3 {
            print("win")
            game.round += 1
            numberOfCards += 1
            delegate?.reloadData()
        }
    }
}
