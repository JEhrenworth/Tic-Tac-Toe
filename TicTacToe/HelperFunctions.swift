//
//  HelperFunctions.swift
//  TicTacToe
//
//  Created by Jackson Ehrenworth 18 on 8/6/16.
//  Copyright © 2016 Jackson Ehrenworth. All rights reserved.
//

import Foundation
import UIKit

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

public class Helper {
    
    func converUIButtonArrayToBoard(UIButtons: Array<UIButton>) -> Array<String> {
        // PARAMS: UIButtons (Array<UIButton>): array of UIButtons to convert to board format
        // RETURNS: Array<String>
        // USE: convert an array of UIButtons to an array of strings (the board) of values "X" "O" or ""
        // NOTE!: board is formatted so that board[0] = upper left, board[1] = middle left, board[2] = lower left, board[3] = upper middle ... board[8] = lower right
        
        var board: [String] = []
        
        for button in UIButtons {
            board.append(button.unwrapText())
        }; return board
    }
    
    func gameIsOver(board: Array<String>, turn: Turn) -> Bool {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: Bool
        // USE: check if game is over (if player won or if board is full)
        
        if boardIsFull(board) {
            return true
        } else if gameLogic.playerHasWon(board, turn: turn) {
            return true
        }; return false
    }
    
    func boardIsFull(board: Array<String>) -> Bool {
        // PARAMS: board (Array<String>): current board
        // RETURNS: Bool
        // USE: check if the current board has any valid squares which can be played on
        
        for square in board {
            if gameLogic.squareIsValidMove(square) {
                return false
            }
        }; return true
    }
    
}