//
//  CompositionlVIew.swift
//  AppStore
//
//  Created by t19960804 on 1/18/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import SwiftUI


//在SwiftUI中加入UIKit的view / viewController,需服從UIViewControllerRepresentable
struct AppsView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<AppsView>) -> UIViewController {
        let vc = CompositionalCollectionViewController()
        return UINavigationController(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppsView>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
    
}

struct CompositionlVIew_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
