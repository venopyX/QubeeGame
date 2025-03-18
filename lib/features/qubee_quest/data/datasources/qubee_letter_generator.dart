import '../../domain/entities/qubee.dart';
import 'qubee_tracing_points.dart';

class QubeeLetterGenerator {
  static List<Qubee> generateBasicLetters() {
    return [
      // Letter A
      Qubee(
        id: 1,
        letter: 'A',
        smallLetter: 'a',
        latinEquivalent: 'A',
        pronunciation: 'a as in father',
        soundPath: 'assets/audio/qubee/a.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForA(),
        unlockedWords: ['Abbaa', 'Adaamaa', 'Aannan'],
        exampleSentence: 'Abbaan koo kaleessa dhufe.',
        meaningOfSentence: 'My father came yesterday.',
        requiredPoints: 0,
        isUnlocked: true,
      ),
      
      // Letter B
      Qubee(
        id: 2,
        letter: 'B',
        smallLetter: 'b',
        latinEquivalent: 'B',
        pronunciation: 'b as in boy',
        soundPath: 'assets/audio/qubee/b.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForB(),
        unlockedWords: ['Baaduu', 'Barataa', 'Bineensa'],
        exampleSentence: 'Tolaan baaduudhaan nyaachaa jira.',
        meaningOfSentence: 'Tola is eating with cheese.',
        requiredPoints: 10,
        isUnlocked: true,
      ),
      
      // Letter C
      Qubee(
        id: 3,
        letter: 'C',
        smallLetter: 'c',
        latinEquivalent: 'C',
        pronunciation: 'c as in church',
        soundPath: 'assets/audio/qubee/c.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForC(),
        unlockedWords: ['Caakkaa', 'Coqorsa', 'Cidha'],
        exampleSentence: 'Caakkaa keessa deemaa turre.',
        meaningOfSentence: 'We were walking in the jungle.',
        requiredPoints: 20,
        isUnlocked: false,
      ),
      
      // Letter D
      Qubee(
        id: 4,
        letter: 'D',
        smallLetter: 'd',
        latinEquivalent: 'D',
        pronunciation: 'd as in dog',
        soundPath: 'assets/audio/qubee/d.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForD(),
        unlockedWords: ['Daangaa', 'Daldalaa', 'Dubbii'],
        exampleSentence: 'Daangaan Oromiyaa bal\'aadha.',
        meaningOfSentence: 'Oromia\'s boundary is very large.',
        requiredPoints: 30,
        isUnlocked: false,
      ),
      
      // Letter E
      Qubee(
        id: 5,
        letter: 'E',
        smallLetter: 'e',
        latinEquivalent: 'E',
        pronunciation: 'e as in egg',
        soundPath: 'assets/audio/qubee/e.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForE(),
        unlockedWords: ['Eegee', 'Eebba', 'Eelee'],
        exampleSentence: 'Eegeen reettii xinnoodha.',
        meaningOfSentence: 'The tail of the goat is small.',
        requiredPoints: 40,
        isUnlocked: false,
      ),
      
      // Letter F
      Qubee(
        id: 6,
        letter: 'F',
        smallLetter: 'f',
        latinEquivalent: 'F',
        pronunciation: 'f as in fish',
        soundPath: 'assets/audio/qubee/f.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForF(),
        unlockedWords: ['Farda', 'Finfinnee', 'Fayyaa'],
        exampleSentence: 'Farda gulufsiisuu nan jaalladha.',
        meaningOfSentence: 'I like riding horses.',
        requiredPoints: 50,
        isUnlocked: false,
      ),
      
      // Letter G
      Qubee(
        id: 7,
        letter: 'G',
        smallLetter: 'g',
        latinEquivalent: 'G',
        pronunciation: 'g as in go',
        soundPath: 'assets/audio/qubee/g.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForG(),
        unlockedWords: ['Gamoo', 'Gaaddidduu', 'Gurbaa'],
        exampleSentence: 'Gamoon keenya dheeraadha.',
        meaningOfSentence: 'Our building is very tall.',
        requiredPoints: 60,
        isUnlocked: false,
      ),
      
      // Letter H
      Qubee(
        id: 8,
        letter: 'H',
        smallLetter: 'h',
        latinEquivalent: 'H',
        pronunciation: 'h as in house',
        soundPath: 'assets/audio/qubee/h.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForH(),
        unlockedWords: ['Harree', 'Hoolaa', 'Harma'],
        exampleSentence: 'Harreen koo na jalaa badde.',
        meaningOfSentence: 'My donkey is lost.',
        requiredPoints: 70,
        isUnlocked: false,
      ),
      
      // Letter I
      Qubee(
        id: 9,
        letter: 'I',
        smallLetter: 'i',
        latinEquivalent: 'I',
        pronunciation: 'i as in ink',
        soundPath: 'assets/audio/qubee/i.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForI(),
        unlockedWords: ['Ija', 'Ilkaan', 'Ilma'],
        exampleSentence: 'Ija kee ilaaluu nan jaalladha.',
        meaningOfSentence: 'I love looking at your eyes.',
        requiredPoints: 80,
        isUnlocked: false,
      ),
      
      // Letter J
      Qubee(
        id: 10,
        letter: 'J',
        smallLetter: 'j',
        latinEquivalent: 'J',
        pronunciation: 'j as in jam',
        soundPath: 'assets/audio/qubee/j.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForJ(),
        unlockedWords: ['Jaamaa', 'Jirbii', 'Jaalala'],
        exampleSentence: 'Obboleessi Boonaa jaamaadha.',
        meaningOfSentence: 'Bona\'s brother is blind.',
        requiredPoints: 90,
        isUnlocked: false,
      ),
      
      // Letter K
      Qubee(
        id: 11,
        letter: 'K',
        smallLetter: 'k',
        latinEquivalent: 'K',
        pronunciation: 'k as in kite',
        soundPath: 'assets/audio/qubee/k.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForK(),
        unlockedWords: ['Karaa', 'Kaleessa', 'Killee'],
        exampleSentence: 'Konkolaataan karaa irra adeemaa jira.',
        meaningOfSentence: 'A car is moving on the road.',
        requiredPoints: 100,
        isUnlocked: false,
      ),
      
      // Letter L
      Qubee(
        id: 12,
        letter: 'L',
        smallLetter: 'l',
        latinEquivalent: 'L',
        pronunciation: 'l as in lamp',
        soundPath: 'assets/audio/qubee/l.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForL(),
        unlockedWords: ['Leenca', 'Laaqana', 'Lukkuu'],
        exampleSentence: 'An leenca hin sodaadhu.',
        meaningOfSentence: 'I don\'t fear lions.',
        requiredPoints: 110,
        isUnlocked: false,
      ),
      
      // Letter M
      Qubee(
        id: 13,
        letter: 'M',
        smallLetter: 'm',
        latinEquivalent: 'M',
        pronunciation: 'm as in moon',
        soundPath: 'assets/audio/qubee/m.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForM(),
        unlockedWords: ['Mana', 'Muuzii', 'Marqaa'],
        exampleSentence: 'Mana Caaltuufaa ha deemnu.',
        meaningOfSentence: 'Let\'s go to Chaltu\'s home.',
        requiredPoints: 120,
        isUnlocked: false,
      ),
      
      // Letter N
      Qubee(
        id: 14,
        letter: 'N',
        smallLetter: 'n',
        latinEquivalent: 'N',
        pronunciation: 'n as in name',
        soundPath: 'assets/audio/qubee/n.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForN(),
        unlockedWords: ['Naacha', 'Nama', 'Naannoo'],
        exampleSentence: 'Afaan naachaa dheeraadha.',
        meaningOfSentence: 'The crocodile\'s mouth is very long.',
        requiredPoints: 130,
        isUnlocked: false,
      ),
      
      // Letter O
      Qubee(
        id: 15,
        letter: 'O',
        smallLetter: 'o',
        latinEquivalent: 'O',
        pronunciation: 'o as in over',
        soundPath: 'assets/audio/qubee/o.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForO(),
        unlockedWords: ['Onnee', 'Odaa', 'Obboleessa'],
        exampleSentence: 'Onnee koo siif kenneera.',
        meaningOfSentence: 'I have given you my heart.',
        requiredPoints: 140,
        isUnlocked: false,
      ),
      
      // Letter P
      Qubee(
        id: 16,
        letter: 'P',
        smallLetter: 'p',
        latinEquivalent: 'P',
        pronunciation: 'p as in pen',
        soundPath: 'assets/audio/qubee/p.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForP(),
        unlockedWords: ['Paappayyaa', 'Poolisii', 'Pilaastikii'],
        exampleSentence: 'Iseen Paappayyaa nyaatte.',
        meaningOfSentence: 'She ate papaya.',
        requiredPoints: 150,
        isUnlocked: false,
      ),
      
      // Letter Q
      Qubee(
        id: 17,
        letter: 'Q',
        smallLetter: 'q',
        latinEquivalent: 'Q',
        pronunciation: 'q as in quick',
        soundPath: 'assets/audio/qubee/q.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForQ(),
        unlockedWords: ['Qaaraa', 'Qabeenya', 'Qoricha'],
        exampleSentence: 'Qaaraan ija nama guba.',
        meaningOfSentence: 'Pepper burns the eyes.',
        requiredPoints: 160,
        isUnlocked: false,
      ),
      
      // Letter R
      Qubee(
        id: 18,
        letter: 'R',
        smallLetter: 'r',
        latinEquivalent: 'R',
        pronunciation: 'r as in run',
        soundPath: 'assets/audio/qubee/r.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForR(),
        unlockedWords: ['Raafuu', 'Raayyaa', 'Rifeensa'],
        exampleSentence: 'Raafuun eda nyaadhe ni mi\'aawa.',
        meaningOfSentence: 'The cabbage I ate last night is very sweet.',
        requiredPoints: 170,
        isUnlocked: false,
      ),
      
      // Letter S
      Qubee(
        id: 19,
        letter: 'S',
        smallLetter: 's',
        latinEquivalent: 'S',
        pronunciation: 's as in sun',
        soundPath: 'assets/audio/qubee/s.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForS(),
        unlockedWords: ['Saree', 'Sagalee', 'Sabbata'],
        exampleSentence: 'Sareen isaanii nama ciniinti.',
        meaningOfSentence: 'Their dog bites people.',
        requiredPoints: 180,
        isUnlocked: false,
      ),
      
      // Letter T
      Qubee(
        id: 20,
        letter: 'T',
        smallLetter: 't',
        latinEquivalent: 'T',
        pronunciation: 't as in time',
        soundPath: 'assets/audio/qubee/t.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForT(),
        unlockedWords: ['Tulluu', 'Tolaa', 'Tiksee'],
        exampleSentence: 'Tulluun Walal dheeraadha.',
        meaningOfSentence: 'Walal hill is very tall.',
        requiredPoints: 190,
        isUnlocked: false,
      ),
      
      // Letter U
      Qubee(
        id: 21,
        letter: 'U',
        smallLetter: 'u',
        latinEquivalent: 'U',
        pronunciation: 'u as in rule',
        soundPath: 'assets/audio/qubee/u.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForU(),
        unlockedWords: ['Urjii', 'Ulee', 'Utuba'],
        exampleSentence: 'Urjiilee samii keessaa sana ilaali.',
        meaningOfSentence: 'Look at the stars in the sky.',
        requiredPoints: 210,
        isUnlocked: false,
      ),
      
      // Letter V
      Qubee(
        id: 22,
        letter: 'V',
        smallLetter: 'v',
        latinEquivalent: 'V',
        pronunciation: 'v as in valley',
        soundPath: 'assets/audio/qubee/v.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForV(),
        unlockedWords: ['Vaayitaamini', 'Viidiyoo', 'Vaazilinii'],
        exampleSentence: 'Loomiin vaaytaamina C of keessaa qaba.',
        meaningOfSentence: 'Lemons contain vitamin C.',
        requiredPoints: 220,
        isUnlocked: false,
      ),
      
      // Letter W
      Qubee(
        id: 23,
        letter: 'W',
        smallLetter: 'w',
        latinEquivalent: 'W',
        pronunciation: 'w as in water',
        soundPath: 'assets/audio/qubee/w.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForW(),
        unlockedWords: ['Waraqaa', 'Waaqaa', 'Walaloo'],
        exampleSentence: 'Waraqaa barreessuu bareeda.',
        meaningOfSentence: 'Writing on paper is beautiful.',
        requiredPoints: 230,
        isUnlocked: false,
      ),
      
      // Letter X
      Qubee(
        id: 24,
        letter: 'X',
        smallLetter: 'x',
        latinEquivalent: 'X',
        pronunciation: 'x as in x-ray',
        soundPath: 'assets/audio/qubee/x.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForX(),
        unlockedWords: ['Xalayaa', 'Xuuxxoo', 'Xinnoo'],
        exampleSentence: 'Xalayaa hiriyaa koof barreesse.',
        meaningOfSentence: 'I wrote a letter to my friend.',
        requiredPoints: 240,
        isUnlocked: false,
      ),
      
      // Letter Y
      Qubee(
        id: 25,
        letter: 'Y',
        smallLetter: 'y',
        latinEquivalent: 'Y',
        pronunciation: 'y as in yes',
        soundPath: 'assets/audio/qubee/y.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForY(),
        unlockedWords: ['Yaada', 'Yaalii', 'Yaa\'ii'],
        exampleSentence: 'Yaada gaarii nuuf kennite.',
        meaningOfSentence: 'You gave us a good idea.',
        requiredPoints: 250,
        isUnlocked: false,
      ),
      
      // Letter Z
      Qubee(
        id: 26,
        letter: 'Z',
        smallLetter: 'z',
        latinEquivalent: 'Z',
        pronunciation: 'z as in zebra',
        soundPath: 'assets/audio/qubee/z.mp3',
        tracingPoints: QubeeTracingPoints.getTracingPointsForZ(),
        unlockedWords: ['Zayitii', 'Zabiiba', 'Zaytuuna'],
        exampleSentence: 'Zayitiin gatiin isaa baay\'ee mi\'aawa.',
        meaningOfSentence: 'Oil tastes very good with food.',
        requiredPoints: 260,
        isUnlocked: false,
      ),
    ];
  }
}