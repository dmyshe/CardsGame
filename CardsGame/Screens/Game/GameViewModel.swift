import Foundation
import UIKit


protocol GameViewModelDelegate: AnyObject {
    func reloadData()
    func cardFlipDown()
    func removeCard()
}

class GameViewModel {
    
    weak var delegate: GameViewModelDelegate?
    
    var game = Game()
    var firstFlippedCardIndex: Int?
    var secondFlippedCardIndex: Int?
   
    func createNewRound() {
        game.cardsArray = generateCards(with: game.numberOfCards)
        game.cardsArray.shuffle()
    }
    
    func checkForMatch(_ secondFlippedCardIndex: Int) {
        guard let firstFlippedCardIndex = firstFlippedCardIndex else { return }

        let cardOne = game.cardsArray[firstFlippedCardIndex]
        let cardTwo = game.cardsArray[secondFlippedCardIndex]

        if cardOne.imageName == cardTwo.imageName {
            cardOne.isMatched = true
            cardTwo.isMatched = true
            delegate?.removeCard()

            let remainedCards = game.cardsArray.filter { !$0.isMatched }
            if remainedCards.isEmpty {
                checkForGameOver()
            }
        }
        else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            delegate?.cardFlipDown()

        }
        self.firstFlippedCardIndex = nil
    }

    func checkForGameOver() {
        if  game.round < 3 {
            game.round += 1
            game.numberOfCards += 1
            createNewRound()
            delegate?.reloadData()
        } else {
            print("end")
        }
    }
 
    private func generateCards(with number: Int) -> [Card] {
        var generatedNumbers = [Int]()
        var generatedCards = [Card]()
        
        while generatedNumbers.count < number {
            let randomNumber = Int.random(in: 1...13)
            
            if !generatedNumbers.contains(randomNumber) {
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
}
