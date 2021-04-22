//
//  HighScoresVC.swift
//  WhoSings
//
//  Created by netfarm on 06/04/21.
//

import UIKit

let HIGH_SCORES = Bundle.main.object(forInfoDictionaryKey: "HIGH_SCORES") as! Int

class HighScoresVC: DarkVC {
    
    let titleLabel:UILabel = createALLabel(text: "High Scores", font: .systemFont(ofSize: 36, weight: .regular), textAlign: .center)
    
    let scoresStackView:UIStackView = createALStackView(spacing: 16)
    
    let backHomeButton:UIButton = createBorderALButton(title: "Back to menu")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // last minute adjustments and actions
        prepareButtons()
        // assign UIElements to the main view
        assignUItoView()
        // create StackView subViews
        createScoreSubViews()
        // setup AutoLayout constraints
        setupLayout()
    }
    
    private func prepareButtons(){
        backHomeButton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
    }
    
    private func assignUItoView(){
        view.addSubview(titleLabel)
        view.addSubview(scoresStackView)
        view.addSubview(backHomeButton)
    }
    
    private func createScoreSubViews(){
        let highscores = getHighScores(quantity: HIGH_SCORES)
        if highscores.isEmpty {
            let subView = createSubLabel(for: nil)
            scoresStackView.addArrangedSubview(subView)
        }
        highscores.forEach { (score) in
            let subView = createSubLabel(for: score)
            scoresStackView.addArrangedSubview(subView)
        }
    }
    
    private func createSubLabel(for score:Score?) -> UILabel {
        let sub_text = (score != nil) ? "\(score!.points) \(score!.player_name ?? "")" : "No highscores yet..."
        let subLabel = createALLabel(text: sub_text, font: .systemFont(ofSize: 24))
        view.addSubview(subLabel)
        subLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return subLabel
    }
    
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        scoresStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80).isActive = true
        scoresStackView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        scoresStackView.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        scoresStackView.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        backHomeButton.topAnchor.constraint(equalTo: scoresStackView.bottomAnchor, constant: 80).isActive = true
        backHomeButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        backHomeButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        backHomeButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
    }
    
    @objc private func backHome(sender: UIButton!) {
        navigationController?.setViewControllers([HomeVC()], animated: true)
     }
    
}
