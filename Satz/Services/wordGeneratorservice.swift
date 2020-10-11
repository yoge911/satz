//
//  wordGeneratorservice.swift
//  Satz
//
//  Created by Yogesh Rokhade on 07.08.20.
//  Copyright © 2020 Yogesh Rokhade. All rights reserved.
//

import Foundation

class wordGenerator {
    
    var sessionMixture = ["Technik"]
    
    init() {
        //TO-DO: Target Language in session should be set
        //TO-DO: Event for Mixture of Words to be set
        //TO-D0: Text Source to be set
        setSessionData()
    }
    
    func setSessionData() {
        sessionMixture.append("Music")
    }
    
    public func wordFinder(wordsNeeded: UInt) -> [String] {
        let sessionText = """
Okay, warte kurz, kukkt mich an, siehst du das?
        Ich bin cool, dies und das, ich freu' mir 'nen riesen Ast
        Ich mache das hier für die Leute die das hier lieben,
        lasst mich einfach in Frieden, wenn ihr Sido hasst
        Punkt aus, ich bin ein gemachter Mann
        Was ich erreicht hab, eigentlich könnte man sagen, so wie's is reicht das
        Aber es reicht nicht, nein, ich kann nicht bescheiden sein
        Ich will so vieles noch erleben vor dem Altersheim
        Ich will den Jackpot im Lotto gewinnen
        Und damit alle meine Schäfchen ins Trockene bringen
        Ich will high und frei sein, wie eine Flocke im Wind
        Ansonsten schrei ich wie ein bockiges Kind
        Und dann wird's wieder eklig, ich hab schon viel erlebt
        Ich hab aber noch so viel vor, ihr alles kukkt mir dabei zu auf eurem Monitor
        Bis sie mir irgendwann das große Licht ausschalten,
        Doch der Himmel muss es erst mal ohne mich aushalten
        Ich ruf es nach oben, der Himmel soll warten
        Denn ich hab noch was vor, der Himmel muss warten
        Wenn alles vorbei ist, nimm mir den Atem
        Doch noch bleib ich hier, der Himmel soll warten
        Warte mal, stopp, du kannst mich noch nicht gehen lassen
        Nimm dir doch lieber diese Emo's die ihr Leben hassen
        Ich bin noch lange nicht fertig, es fängt doch grade an
        Ich hab am Sack doch grad' mal Haare dran, 3 Stück
        Ich will mein Sohn wachsen sehen, ich will 'ne Tochter
        Und dann nach 9 Monaten von mir aus, gleich noch mal
        Ich will n Haus, n Affen und n Pferd
        Lass mich machen, all das werd' ich schaffen und noch mehr
        Ich will Karriere machen, ich will noch weiter hoch
        Ich will in China mal ein Hund kosten, einfach so
        Ich will nach Las Vegas, alles was ich hab auf Rot
        Haus weg, Pferd weg, Klappe zu, Affe tot
        Ich will zur Ruhe kommen, kein Streit, kein Stress
        Vorausgesetzt das man mir noch n bisschen Zeit lässt
        Wenn ich dann fertig bin, hol mich da raus
        Doch bis dahin kommst du gut ohne mich aus
        Und ich sing Halleluja
        Ich ruf es nach oben, der Himmel soll warten
        Denn ich hab noch was vor, der Himmel muss warten
        Wenn alles vorbei ist, nimm mir den Atem
        Doch noch bleib ich hier, der Himmel soll warten
        Oh
        Ich ruf es nach oben, der Himmel soll warten
        Denn ich hab noch was vor, der Himmel muss warten
        Wenn alles vorbei ist, nimm mir den Atem
        Doch noch bleib ich hier, der Himmel soll warten
        Ich ruf es nach oben, der Himmel soll warten
        Denn ich hab noch was vor, der Himmel muss warten
        Wenn alles vorbei ist, nimm mir den Atem
        Doch noch bleib ich hier, der Himmel soll warten
"""
        let words = sessionText.split(separator: " ").filter {$0.count > 3}
        var wordsToFind  = [String]()
        for _ in 1...wordsNeeded {
            wordsToFind.append(String(words[Int.random(in: 1..<100)]).alphanumeric)
        }
        return wordsToFind

    }
}

extension String {
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}
