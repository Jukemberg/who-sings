//
//  HomeVC.swift
//  WhoSings
//
//  Created by netfarm on 06/04/21.
//

import UIKit

class HomeVC: DarkVC {
    
    let titleImage:UIImageView = createALImage(from: "appLogo")
    
    let profileButton:UIButton = createALButton(type: .custom, title: WhoSingsManager.sharedInstance.player_name, font: .systemFont(ofSize: 24), image: UIImage(imageLiteralResourceName: "user"))
    
    let newGameButton:UIButton = createBorderALButton(title: "New Game")
    let highScoresButton:UIButton = createBorderALButton(title: "High Scores")
    
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
        profileButton.semanticContentAttribute = .forceRightToLeft
        profileButton.addTarget(self, action: #selector(seeProfile), for: .touchUpInside)
        newGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        highScoresButton.addTarget(self, action: #selector(seeHighScores), for: .touchUpInside)
    }
    
    private func assignUItoView(){
        view.addSubview(profileButton)
        view.addSubview(titleImage)
        view.addSubview(newGameButton)
        view.addSubview(highScoresButton)
    }
    
    private func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        
        profileButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        profileButton.rightAnchor.constraint(equalTo:guide.rightAnchor, constant: -16).isActive = true
        
        titleImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: 80).isActive = true
        titleImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        titleImage.widthAnchor.constraint(equalToConstant: 240).isActive = true
        titleImage.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        newGameButton.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 80).isActive = true
        newGameButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        newGameButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        newGameButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
        
        highScoresButton.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 24).isActive = true
        highScoresButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        highScoresButton.leftAnchor.constraint(greaterThanOrEqualTo:guide.leftAnchor, constant: 16).isActive = true
        highScoresButton.rightAnchor.constraint(greaterThanOrEqualTo: guide.rightAnchor, constant: -16).isActive = true
    }
    
    @objc private func seeProfile(sender: UIButton!) {
        if WhoSingsManager.sharedInstance.player_name == DEFAULT_PLAYER{
            let alertController = WhoSingsManager.sharedInstance.getPlayerNameAlert { (player_name) in
                self.profileButton.setTitle(player_name, for: .normal)
                self.navigationController?.pushViewController(ProfileVC(), animated: true)
            }
            present(alertController, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(ProfileVC(), animated: true)
        }
    }
    
    @objc private func startGame(sender: UIButton!) {
        let alertController = WhoSingsManager.sharedInstance.getPlayerNameAlert { (player_name) in
            self.profileButton.setTitle(player_name, for: .normal)
            self.navigationController?.pushViewController(QuizCardVC(), animated: true)
        }
        present(alertController, animated: true, completion: nil)
     }
    
    @objc private func seeHighScores(sender: UIButton!) {
        navigationController?.pushViewController(HighScoresVC(), animated: true)
    }
}
