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
    
    var bestMove: Int = Int()
    
    func bestMove(board: Array<String>, turn: Turn) -> Int {
        minimax(board, turn: turn)
        return bestMove
    }
    
    func minimax(board: Array<String>, turn: Turn) -> Int {
        if helperFunctions.gameIsOver(board, turn: localChangeTurn(turn)) { return score(board, turn: localChangeTurn(turn)) }
        var scores: [Int] = []
        var moves: [Int] = []
        
        let children: [([String], Int)] = getNewBoardStates(board, turn: turn)
        
        for childNode in children {
            scores.append(minimax(childNode.0, turn: localChangeTurn(turn)))
            moves.append(childNode.1)
        }
        
        print(scores)
        print(moves)
        
        if turn == Turn.PlayerX {
            let maxScoreIndex = scores.indexOf(scores.maxElement()!)
            bestMove = moves[maxScoreIndex!]
            return scores[maxScoreIndex!]
        } else {
            let maxScoreIndex = scores.indexOf(scores.minElement()!)
            bestMove = moves[maxScoreIndex!]
            return scores[maxScoreIndex!]
        }
    }
    
    func score(board: Array<String>, turn: Turn) -> Int {
        if gameLogic.playerHasWon(board, turn: turn) {
            return turn == Turn.PlayerX ? 1 : -1
        } else {
            return 0
        }
    }
    
    func getMaxOrMinScoreAndMove(gameTree: Array<Array<Int>>, max: Bool) -> Array<Int> {

        var scores: [Int] = []
        var moves: [Int] = []
        
        for node in gameTree {
            scores.append(node[0])
            moves.append(node[1])
        }
        
        let score: Int = max ? scores.maxElement()! : scores.minElement()!
        let move: Int = moves[scores.indexOf(score)!]
        
        return [score, move]
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
    
    func localChangeTurn(turn: Turn) -> Turn {
        // PARAMS: turn (Turn): current turn
        // RETURNS: Turn
        // USE: return the switched turn 
        // NOTE!: doesn't modify currentTurn in view controller
        
        if turn == Turn.PlayerX {
            return Turn.PlayerO
        }; return Turn.PlayerX
    }
}
