//
//  PaymentHandler.swift
//  RFOXIA
//
//  Created by Yasser Yasser on 22/04/2025.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class ApplePayHandler : NSObject{
    
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummary = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    func startApplePay(completion : @escaping PaymentCompletionHandler){
        completionHandler = completion
        
        paymentSummary = []
        
        paymentSummary.append(PKPaymentSummaryItem(label: "Total",
                                                   amount: 9.99,
                                                   type: .final))
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummary
        paymentRequest.merchantIdentifier = "merchant.2jd4vk6g4v2prs6z"
        paymentRequest.merchantCapabilities = .threeDSecure
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex, .discover]
        paymentRequest.currencyCode = "USD"
        paymentRequest.countryCode = "US"
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        
        paymentController?.present(completion: {presented in
            if presented {
                debugPrint("Presented Payment Controller")
            }else{
                debugPrint("Failed to present payment controller")
            }
        })
    }
}

extension ApplePayHandler : PKPaymentAuthorizationControllerDelegate{
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let errors = [Error]()
        let status =  PKPaymentAuthorizationStatus.success
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss{
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.paymentStatus == .success{
                    strongSelf.completionHandler?(true)
                }
                else{
                    strongSelf.completionHandler?(false)
                }
            }
        }
    }
    
}
