//
//  ViewController.swift
//  Hangman
//
//  Created by Andrei Korikov on 24.10.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var roundLabel: UILabel!
    @IBOutlet var clueLabel: UILabel!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var hangmanImage: UIImageView!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var numOfLettersLabel: UILabel!
    
    var usedButtons = [String : UIButton]()
    var currentWord = ""
    var lines = [String]()
    var clues = [String]()
    var words = [String]()
    var fails = 0 {
        didSet {
            hangmanImage?.image = fails > 0 ? UIImage(named: "hang\(fails)") : nil
        }
    }
    var round = 0 {
        didSet {
            roundLabel.text = "\(NSLocalizedString("round", comment: "")) \(round)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restartGame(action: nil)
    }
    
    func loadWordsAndClues() {
        if lines.isEmpty {
            let data = String(localized: "words")
            lines = data.components(separatedBy: "\n")
        }
        
        lines.shuffle()
        
        words.removeAll(keepingCapacity: true)
        clues.removeAll(keepingCapacity: true)
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            words.append(parts[0].uppercased())
            clues.append(parts[1])
        }
    }
    
    func setNewWord() {
        clueLabel.text = clues[round]
        currentWord = words[round]
        
        let wordLen = currentWord.count
        wordLabel.text = String(repeating: "?", count: wordLen)
        numOfLettersLabel.text = "\(wordLen) \(String(localized: "letters"))"
        
        fails = 0
        round += 1
        
        usedButtons.forEach { (_, btn) in
            btn.isHidden = false
        }
        usedButtons.removeAll()
    }
    
    @IBAction func letterTapped(_ sender: UIButton) {
        guard let btnText = sender.titleLabel?.text else { return }
        
        usedButtons[btnText] = sender
        sender.isHidden = true
        
        var newLabel = ""
        currentWord.forEach { char in
            newLabel.append(usedButtons[String(char)] != nil ? char : "?")
        }
        
        if wordLabel.text != newLabel {
            wordLabel.text = newLabel
            
            if newLabel == currentWord {
                if round < words.count {
                    setNewWord()
                } else {
                    showAlertMsg(title: String(localized: "winTitle"), message: String(localized: "winGameMsg"))
                }
            }
        } else {
            fails += 1
            if fails >= 7 {
                showAlertMsg(title: String(localized: "loseTitle"), message: String(localized: "newGameMsg"))
            }
        }
    }
    
    func showAlertMsg(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: restartGame))
        present(ac, animated: true)
    }
    
    func restartGame(action: UIAlertAction?) {
        round = 0
        loadWordsAndClues()
        setNewWord()
    }
}

