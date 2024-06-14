//
//  SettingViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    let ud = UserDefaultsManager.shared
    
    let containerView = UIView()
    let containerButton = UIButton()
    lazy var profileImage = ProfileImageView(image: ud.profileImage, isSelect: true)
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let detailButton = UIButton()
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "SETTING"
        
        navigationController?.navigationBar.tintColor = MyColor.black
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    func configureHierarchy() {
        containerView.addSubview(profileImage)
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(detailButton)
        
        view.addSubview(containerView)
        view.addSubview(containerButton)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        containerButton.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.trailing.equalTo(detailButton.snp.leading)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.trailing.equalTo(detailButton.snp.leading)
            make.height.equalTo(30)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(30)
        }
    }
    
    func configureUI() {
        containerButton.addTarget(self, action: #selector(containerButtonTapped), for: .touchUpInside)
        
        nameLabel.font = Font.bold16
        nameLabel.textColor = MyColor.black
        
        dateLabel.font = Font.regular14
        dateLabel.textColor = MyColor.gray
        
        // data
        nameLabel.text = ud.nickname
        dateLabel.text = ud.signUpDateString
        detailButton.setImage(MyImage.right, for: .normal)
        detailButton.tintColor = MyColor.gray
    }
    
    @objc func containerButtonTapped() {
        // 닉네임 설정 화면으로 이동
        let vc = SettingNicknameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
