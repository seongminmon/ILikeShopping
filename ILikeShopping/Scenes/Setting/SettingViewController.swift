//
//  SettingViewController.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import UIKit

enum SettingCellTitle: String, CaseIterable {
    case shoppingList = "나의 장바구니 목록"
    case question = "자주 묻는 질문"
    case inquire = "1:1 문의"
    case alarm = "알림 설정"
    case delete = "탈퇴하기"
}

/* TODO: -
 - 장바구니 목록의 역할
    셀 선택 시 장바구니 탭으로 넘어가도록 구성하기
 */

final class SettingViewController: BaseViewController {
    
    let profileImageView = ProfileImageView(frame: .zero)
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let detailButton = UIButton()
    let containerView = UIView()
    let containerButton = UIButton()
    let separator = UIView()
    let tableView = UITableView()
    
    let ud = UserDefaultsManager.shared
    let repository = RealmRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tableView.reloadData()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "SETTING"
    }
    
    override func addSubviews() {
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(detailButton)
        
        view.addSubview(containerView)
        view.addSubview(containerButton)
        view.addSubview(tableView)
        view.addSubview(separator)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        containerButton.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(detailButton.snp.leading)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(detailButton.snp.leading)
            make.height.equalTo(30)
        }
        
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(30)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(tableView)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.3)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        containerButton.addTarget(self, action: #selector(containerButtonTapped), for: .touchUpInside)
        
        nameLabel.font = MyFont.bold16
        nameLabel.textColor = MyColor.black
        
        dateLabel.font = MyFont.regular14
        dateLabel.textColor = MyColor.gray
        
        separator.backgroundColor = MyColor.black
        
        detailButton.setImage(MyImage.right, for: .normal)
        detailButton.tintColor = MyColor.gray
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        tableView.rowHeight = 50
        tableView.isScrollEnabled = false
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorInsetReference = .fromCellEdges
        tableView.separatorColor = MyColor.black
    }
    
    func reloadData() {
        profileImageView.configureImageView(image: ud.profileImage, isSelect: true)
        nameLabel.text = ud.nickname
        dateLabel.text = signUpDateString(ud.signUpDate)
    }
    
    @objc func containerButtonTapped() {
        // 닉네임 설정 화면으로 이동
        let vc = SettingNicknameViewController()
        // 수정으로 설정
        vc.settingOption = .edit
        navigate(vc: vc)
    }
    
    func signUpDateString(_ date: Date?) -> String? {
        guard let date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        let str = formatter.string(from: date)
        return "\(str) 가입"
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingCellTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier,
            for: indexPath
        ) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        let option = SettingCellTitle.allCases[indexPath.row]
        if option == .shoppingList {
            cell.configureCell(title: option.rawValue, count: repository.fetchAll().count)
        } else {
            cell.configureCell(title: option.rawValue, count: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellTitle = SettingCellTitle.allCases[indexPath.row]
        switch cellTitle {
        case .delete: // 탈퇴하기
            showAlert(
                title: "탈퇴하기",
                message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?",
                actionTitle: "확인", actionStyle: .destructive
            ) { _ in
                // 모든 데이터 초기화
                self.ud.removeAll()
                // Realm 초기화
                self.repository.deleteAll()
                
                // 온보딩 화면으로 window 전환
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let vc = OnBoardingViewController()
                let nav = BaseNavigationController(rootViewController: vc)
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
        default:
            showSimpleAlert(title: "아직 준비 중이에요 :)", completionHandler: { _ in })
        }
    }
}
