/* Implements main game logic. */
//
//  GameLogic.swift
//  TicTacToe
//
//  Created by Jackson Ehrenworth 18 on 8/7/16.
//  Copyright © 2016 Jackson Ehrenworth. All rights reserved.
//

import Foundation

public class Logic {

    func squareIsValidMove(squareData: String) -> Bool {
        // PARAMS: squareData (String): the data of selected square
        // RETURNS: Bool
        // USE: return true if selected square can be played on
        
        if squareData == "" {
            return true
        }; return false
    }
    
    func playerHasWon(board: Array<String>, turn: Turn) -> Bool {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: Bool
        // USE: return true if a current turn has won (aptly named, I know)
        
        if hasWonOnDiagonal(board, turn: turn) || hasWonOnHorizontalOrVertical(board, turn: turn) {
            return true
        }; return false
    }
    
    func hasWonOnDiagonal(board: Array<String>, turn: Turn) -> Bool {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: Bool
        // USE: return true if current turn won on one of the diagonals
        
        let diagonalOne: Array = [board[0], board[4], board[8]]
        let diagonalTwo: Array = [board[2], board[4], board[6]]
        
        if diagonalOne.allEqualTo(turn.rawValue) || diagonalTwo.allEqualTo(turn.rawValue) {
            return true
        }; return false
    }
    
    func hasWonOnHorizontalOrVertical(board: Array<String>, turn: Turn) -> Bool {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: Bool
        // USE: return true if current turn won on one of the horizontals or one of the verticals
        
        let verticalLeft: Array = [board[0], board[1], board[2]]
        let verticalMiddle: Array = [board[3], board[4], board[5]]
        let verticalRight: Array = [board[6], board[7], board[8]]
        let horizontalTop: Array = [board[0], board[3], board[6]]
        let horizontalMiddle: Array = [board[1], board[4], board[7]]
        let horizontalBottom: Array = [board[2], board[5], board[8]]
        
        let hasWon: Bool = verticalLeft.allEqualTo(turn.rawValue) || verticalMiddle.allEqualTo(turn.rawValue) || verticalRight.allEqualTo(turn.rawValue) || horizontalTop.allEqualTo(turn.rawValue) || horizontalMiddle.allEqualTo(turn.rawValue) || horizontalBottom.allEqualTo(turn.rawValue)
        
        return hasWon
    }
}