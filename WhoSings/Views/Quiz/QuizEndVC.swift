//
//  QuizEndVC.swift
//  WhoSings
//
//  Created by netfarm on 06/04/21.
//

import UIKit

class QuizEndVC: DarkVC {
    
    let titleLabel:UILabel = createALLabel(text: "End of the Quiz!", font: .systemFont(ofSize: 36, weight: .regular), textAlign: .center)
    
    let scoreLabel:UILabel = createALLabel(text: "\(WhoSingsManager.sharedInstance.current_score)", font: .systemFont(ofSize: 42, weight: .semibold), textAlign: .center)
    
    let playAgainButton:UIButton = createBorderALButton(title: "Play Again")
    let backHomeButton:UIButton = createBorderALButton(title: "Back to menu")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // last minute adjustments and actions
        prepareButtons()
        // assign UIElements to the main view
        assignUItoView()
        // setup AutoLayout constraints
        setupLayout()
    }
    
    private func prepareButtons(){
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        backHomeButton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
    }
    
    private func assignUItoView(){
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(playAgainButton)
        view.addSubview(backHomeButton)
    }
    
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        scoreLabel.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        scoreLabel.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        playAgainButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 80).isActive = true
        playAgainButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        playAgainButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        playAgainButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        backHomeButton.topAnchor.constraint(equalTo: playAgainButton.bottomAnchor, constant: 24).isActive = true
        backHomeButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        backHomeButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        backHomeButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
    }
    
    @objc private func playAgain(sender: UIButton!) {
        WhoSingsManager.sharedInstance.saveAndClearScore()
        navigationController?.setViewControllers([QuizCardVC()], animated: true)
     }
    
    @objc private func backHome(sender: UIButton!) {
        WhoSingsManager.sharedInstance.saveAndClearScore()
        navigationController?.setViewControllers([HomeVC()], animated: true)
     }
    
}
