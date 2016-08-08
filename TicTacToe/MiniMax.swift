/* Implements the main computer AI. */
//
//  MiniMax.swift
//  TicTacToe
//
//  Created by Jackson Ehrenworth 18 on 8/6/16.
//  Copyright © 2016 Jackson Ehrenworth. All rights reserved.
//

import Foundation
import UIKit

public class MiniMax {
    
    var indexOfBestMove: Int = Int()
    
    func getIndexOfBestMove(board: Array<String>, turn: Turn) -> Int {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: Int
        // USE: call minimax and then return bestMove when minimax finishes running
 
        minimaxWithPruning(board, turn: turn, depth: 0, alpha: -NSIntegerMax, beta: NSIntegerMax)
        return indexOfBestMove
    }
    
    func minimaxWithPruning(board: Array<String>, turn: Turn, depth: Int, alpha: Int, beta: Int) -> Int {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn, depth (Int): depth from current node to end of game node
        // RETURNS: Int
        // USE: call minimax and bestMove will be set to an integer representing the position of the best possible move on the board
        
        if helperFunctions.gameIsOver(board, turn: helperFunctions.localChangeTurn(turn)) {
            return score(board, turn: helperFunctions.localChangeTurn(turn), depth: depth)
        }
    
        var varAlpha: Int = alpha
        var varBeta: Int = beta
        let currentDepth = depth + 1
        var scores: [Int] = []
        var moves: [Int] = []
        
        let children: [([String], Int)] = getNewBoardStates(board, turn: turn)
        
        for childNode in children {
            let score: Int = minimaxWithPruning(childNode.0, turn: helperFunctions.localChangeTurn(turn), depth: currentDepth, alpha: varAlpha, beta: varBeta)
            if turn == Turn.PlayerX {
                if score > alpha {
                    print(score, alpha)
                    varAlpha = score
                }
            } else {
                if score < beta {
                    varBeta = score
                }
            }; if varAlpha >= varBeta {
                return turn == Turn.PlayerX ? varAlpha : varBeta
            } else { scores.append(score); moves.append(childNode.1) }
        }
        
        if turn == Turn.PlayerX {
            let maxScoreIndex = scores.indexOf(scores.maxElement()!)
            indexOfBestMove = moves[maxScoreIndex!]
            return scores[maxScoreIndex!]
        } else {
            let maxScoreIndex = scores.indexOf(scores.minElement()!)
            indexOfBestMove = moves[maxScoreIndex!]
            return scores[maxScoreIndex!]
        }
    }
    
    func score(board: Array<String>, turn: Turn, depth: Int) -> Int {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn, depth (Int): depth from current node to end of game node
        // RETURNS: Int
        // USE: return the score of the board adjusted for depth
        
        if gameLogic.playerHasWon(board, turn: turn) {
            return turn == Turn.PlayerX ? 10 - depth : depth - 10
        } else {
            return 0
        }
    }
    
    func getNewBoardStates(board: Array<String>, turn: Turn) -> Array<(Array<String>, Int)> {
        // PARAMS: board (Array<String>): current board, turn (Turn): current turn
        // RETURNS: Array<(Array<String>, Int)>
        // USE: given a board and a turn, return all an array of all possible boards and the move made to get there
        
        let indexOfPossibleMoves: [Int] = getIndexOfAllPossibleMoves(board)
        var newBoards: [([String], Int)] = []
        
        for index in indexOfPossibleMoves {
            newBoards.append(getNewBoard(board, move: index, turn: turn))
        }; return newBoards
    }
    
    func getNewBoard(board: Array<String>, move: Int, turn: Turn) -> (Array<String>, Int) {
        // PARAMS: board (Array<String>): current board, move (Int): move just played, turn (Turn): current turn
        // RETURNS: (Array<String>, Int)
        // USE: given a move an a board, make the move on the board, returning the board at position .0 and the move at position .1
        
        var dupeBoard: [String] = board
        dupeBoard[move] = turn.rawValue
        return (dupeBoard, move)
    }
    
    func getIndexOfAllPossibleMoves(board: Array<String>) -> Array<Int> {
        // PARAMS: board (Array<String>): current board
        // RETURNS: Array<Int>
        // USE: given an arbitrary board return all valid moves in integer form. e.g. 0 is the upper left square, 1 is the middle left square, 8 is the lower right square.
        
        var indexOfValidMoves: [Int] = []
        
        for (index, square) in board.enumerate() {
            if gameLogic.squareIsValidMove(square) {
                indexOfValidMoves.append(index)
            }
        }; return indexOfValidMoves
    }
}
