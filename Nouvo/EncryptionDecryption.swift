//
//  EncryptionDecryption.swift
//  MauBank
//
//  Created by Winjit-Suyog on 2018/02/13.
//  Copyright © 2018 Winjit Technologies. All rights reserved.
//

import UIKit
import CryptoSwift

/// This class is used to encrypt and decrypt the request and to create a key
class EncryptionDecryption: NSObject {

    //MARK: - Variable declaration
    static let shared = EncryptionDecryption()
    var strIV : [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    
    
    /// Get the encrypted string
    ///
    /// - Parameters:
    ///   - strInput: String to Encrypt
    ///   - deviceId: device Id in string format
    ///   - custId: cust id in string format
    ///   - index: index in string format
    /// - Returns: return string
    func getEncryptedString(strInput:String = "", deviceId:String = "", custId:String = "", index:String = "") -> String
    {
        let password = generatePassWord(deviceId: deviceId, custId: custId, index: index)
        return encryptString(key:password, strInput: strInput)
    }
    
    /// Get the decrypted string
    ///
    /// - Parameters:
    ///   - strInput: String to Encrypt
    ///   - deviceId: device Id in string format
    ///   - custId: cust id in string format
    ///   - index: index in string format
    /// - Returns: return string
    func getDecryptedString(strInput:String = "", deviceId:String = "", custId:String = "", index:String = "") -> String
    {
        
        let password = generatePassWord(deviceId: deviceId, custId: custId, index: index)
        return decryptString(key:password, strInput: strInput)
    }
    
    
    /// Function to get the string
    ///
    /// - Parameters:
    ///   - deviceId: deviceId
    ///   - custId: cust id
    ///   - index: index
    /// - Returns: return string
    func generatePassWord(deviceId:String = "", custId:String = "", index:String = "") -> String
    {
        let concatString = deviceId + custId //Get the concatenated string
        if let indx = UInt(index)
        {
            return MBEncryptorAES.createPassword(concatString, withLength: indx)
        }
        else
        {
            return MBEncryptorAES.createPassword(concatString, withLength: 0)
        }
    }
    
    /// Do Encrypt of string
    ///
    /// - Parameters:
    ///   - key: key in string
    ///   - strInput: strInput string to encrypt
    /// - Returns: return encrypted string
    func encryptString(key: String, strInput: String) -> String
    {
        let strAESKey : [UInt8] = Array(key.utf8)
        do
        {
            let encrypted = try strInput.aesEncryptOFB(key: strAESKey, iv: strIV)
            return encrypted
        }
        catch let error{
            return ""
        }
    }
    
    /// Do Decrypt of string
    ///
    /// - Parameters:
    ///   - key: key in string
    ///   - strInput: strInput string to decrypt
    /// - Returns: return decrypted string
    func decryptString(key: String, strInput: String) -> String
    {
        let strAESKey : [UInt8] = Array(key.utf8)
        do
        {
            let decrypted = try strInput.aesDecrypt(key: strAESKey, iv: strIV)
            return decrypted
        }
        catch let error{
            return ""
        }
    }
    
    
    /// Function to generate index
    ///
    /// - Returns: return index
    func generateIndex(length: Int) -> Int
    {
        let maxLimit = 15
        let index = Int(arc4random_uniform(UInt32(maxLimit)))
        return index
    }
    
//
//    /// Function to do the Tripple DES Encryption
//    ///
//    /// - Parameters:
//    ///   - debitCardNo: Debit card No
//    ///   - atmPin: ATM pin
//    /// - Returns: return encrypted string
//    func trippleDESEncryption(debitCardNo:String, atmPin:String)->String
//    {
//        return MBEncryptorAES.doTrippleDES(debitCardNo, withATMPin: atmPin, enc: 0, withKey:MBConstant.shared.trippleDesKey)
//    }
//
//
//    /// Function to get the sha1 string
//    ///
//    /// - Parameter str: string
//    /// - Returns: retrun string
//    func getSHA1(str: String)-> String
//    {
//        let strInput = str + "+" + MBConstant.shared.sha1Key
//        return MBEncryptorAES.sha1(strInput)
//    }
//
//    /// Function to get the sha1 string from cif and mobile number
//    ///
//    /// - Parameter cif: string
//    /// - Parameter mobNo: string
//    /// - Returns: retrun string
//    func getSHA1(cif: String, mobNo: String)-> String
//    {
//        let strInput = cif + "+" + mobNo + "+" + MBConstant.shared.sha1KeyForCardless
//        return MBEncryptorAES.sha1(strInput)
//    }
//
//    /// Function to get the sha1 string for registration
//    ///
//    /// - Parameter cardNo: string
//    /// - Parameter pin: string
//    /// - Returns: retrun string
//    func getSHA1ForRegistration(cardNo: String, pin: String)-> String
//    {
//        let strInput = cardNo + "+" + pin + "+" + MBConstant.shared.sha1Key
//        return MBEncryptorAES.sha1(strInput)
//    }
//
//    /// Function to get the sha1 string from cif, surname and nic
//    ///
//    /// - Parameter cif: string
//    /// - Parameter mobNo: string
//    /// - Parameter surname: string
//    /// - Parameter nicNumber: string
//    /// - Returns: retrun string
//    func getSHA1(cif: String, surname: String, nicNumber: String)-> String
//    {
//        let strInput = CodeOfOperation.CreateCard.rawValue + "+" + cif.uppercased() + "+" + surname.uppercased() + "+" + nicNumber + "+" + MBConstant.shared.sha1Key
//        return MBEncryptorAES.sha1(strInput)
//    }
//
//    /// Function to get the sha1 string from cif and surname
//    ///
//    /// - Parameter cif: string
//    /// - Parameter pin: string
//    /// - Returns: retrun string
//    func getSHA1ForSetATMPin(cif: String, pin: String)-> String
//    {
//        let strInput = CodeOfOperation.PinDefinition.rawValue + "+" + cif + "+" + pin.uppercased() + "+" + MBConstant.shared.sha1Key
//        return MBEncryptorAES.sha1(strInput)
//    }
//
//    /// Function to get the 3DES string from cif and mpin
//    ///
//    /// - Parameter mpin: string
//    /// - Returns: retrun string
//    func generate3DESForMpin(mpin: String)-> String
//    {
//        return MBEncryptorAES.encrypt(mpin, key: MBConstant.shared.TrippleDESKeyForMpin, iv: MBConstant.shared.ivForMpin)
//    }
//
//
//    /// Function to Encrypt the String
//    ///
//    /// - Parameter strInput: string
//    /// - Returns: retrun string
//    func generate3DESForFPLogin(strInput:String) -> String
//    {
//        return MBEncryptorAES.encrypt(strInput, key: MBConstant.shared.TrippleDESKeyForMpin, iv: MBConstant.shared.ivForMpin)
//    }
    
    /// Function to get Tripple DES value
    ///
    /// - Parameter value: string
    /// - Returns: retrun string
    func encrypt3DESForUserDefaults(value: String)-> String
    {
        return MBEncryptorAES.encrypt(value, key: Bundle.main.bundleIdentifier!, iv: "px6cUAx1")
    }
    
    /// Function to decrypt 3ES
    ///
    /// - Parameter value: string
    /// - Returns: retrun string
    func decrypt3DESForUserDefaults(value: String)-> String
    {
        return MBEncryptorAES.decrypt(value, key: Bundle.main.bundleIdentifier!, iv: "px6cUAx1")
    }
}


// MARK: - String Extension for Encryption and Decryption
extension String {
    /// Function to decrypt data
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: IV
    /// - Returns: base 64 string
    /// - Throws: exception if any
    func aesEncryptOFB(key: [UInt8], iv: [UInt8]) throws -> String{
        let data = self.data(using: String.Encoding.utf8)
        //let enc = try AES(key: key, iv: iv, blockMode:.OFB, padding: .pcks7).encrypt(data!.bytes)
        let enc = try AES(key: key, blockMode: OFB(iv: iv), padding: .pkcs5).encrypt(data!.bytes)
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let result = String(base64String)
        return result
    }
    
    
    /// Function to decrypt data
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: IV
    /// - Returns: base 64 string as output
    /// - Throws: exception if any
    
    func decryptAES(key: String, iv: String) -> String {
        do {
            let encrypted = self
            let key = Array(key.utf8)
            let iv = Array(iv.utf8)
            let aes = try AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
            let decrypted = try aes.decrypt(Array(hex: encrypted))
            return String(data: Data(decrypted), encoding: .utf8) ?? ""
        } catch {
            return "Error: \(error)"
        }
    }
    func aesDecrypt(key: [UInt8], iv: [UInt8]) throws -> String {
        do {
            let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 1))
            //let dec = try AES(key: key, iv: iv, blockMode: .OFB, padding: .pcks7).decrypt(data!.bytes)
            let dec = try AES(key: key, blockMode: OFB(iv: iv), padding: .pkcs5).decrypt(data!.bytes)
            let decData = NSData(bytes: dec, length: Int(dec.count))
            if let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
            {
                return result as String
            }
            else
            {
                return ""
            }
        }
        catch let err as NSError{
        }
        return ""
    }
    
    // utf8 encode a string
    func encodeStringWithUTF8()->String
    {
        let temp = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        return temp!
    }
}
