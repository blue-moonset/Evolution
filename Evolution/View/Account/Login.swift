//
//  Login.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 10/03/2023.
//

import SwiftUI
import AuthenticationServices

struct Login: View {
    @State var name = ""
    var body: some View {
        SignUpWithAppleView(name:$name)
            .frame(width: 200, height: 50)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
struct SignUpWithAppleView: UIViewRepresentable {
    @Binding var name : String
    
    func makeCoordinator() -> AppleSignUpCoordinator {
        return AppleSignUpCoordinator(self)
    }
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton    {
        //Creating the apple sign in button
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                  authorizationButtonStyle: .black)
        button.cornerRadius = 10
        //Adding the tap action on the apple sign in button
        button.addTarget(context.coordinator, action: #selector(AppleSignUpCoordinator.didTapButton),for: .touchUpInside)
        return button
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

class AppleSignUpCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var parent: SignUpWithAppleView?
    init(_ parent: SignUpWithAppleView) {
        self.parent = parent
        super.init()
    }
    @objc func didTapButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return (window?.rootViewController?.view.window!)!
    }
    
    func authorizationController(controller: ASAuthorizationController,didCompleteWithAuthorization authorization: ASAuthorization)
    {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("credentials not found….")
            return
        }
        //Storing the credential in user default for demo purpose only deally we should have store the credential in Keychain
        let defaults = UserDefaults.standard
        defaults.set(credentials.user, forKey: "userId")
        parent?.name = "\(credentials.fullName?.givenName ?? "")"
    }
    //If authorization faced any issue then this method will get triggered
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //If there is any error will get it here
        print("Error In Credential")
    }
}
