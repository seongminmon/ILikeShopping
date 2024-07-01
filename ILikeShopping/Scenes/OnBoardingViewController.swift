//
//  OnBoardingViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/13/24.
//

import UIKit
import SnapKit

final class OnBoardingViewController: BaseViewController {
    
    let appNameLabel = UILabel()
    let mainImageView = UIImageView()
    let startButton = OrangeButton(title: "시작하기")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubviews() {
        view.addSubview(appNameLabel)
        view.addSubview(mainImageView)
        view.addSubview(startButton)
    }
    
    override func configureLayout() {
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(mainImageView.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureView() {
        appNameLabel.text = "ILikeShopping"
        appNameLabel.font = MyFont.title
        appNameLabel.textColor = MyColor.orange
        appNameLabel.textAlignment = .center
        
        mainImageView.image = MyImage.launch
        mainImageView.contentMode = .scaleAspectFill
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped() {
        let vc = SettingNicknameViewController()
        navigate(vc: vc)
    }
}
