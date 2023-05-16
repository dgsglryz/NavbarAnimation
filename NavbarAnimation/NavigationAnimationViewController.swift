//
//  NavigationAnimationViewController.swift
//  NavbarAnimation
//
//  Created by Dogus Guleryuz on 15.05.2023.
//

import UIKit

class NavigationAnimationViewController: UIViewController {
  
  let snackImages = ["oreos", "pizza_pockets", "pop_tarts", "popsicle", "ramen"]
  var selectedItems = [String]()
  let reusableCellId = "Cells"
  
  private let customNavBar = NavBarView()
  private let addButton = PlusButton()
  private let navStackContainer = NavStackView()
  private let snackTableView = SnacksTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupSubviews()
    setupConstraints()
    setupTableView()
  }
  
  private func setupSubviews() {
    view.addSubview(snackTableView)
    view.addSubview(customNavBar)
    view.addSubview(addButton)
    customNavBar.addSubview(navStackContainer)
    
    navStackContainer.isHidden = true
    addButton.addTarget(self, action: #selector(pushBtn(_:)), for: .touchUpInside)
    navStackContainer.setupImageViews(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
  }
  
  private func setupConstraints() {
    customNavBar.setupConstraints(view: view)
    addButton.setupConstraints(view: view)
    navStackContainer.setupConstraints(view: view, navBar: customNavBar)
    snackTableView.setupConstraints(view: view, navBar: customNavBar)
  }
  
  private func setupTableView() {
    snackTableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellId)
    snackTableView.dataSource = self
    snackTableView.delegate = self
  }
  
  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    print("image tapped")
    if let i = tapGestureRecognizer.view?.tag {
      selectedItems.append(snackImages[i])
      let indexPath = IndexPath(row: selectedItems.count - 1, section: 0)
      snackTableView.insertRows(at: [indexPath], with: .automatic)
    }
  }
  
  @objc func pushBtn(_ sender: UIButton) {
    if navStackContainer.isHidden {
      animateNavBarExpansion()
    } else {
      animateNavBarCollapse()
    }
  }
  
  private func animateNavBarExpansion() {
    navStackContainer.isHidden = false
    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
      self.customNavBar.transform = CGAffineTransform(scaleX: 1.0, y: 3.5)
      self.addButton.transform = CGAffineTransform(rotationAngle: .pi/4)
      self.snackTableView.contentInset = UIEdgeInsets(top: self.customNavBar.bounds.height + 15, left: 0, bottom: 0, right: 0)
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  private func animateNavBarCollapse() {
    navStackContainer.isHidden = true
    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
      self.customNavBar.transform = .identity
      self.addButton.transform = .identity
      self.snackTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

extension NavigationAnimationViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath)
    cell.textLabel?.text = selectedItems[indexPath.row]
    return cell
  }
}

class NavBarView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.gray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupConstraints(view: UIView) {
    self.heightAnchor.constraint(equalToConstant: 88).isActive = true
    self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
    self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
  }
}

class PlusButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.setTitle("＋", for: .normal)
    self.setTitleColor(.darkGray, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupConstraints(view: UIView) {
    self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5).isActive = true
    self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
  }
}

class NavStackView: UIStackView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.distribution = .fillEqually
    self.axis = .horizontal
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupConstraints(view: UIView, navBar: NavBarView) {
    self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    self.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    self.leftAnchor.constraint(equalTo: navBar.leftAnchor).isActive = true
    self.widthAnchor.constraint(equalTo: navBar.widthAnchor).isActive = true
  }
  
  func setupImageViews(target: Any?, action: Selector) {
    let snackImages = ["oreos", "pizza_pockets", "pop_tarts", "popsicle", "ramen"]
    
    for (index, imageName) in snackImages.enumerated() {
      guard let image = UIImage(named: imageName) else {
        print("ERROR: \(imageName)")
        continue
      }
      let imageView = UIImageView(image: image)
      imageView.isUserInteractionEnabled = true
      imageView.tag = index
      
      let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
      imageView.addGestureRecognizer(tapGestureRecognizer)
      self.addArrangedSubview(imageView)
    }
  }
  
}

class SnacksTableView: UITableView {
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupConstraints(view: UIView, navBar: NavBarView) {
    self.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0).isActive = true
    self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
  }
}
