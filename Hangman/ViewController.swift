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
        
        loadWordsAndClues()
        setNewWord()
    }
    
    func loadWordsAndClues() {
        let data = String(localized: .init("words"))
        var lines = data.components(separatedBy: "\n")
        lines.shuffle()
        
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            words.append(parts[0].uppercased())
            clues.append(parts[1])
        }
    }

    func setNewWord() {
        fails = 0
        round += 1
        
        let index = round - 1
        clueLabel.text = clues[index]
        wordLabel.text = words[index]
    }
}

