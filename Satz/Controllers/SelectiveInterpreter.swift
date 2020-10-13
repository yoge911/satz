//
//  SelectiveInterpreter.swift
//  Satz
//
//  Created by Yogesh Rokhade on 13.10.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import UIKit

class SelectiveInterpreter: UITableViewController {
    @IBOutlet weak var interpretationStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ge()
    }
    

    
    func ge(){
        self.updateSentencesStack()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    

    



}

extension SelectiveInterpreter {
    func updateSentencesStack() {

        interpretationStackView.removeAllArrangedSubviews()
        let examplestring1 = "zu übernehmen oder in Konkurs zu geraten. d) Die Schwierigkeiten der Unternehmen müssen auf externe Ursachen zurückzuführen sein.zu übernehmen oder in Konkurs zu geraten. d) Die Schwierigkeiten der Unternehmen müssen auf externe Ursachen zurückzuführen sein."
        let examplestring2 = "placed in danger or could fail; (d) the difficulties of the undertakings must be the result of external rather than internal factors.placed in danger or could fail; (d) the difficulties of the undertakings must be the result of external rather than internal factors. "
        let sentencePairStack = createSentenceStackItem(fromSentence: examplestring1, toSentence: examplestring2)


        interpretationStackView.addArrangedSubview(sentencePairStack)
        //sentencePairStack.addHorizontalSeparators(color: .darkGray)
     
    }
    
    func createSentenceStackItem(fromSentence: String, toSentence: String) -> UIStackView {
        let sentence1 = createSentenceLabelObj(sentenceText: fromSentence)
        let sentence2 = createSentenceLabelObj(sentenceText: toSentence)
        let sentencePairStack = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        sentencePairStack.axis = .horizontal
        sentencePairStack.alignment = .fill
        sentencePairStack.distribution = .equalCentering
        sentencePairStack.spacing = 10.0
        sentencePairStack.addArrangedSubview(sentence1)
        sentencePairStack.addArrangedSubview(sentence2)
        sentencePairStack.layoutIfNeeded()
        return sentencePairStack
    }
    
    func createSentenceLabelObj(sentenceText: String) -> UILabel {
   
        let originalSentenceLabel = UILabel(frame: CGRect(x: 0, y: 10, width: (self.view.frame.width / 2), height: 0))
        originalSentenceLabel.translatesAutoresizingMaskIntoConstraints = false
//        originalSentenceLabel.backgroundColor = .cyan
        originalSentenceLabel.font = UIFont(name:"HelveticaNeue", size: 15.0)
        originalSentenceLabel.textAlignment = .left
        originalSentenceLabel.textColor = .white
        originalSentenceLabel.numberOfLines = 0
        originalSentenceLabel.text = sentenceText
        return originalSentenceLabel
    }
}
