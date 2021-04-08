//
//  QuizVC.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import UIKit
import ObjectMapper

let QUIZ_QUESTIONS = Bundle.main.object(forInfoDictionaryKey: "QUIZ_QUESTIONS") as! Int
let QUIZ_TIMER = Bundle.main.object(forInfoDictionaryKey: "QUIZ_TIMER") as! Int

class QuizCardVC: DarkVC {
    
    var track_list = Array<TrackDict>()
    var artist_list = Array<ArtistDict>()
    var answers = Array<Artist>()
    var current_track:TrackDict?
    var current_artist:Artist?
    var current_lyric:Lyric?
    
    var index = 0
    var seconds = QUIZ_TIMER
    var timer = Timer()
    var isTimeRunning = false
    
    let currentCardLabel:UILabel = createALLabel(text: "1/\(QUIZ_QUESTIONS)", font: .systemFont(ofSize: 24, weight: .semibold), textAlign: .left)
    let timerLabel:UILabel = createALLabel(text: "\(QUIZ_TIMER)s", font: .systemFont(ofSize: 24), textAlign: .right)
       
    let lyricTextView:UITextView = createALTextView(text: "Loading...", font: .italicSystemFont(ofSize: 32), textAlign: .center)
    
    let answerAButton:UIButton = createBorderALButton(title: "A:..")
    let answerBButton:UIButton = createBorderALButton(title: "B:..")
    let answerCButton:UIButton = createBorderALButton(title: "C:..")
   
    
    private func startTimer() {
        seconds = QUIZ_TIMER
        timerLabel.text = "\(seconds)s"
        if !isTimeRunning {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            isTimeRunning = true
        }
    }
    
    @objc private func updateTimer(){
        seconds -= 1
        timerLabel.text = "\(seconds)s"
        if seconds == 0 && isTimeRunning{
            timer.invalidate()
            isTimeRunning = false
            nextQuestion()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // last minute adjustments and actions
        prepareButtons()
        // assign UIElements to the main view
        assignUItoView()
        // setup AutoLayout constraints
        setupLayout()
        // load Quiz questions from Musixmatch
        loadTracks()
    }
    
    private func prepareButtons(){
        answerAButton.addTarget(self, action: #selector(chosenA), for: .touchUpInside)
        answerBButton.addTarget(self, action: #selector(chosenB), for: .touchUpInside)
        answerCButton.addTarget(self, action: #selector(chosenC), for: .touchUpInside)
        areButtonsEnabled(false)
    }
    
    private func assignUItoView(){
        view.addSubview(currentCardLabel)
        view.addSubview(timerLabel)
        view.addSubview(lyricTextView)
        view.addSubview(answerAButton)
        view.addSubview(answerBButton)
        view.addSubview(answerCButton)
    }
   
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        currentCardLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        currentCardLabel.leftAnchor.constraint(equalTo:guide.leftAnchor, constant: 16).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        timerLabel.rightAnchor.constraint(equalTo:guide.rightAnchor, constant: -16).isActive = true
        
        lyricTextView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 80).isActive = true
        lyricTextView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        lyricTextView.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        lyricTextView.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        answerAButton.topAnchor.constraint(equalTo: lyricTextView.bottomAnchor, constant: 80).isActive = true
        answerAButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        answerAButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        answerAButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        answerBButton.topAnchor.constraint(equalTo: answerAButton.bottomAnchor, constant: 24).isActive = true
        answerBButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        answerBButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        answerBButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        answerCButton.topAnchor.constraint(equalTo: answerBButton.bottomAnchor, constant: 24).isActive = true
        answerCButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        answerCButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        answerCButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
    }
    
    private func loadTracks(){
        WhoSingsManager.sharedInstance.getRandomTracks(with: QUIZ_QUESTIONS){ (tracks, error, code) in
            self.track_list = tracks!
            self.setupForCurrent()
        }
    }
    
    private func setupForCurrent(){
        current_track = track_list[index]
        let cA = Artist()
        cA.artist_id = current_track?.track?.artist_id
        cA.artist_name = current_track?.track?.artist_name
        current_artist = cA
        getCurrentLyric()
    }
    
    private func getCurrentLyric(){
        WhoSingsManager.sharedInstance.getLyrics(for: self.current_track!.track!.track_id!){ (lyric, error, code) in
            self.current_lyric = lyric
            self.getCurrentAnswers()
        }
    }
    
    private func getCurrentAnswers(){
        WhoSingsManager.sharedInstance.getRandomArtist(with: 3){ (artists, error, code) in
            self.artist_list = artists!
            self.updateView()
        }
    }
    
    
    private func updateView(){
        let card_number = "\(index+1)\\\(QUIZ_QUESTIONS)"
        currentCardLabel.text = card_number
        let track_lyrics = "``\(current_lyric?.snippet_body ?? "")``"
        lyricTextView.text = track_lyrics
    
        prepareAnswers()
        styleButtons()
        areButtonsEnabled(true)
        startTimer()
    }

    
    private func prepareAnswers(){
        guard let cA = current_artist else { return }
        var answers_array:Array<Artist> = [cA]
        for aD in artist_list {
            if answers_array.count == 3{
                break
            }
            if (aD.artist != nil) && aD.artist?.artist_id != cA.artist_id {
                answers_array.append(aD.artist!)
            }
        }
        answers = answers_array.shuffled()
    }
    
    private func styleButtons(){
        answerAButton.setTitle("A: \(answers[0].artist_name ?? "")", for: .normal)
        answerBButton.setTitle("B: \(answers[1].artist_name ?? "")", for: .normal)
        answerCButton.setTitle("C: \(answers[2].artist_name ?? "")", for: .normal)
        answerAButton.layer.borderColor = UIColor.white.cgColor
        answerBButton.layer.borderColor = UIColor.white.cgColor
        answerCButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc private func chosenA(sender: UIButton!) {
        checkAnswer(with: 0, for: sender)
    }
    
    @objc private func chosenB(sender: UIButton!) {
        checkAnswer(with: 1, for: sender)
    }
    
    @objc private func chosenC(sender: UIButton!) {
        checkAnswer(with: 2, for: sender)
    }
    
    
    private func checkAnswer(with id:Int, for button:UIButton!){
        // disable buttons and stop timer
        areButtonsEnabled(false)
        if isTimeRunning {
            timer.invalidate()
            isTimeRunning = false
        }
        
        let answer = answers[id]
        if answer.artist_id == current_artist?.artist_id{
            // correct answer
            let points = (seconds > 10 ? 10 : seconds)
            WhoSingsManager.sharedInstance.current_score = WhoSingsManager.sharedInstance.current_score + points
            lyricTextView.text = "Correct! \n\(points)p"
            button.layer.borderColor = UIColor.green.cgColor
        } else {
            // wrong answer
            lyricTextView.text = "Wrong!"
            button.layer.borderColor = UIColor.red.cgColor
        }
        delay(bySeconds: 1) {
            self.nextQuestion()
        }
    }
    
    private func nextQuestion(){
        index += 1
        // load next question
        if !(index == QUIZ_QUESTIONS) { setupForCurrent() }
        // finish the quiz
        else { navigationController?.pushViewController(QuizEndVC(), animated: true) }
    }
    
    private func areButtonsEnabled(_ bool:Bool){
        answerAButton.isEnabled = bool
        answerBButton.isEnabled = bool
        answerCButton.isEnabled = bool
    }
}
