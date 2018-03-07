//
//  User.swift
//  tech-portail-mobile-ios
//
//  Created by Anas MERBOUH on 17-10-08.
//  Copyright © 2017 Équipe Team 3990 : Tech For Kids. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct User {
    let currentUser = Auth.auth().currentUser
    
    public var group: String?
    public var homePhoneNumber1: String?
    public var homePhoneNumber2: String?
    public var mobilePhoneNumber: String?
    public var professionalTitle: String?
    public var roles: [String: Bool]?
    
    public var uid: String {
        guard let currentUser = self.currentUser else { return "No user found" }
        
        return currentUser.uid
    }
    
    public var email: String {
        guard let currentUser = self.currentUser else { return "No user found" }
        guard let email = currentUser.email else { return "User has no email" }
        
        return email
    }
    
    public var displayName: String {
        guard let currentUser = self.currentUser else { return "No user found" }
        guard let displayName = currentUser.displayName else { return "User has no display name" }
        
        return displayName
    }
    
    public func shouldSignIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return false
        } else {
            return true
        }
    }
    
    public func signUp(withDisplayName displayName: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(error)
                return
            }
            
            
            guard let user = user else { return }
            user.createProfileChangeRequest().displayName = displayName
            user.createProfileChangeRequest().commitChanges(completion: { (error) in
                if let error = error {
                    completion(error)
                    return
                }
            })
        }
    }
    
    public func signIn(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (nil, error) in
            if let error = error {
                completion(error)
            }
        }
    }
    
    public func sendPasswordReset(withEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
    
    public func updateEmail(to email: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = self.currentUser else { return }
        
        currentUser.updateEmail(to: email) { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
    
    public func updatePassword(to password: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = self.currentUser else { return }
        
        currentUser.updatePassword(to: password) { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
    
    public func attendToEvent(withPath eventReference: DocumentReference, from: Date, to: Date, completion: @escaping (Error?) -> Void) {
        //
        let batch = Firestore.firestore().batch()
        let attendanceData: [String: Any] = ["attendant": self.displayName, "present": true, "from": from, "to": to, "timestamp": FieldValue.serverTimestamp()]
        
        //
        let eventAttendanceReference = eventReference.collection("attendances").document(self.uid)
        let userAttendanceReference = Firestore.firestore().collection("users").document(self.uid).collection("attendances").document(eventReference.documentID)
        
        batch.setData(attendanceData, forDocument: eventAttendanceReference)
        batch.setData(attendanceData, forDocument: userAttendanceReference)
        
        batch.commit { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
}
