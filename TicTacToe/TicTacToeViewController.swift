//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by iD Student on 8/4/16.
//  Copyright © 2016 Jackson Ehrenworth. All rights reserved.
//

import UIKit

extension Array where Element : Equatable {
    func allEqualTo(toCheck: String) -> Bool {
        // PARAMS: toCheck (String): the value to check the rest of the array against
        // RETURNS: Bool
        // USE: check if every element in the array is equal to toCheck
        
        // ["ten", "ten", "five"].allEqualTo("ten") = false
        // ["fries"].allEqualTo("fries") = true
        // ["bars", "bars", "bars"]. allEqualTo("silver") = false
        
        if let firstElem = first {
            if String(firstElem) != toCheck {
                return false
            } else {
                for i in self {
                    if i != firstElem {
                        return false
                    }
                }
            }
        }; return true
    }
}

extension UIButton {
    func unwrapText() -> String {
        // PARAMS: none
        // RETURNS: String
        // USE: return the text value of the UIButton, or "" if its value is nil
        
        // buttonWithNilValueInTextField.unwrapText() = ""
        // buttonWithBuildingValueInTextField.unwrapText() = "Building"
        
        if let text = self.titleLabel?.text {
            return text
        } else {
            return ""
        }
    }
}

enum Turn: String {
    case PlayerX = "X", PlayerO = "O"
}

class TicTacToeViewController: UIViewController {
    
    var currentTurn: Turn = Turn.PlayerX
    
    @IBOutlet weak var upperLeft: UIButton!
    @IBOutlet weak var middleLeft: UIButton!
    @IBOutlet weak var lowerLeft: UIButton!
    @IBOutlet weak var upperMiddle: UIButton!
    @IBOutlet weak var middleMiddle: UIButton!
    @IBOutlet weak var lowerMiddle: UIButton!
    @IBOutlet weak var upperRight: UIButton!
    @IBOutlet weak var middleRight: UIButton!
    @IBOutlet weak var lowerRight: UIButton!
    
    @IBOutlet weak var display: UILabel!
    
    var buttonsArray: [UIButton] = [UIButton()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonsArray = [upperLeft, middleLeft, lowerLeft, upperMiddle, middleMiddle, lowerMiddle, upperRight, middleRight, lowerRight]
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        // PARAMS: sender (UIButton)
        // RETURNS: none
        // USE: when a button is pressed grab the text from the button and call manageTurn. If button has a value of nil pass "" to manageTurn
        
        if let squareData = sender.titleLabel?.text {
            manageTurn(squareData, selectedSquare: sender)
        } else {
            manageTurn("", selectedSquare: sender)
        }
    }
    
    func manageTurn (squareData: String, selectedSquare: UIButton) {
        // PARAMS: squareData (String): the value of the squares text field ("", "X", or "O"). selectedSquare (UIButton): the UIButton the player selected
        // RETURNS: none
        // USE: overall game manager; check if square is valid and send out calls to end game functions
        
        if squareIsValid(squareData) {
            selectedSquare.setTitle(currentTurn.rawValue, forState: UIControlState.Normal)
            if gameIsOver() {
                manageGameOver()
            }; changeTurn()
        }
    }
    
    func manageGameOver() {
        // PARAMS: none
        // RETURNS: none
        // USE: check if player has won or if board is full, and manage endgame accordingly
        
        if playerHasWon() {
            display.text = "Player \(currentTurn.rawValue) has won"
            manageReset()
        } else if boardIsFull() {
            display.text = "It's a draw. Nobody wins."
            manageReset()
        }
    }
    
    func manageReset() {
        // PARAMS: none
        // RETURNS: none
        // USE: manage the end of game reset
        
        addResetGesture()
        performSelector("suggestRestart", withObject: nil, afterDelay: 1)
    }
    
    func addResetGesture() {
        // PARAMS: none
        // RETURNS: none
        // USE: add a gesture to display label and call manageLabelTapped when player taps display
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector("manageLabelTapped:"))
        display.addGestureRecognizer(gesture)
    }
    
    func manageLabelTapped(sender: UITapGestureRecognizer) {
        // PARAMS: sender (UITapGestureRecognizer): the gesture recognizer
        // RETURNS: none
        // USE: remove the gesture recognizer from the display label and reset the board
        
        let gesture = (display.gestureRecognizers?.first!)!
        display.removeGestureRecognizer(gesture)
        resetBoard()
        display.text = "Tic-Tac-Toe"
    }
    
    func suggestRestart() {
        // PARAMS: none
        // RETURNS: none
        // USE: change the display text to "Restart?"
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if self.display.text != "Tic-Tac-Toe" {
                self.display.text = "Restart?"
            }
        }
    }
    
    func gameIsOver() -> Bool {
        // PARAMS: none
        // RETURNS: Bool
        // USE: check if game is over (if player won or if board is full)
        
        if boardIsFull() {
            return true
        } else if playerHasWon() {
            return true
        }; return false
    }
    
    func changeTurn() {
        // PARAMS: none
        // RETURNS: none
        // USE: switch the current turn to the opposite player
        
        if currentTurn == Turn.PlayerX {
            currentTurn = Turn.PlayerO
        } else {
            currentTurn = Turn.PlayerX
        }
    }
    
    func squareIsValid(squareData: String) -> Bool {
        // PARAMS: squareData (String): the data of selected square
        // RETURNS: Bool
        // USE: see if selected square can be played on
        
        if squareData == "" {
            return true
        }; return false
    }
    
    func boardIsFull() -> Bool {
        // PARAMS: none
        // RETURNS: Bool
        // USE: check if none of the buttons in buttonsArray have a value of nil
        
        var isFull: Bool = Bool()
        
        for square in buttonsArray {
            if let _ = square.titleLabel?.text {
                isFull = true
            } else {
                return false
            }
        }; return isFull
    }
    
    func playerHasWon() -> Bool {
        // PARAMS: none
        // RETURNS: Bool
        // USE: return true if a player has won (aptly named, I know)
        
        if hasWonOnDiagonal() || hasWonOnHorizontalOrVertical() {
            return true
        }; return false
    }
    
    func hasWonOnDiagonal() -> Bool {
        // PARAMS: none
        // RETURNS: Bool
        // USE: return true if the player has won on one of the diagonals
        
        let diagonalOne: Array = [buttonsArray[0].unwrapText(), buttonsArray[4].unwrapText(), buttonsArray[8].unwrapText()]
        let diagonalTwo: Array = [buttonsArray[2].unwrapText(), buttonsArray[4].unwrapText(), buttonsArray[6].unwrapText()]
        
        if diagonalOne.allEqualTo(currentTurn.rawValue) || diagonalTwo.allEqualTo(currentTurn.rawValue) {
            return true
        }; return false
    }
    
    func hasWonOnHorizontalOrVertical() -> Bool {
        // PARAMS: none
        // RETURNS: Bool
        // USE: return true if the player has won on one a horizontal or a vertical row/column
        
        let verticalLeft: Array = [buttonsArray[0].unwrapText(), buttonsArray[1].unwrapText(), buttonsArray[2].unwrapText()]
        let verticalMiddle: Array = [buttonsArray[3].unwrapText(), buttonsArray[4].unwrapText(), buttonsArray[5].unwrapText()]
        let verticalRight: Array = [buttonsArray[6].unwrapText(), buttonsArray[7].unwrapText(), buttonsArray[8].unwrapText()]
        let horizontalTop: Array = [buttonsArray[0].unwrapText(), buttonsArray[3].unwrapText(), buttonsArray[6].unwrapText()]
        let horizontalMiddle: Array = [buttonsArray[1].unwrapText(), buttonsArray[4].unwrapText(), buttonsArray[7].unwrapText()]
        let horizontalBottom: Array = [buttonsArray[2].unwrapText(), buttonsArray[5].unwrapText(), buttonsArray[8].unwrapText()]
        
        let hasWon: Bool = verticalLeft.allEqualTo(currentTurn.rawValue) || verticalMiddle.allEqualTo(currentTurn.rawValue) || verticalRight.allEqualTo(currentTurn.rawValue) || horizontalTop.allEqualTo(currentTurn.rawValue) || horizontalMiddle.allEqualTo(currentTurn.rawValue) || horizontalBottom.allEqualTo(currentTurn.rawValue)
        
        return hasWon
    }
    
    func resetBoard() {
        // PARAMS: none
        // RETURNS: none
        // USE: return all button values to nil
        
        for square in buttonsArray {
            // Both of these lines have to be used! Do not delete one because it seems superfluous
            // TODO: Why do both these lines need to be called to have it change in both the display and the memory
            square.setTitle(nil, forState: UIControlState.Normal)
            square.titleLabel?.text = nil
        }
        
        // X always starts
        if currentTurn.rawValue == "O" {
            changeTurn()
        }
    }
}
