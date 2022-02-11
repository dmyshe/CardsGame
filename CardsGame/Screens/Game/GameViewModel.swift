import Foundation

protocol GameViewModelDelegate: AnyObject {
    func reloadData()
    func flipDownCard(at firstIndex: Int, and secondIndex: Int)
    func removeCard(at firstIndex: Int, and secondIndex: Int )
    func showGameOverPopup()
}

class GameViewModel {
    
    weak var delegate: GameViewModelDelegate?
    
    var game = Game()
    private var firstFlippedCardIndex: Int?
    private var secondFlippedCardIndex: Int?
    var setTitle: String {
        "\(self.game.round)/3"
    }
    
    func createNewRound() {
        game.cardsArray = generateCards(with: game.numberOfCards)
        game.cardsArray.shuffle()
    }
    
    func getFlippedCardIndex(at indexPath: Int) {
        if firstFlippedCardIndex == nil {
            firstFlippedCardIndex = indexPath
        } else {
            secondFlippedCardIndex = indexPath
            checkForMatch()
        }
    }
    
   private func checkForMatch() {
        guard let firstFlippedCardIndex = firstFlippedCardIndex else { return }
        guard let secondFlippedCardIndex = secondFlippedCardIndex else { return }

        let cardOne = game.cardsArray[firstFlippedCardIndex]
        let cardTwo = game.cardsArray[secondFlippedCardIndex]
        
        if cardOne.imageName == cardTwo.imageName {
            cardOne.isMatched = true
            cardTwo.isMatched = true
            delegate?.removeCard(at: firstFlippedCardIndex, and: secondFlippedCardIndex)

            let remainedCards = game.cardsArray.filter { !$0.isMatched }
            if remainedCards.isEmpty {
                checkForGameOver()
            }
        } else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            delegate?.flipDownCard(at: firstFlippedCardIndex,and: secondFlippedCardIndex)
            self.firstFlippedCardIndex = nil
            self.secondFlippedCardIndex = nil
        }
    }

   private func checkForGameOver() {
        if  game.round < 3 {
            game.round += 1
            game.numberOfCards += 1
            createNewRound()
            delegate?.reloadData()
        } else {
            delegate?.showGameOverPopup()
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
