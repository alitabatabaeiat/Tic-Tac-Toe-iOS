//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Ali Tabatabaei on 9/6/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var turnLabel: UILabel!
    var board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    var activePlayer = 1
    var winner = 0
    var numberOfMoves = 0
    var isSinglePlayer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTurnLabel()
    }
    
    @IBAction func singlePlayerButton(_ sender: Any) {
        if numberOfMoves == 0 {
            isSinglePlayer = true
            setTurnLabel()
        }
    }
    
    @IBAction func twoPlayerButton(_ sender: Any) {
        if numberOfMoves == 0 {
            isSinglePlayer = false
            setTurnLabel()
        }
    }
    
    @IBAction func cellOnClick(_ sender: Any) {
        let clickedButton = sender as! UIButton
        play(clickedButton)
    }
    
    func play(_ clickedButton: UIButton) {
        if clickedButton.currentTitle == nil {
            let row = Int((clickedButton.tag - 1) / 3)
            let col = (clickedButton.tag - 1) % 3
            board[row][col] = activePlayer
            numberOfMoves += 1
            if activePlayer == 1 {
                clickedButton.setTitle("X", for: .normal)
                clickedButton.backgroundColor = UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1)
                activePlayer = 2
            } else {
                clickedButton.setTitle("O", for: .normal)
                clickedButton.backgroundColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
                activePlayer = 1
            }
            setTurnLabel()
            findWinner()
            if isSinglePlayer && numberOfMoves < 9 && activePlayer == 2 {
                autoPlay()
            }
        }
    }
    
    func setTurnLabel() {
        if activePlayer == 2 && !isSinglePlayer {
            turnLabel.text = "Turn: O"
            turnLabel.textColor = UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
        } else {
            turnLabel.text = "Turn: X"
            turnLabel.textColor = UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1)
        }
        
    }
    
    func findWinner() {
        if (board[0][0] == board[0][1] && board[0][0] == board[0][2] && board[0][0] != 0) {
            winner = board[0][0]
        } else if (board[1][0] == board[1][1] && board[1][0] == board[1][2] && board[1][0] != 0) {
            winner = board[1][0]
        } else if (board[2][0] == board[2][1] && board[2][0] == board[2][2] && board[2][0] != 0) {
            winner = board[2][0]
        } else if (board[0][0] == board[1][0] && board[0][0] == board[2][0] && board[0][0] != 0) {
            winner = board[0][0]
        } else if (board[0][1] == board[1][1] && board[0][1] == board[2][1] && board[0][1] != 0) {
            winner = board[0][1]
        } else if (board[0][2] == board[1][2] && board[0][2] == board[2][2] && board[0][2] != 0) {
            winner = board[0][2]
        } else if (board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0] != 0) {
            winner = board[0][0]
        } else if (board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2] != 0) {
            winner = board[0][2]
        }
        
        var msg:String?
        if winner == 1 {
            msg = "X is winner"
        } else if winner == 2 {
            msg = "O is winner"
        } else if numberOfMoves == 9 {
            msg = "Tie"
        }
        if msg != nil {
            let alert = UIAlertController(title: "Winner", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { (UIAlertAction) -> Void in self.createNewGame()}))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func createNewGame() {
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.tag > 0 {
                    btn.setTitle(nil, for: .normal)
                    btn.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
        board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        activePlayer = winner != 0 ? winner : activePlayer == 1 ? 2 : 1
        winner = 0
        numberOfMoves = 0
        
        setTurnLabel()
        
        if isSinglePlayer && activePlayer == 2 {
            autoPlay()
        }
    }
    
    func autoPlay() {
        var emptyCells = [Int]()
        
        for rowIndex in 0...2 {
            for cellIndex in 0...2 {
                if board[rowIndex][cellIndex] == 0 {
                    emptyCells.append(3 * rowIndex + cellIndex + 1)
                }
            }
        }
        
        let randomIndex = arc4random_uniform(UInt32(emptyCells.count))
        let cell = emptyCells[Int(randomIndex)]
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.tag == cell {
                    play(btn)
                }
            }
        }
    }
    
}

