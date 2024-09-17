import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelect index: Int)
}

import UIKit

final class SegmentedControl: UIView {
    
    weak var delegate: SegmentedControlDelegate?
    
    private let separatorView = UIView()
    private let allButton = SegmentedControlButton(title: "All", count: 0)
    private let openButton = SegmentedControlButton(title: "Open", count: 0)
    private let closedButton = SegmentedControlButton(title: "Closed", count: 0)
    
    private var buttons: [SegmentedControlButton] = []
    private var selectedIndex: Int = 0
    
    init(allCount: Int = 0, openCount: Int = 0, closedCount: Int = 0) {
        super.init(frame: .zero)
        
        allButton.updateCount(allCount)
        openButton.updateCount(openCount)
        closedButton.updateCount(closedCount)
        
        buttons = [allButton, openButton, closedButton]
        
        for (index, button) in buttons.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
            button.addGestureRecognizer(tapGesture)
            button.tag = index
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = ColorPalette.Outline.light
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(allButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(openButton)
        stackView.addArrangedSubview(closedButton)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateSelectedOption(animated: false)
    }
    
    private func updateSelectedOption(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) { [weak self] in
            self?.buttons.forEach {
                $0.isSelected = $0.tag == self?.selectedIndex
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let button = sender.view as? SegmentedControlButton else { return }
        selectedIndex = button.tag
        updateSelectedOption(animated: true)
        delegate?.segmentedControl(self, didSelect: selectedIndex)
    }
    
    func updateCounts(all: Int, open: Int, closed: Int) {
        allButton.updateCount(all)
        openButton.updateCount(open)
        closedButton.updateCount(closed)
    }
    
    func selectSegment(index: Int) {
        selectedIndex = index
        updateSelectedOption(animated: true)
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex
    }
}
