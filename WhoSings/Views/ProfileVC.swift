//
//  ProfileVC.swift
//  WhoSings
//
//  Created by netfarm on 06/04/21.
//

import UIKit

let LAST_SCORES = Bundle.main.object(forInfoDictionaryKey: "LAST_SCORES") as! Int

class ProfileVC: DarkVC {
    
    let titleLabel:UILabel = createALLabel(text: WhoSingsManager.sharedInstance.player_name, font: .systemFont(ofSize: 36, weight: .regular), textAlign: .center)
    
    let scoresStackView:UIStackView = createALStackView(spacing: 16)
    
    let logOutButton:UIButton = createBorderALButton(title: "Log out")
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
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        backHomeButton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
    }
    
    private func assignUItoView(){
        view.addSubview(titleLabel)
        view.addSubview(scoresStackView)
        view.addSubview(backHomeButton)
        view.addSubview(logOutButton)
    }
    
    private func createScoreSubViews(){
        let playerScores = WhoSingsManager.sharedInstance.getPlayerScores(quantity: LAST_SCORES)
        if playerScores.isEmpty {
            let subView = createSubLabel(for: nil)
            scoresStackView.addArrangedSubview(subView)
        }
        playerScores.forEach { (score) in
            let subView = createSubLabel(for: score)
            scoresStackView.addArrangedSubview(subView)
        }
    }
    
    private func createSubLabel(for score:Score?) -> UILabel {
        let sub_text = (score != nil) ? "\(score!.points) \(score!.player_name ?? "")" : "No scores yet..."
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
        
        logOutButton.topAnchor.constraint(equalTo: backHomeButton.bottomAnchor, constant: 24).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        logOutButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        logOutButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
    }
    
    @objc private func backHome(sender: UIButton!) {
        navigationController?.setViewControllers([HomeVC()], animated: true)
    }
    
    @objc private func logOut(sender: UIButton!) {
        WhoSingsManager.sharedInstance.player_name = nil
        navigationController?.setViewControllers([HomeVC()], animated: true)
    }
    
}
