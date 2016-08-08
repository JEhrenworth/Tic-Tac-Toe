/* Send out calls to main game functions and alter the view accordingly.  All changes to the view are implemented in this file. */
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
        // ["bars", "bars", "bars"].allEqualTo("silver") = false
        
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

enum Turn: String {
    case PlayerX = "X", PlayerO = "O"
}

public class TicTacToeViewController: UIViewController {
    
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
    
    @IBOutlet var buttonsArray: [UIButton] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonsArray = [upperLeft, middleLeft, lowerLeft, upperMiddle, middleMiddle, lowerMiddle, upperRight, middleRight, lowerRight]
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        // PARAMS: sender (UIButton)
        // RETURNS: none
        // USE: when a button is pressed grab the text from the button and call manageTurn.
        
        manageTurn(sender.unwrapText(), selectedSquare: sender)
    }
    
    func manageTurn (squareData: String, selectedSquare: UIButton) {
        // PARAMS: squareData (String): the value of the squares text field ("", "X", or "O"). selectedSquare (UIButton): the UIButton the player selected
        // RETURNS: none
        // USE: game manager; send out calls to game functions
        
        if gameLogic.squareIsValidMove(squareData) {
            selectedSquare.setTitle(currentTurn.rawValue, forState: UIControlState.Normal)
            let board: [String] = helperFunctions.converUIButtonArrayToBoard(buttonsArray)
            if helperFunctions.gameIsOver(board, turn: currentTurn) {
                manageGameOver(board, turn: currentTurn)
            }; handleComputerMove(board)
        }
    }
    
    func handleComputerMove(board: Array<String>) {
        // PARAMS: board (Array<String>): current board
        // RETURNS: none
        // USE: make the computers move and check for game over, handling if so
        
        makeComputerMove(board)
        
        let newBoard: [String] = helperFunctions.converUIButtonArrayToBoard(buttonsArray)
        let computerTurn: Turn = helperFunctions.localChangeTurn(currentTurn)
        
        if helperFunctions.gameIsOver(newBoard, turn: computerTurn) {
            manageGameOver(newBoard, turn: computerTurn)
        }
    }
    
    func makeComputerMove(board: Array<String>) {
        // PARAMS: board (Array<String>): current board
        // RETURNS: none
        // USE: make the computers move on the board
        
        let indexOfButton: Int = miniMax.getIndexOfBestMove(board, turn: helperFunctions.localChangeTurn(currentTurn))
        let computerTurn: Turn = helperFunctions.localChangeTurn(currentTurn)
        
        buttonsArray[indexOfButton].setTitle(computerTurn.rawValue, forState: UIControlState.Normal)
    }
    
    func manageGameOver(board: Array<String>, turn: Turn) {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: none
        // USE: check if player has won or if board is full, and manage endgame accordingly
        
        if gameLogic.playerHasWon(board, turn: turn) {
            display.text = "Player \(turn.rawValue) wins!"
        } else if helperFunctions.boardIsFull(board) {
            display.text = "It's a draw. Nobody wins."
        }; manageReset()
    }
    
    func manageReset() {
        // PARAMS: none
        // RETURNS: none
        // USE: manage the end of game reset
        
        addResetGesture()
        performSelector(#selector(suggestRestart), withObject: nil, afterDelay: 1)
    }
    
    func changeTurn() {
        // PARAMS: none
        // RETURNS: none
        // USE: switch the current turn to the opposite turn
        
        if currentTurn == Turn.PlayerX {
            currentTurn = Turn.PlayerO
        } else {
            currentTurn = Turn.PlayerX
        }
    }
    
    func resetBoard() {
        // PARAMS: none
        // RETURNS: none
        // USE: return all button values to nil and reset currentTurn
        
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
    
    func addResetGesture() {
        // PARAMS: none
        // RETURNS: none
        // USE: add a gesture to display label and call manageLabelTapped when player taps display
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(TicTacToeViewController.manageLabelTapped(_:)))
        display.addGestureRecognizer(gesture)
    }
    
    func manageLabelTapped(sender: UITapGestureRecognizer) {
        // PARAMS: sender (UITapGestureRecognizer): the gesture recognizer to use
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
}
