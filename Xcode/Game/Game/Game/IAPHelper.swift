//
//  IAPHelper.swift
//  Squares Adventure
//
//  Created by Pablo Henrique on 14/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import StoreKit

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static var sharedInstance = IAPHelper()
    
    
    var isPurchasing = false
    
    
    override init() {
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func requestProduct(productIdentifier: String) {
        
        if self.isPurchasing {
            return
        }
        
        self.isPurchasing = true
        GameStore.sharedInstance!.storeItensUpdateAvailable()
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set<String>(arrayLiteral: productIdentifier))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("productsRequest")
        print(request.description)
        print("didReceiveResponse")
        print(response.description)
        
        print("response.invalidProductIdentifiers")
        print(response.invalidProductIdentifiers.description)
        
        print(response.products.count)
        for product in response.products {
            print(product.localizedDescription)
            print(product.localizedTitle)
            print(product.price)
            print(product.productIdentifier)
            print("")
            
            SKPaymentQueue.defaultQueue().addPayment(SKPayment(product: product))
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("queue")
        print(queue.description)
        print("removedTransactions")
        print(transactions.description)
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print("queue")
        print(queue.description)
        print("restoreCompletedTransactionsFailedWithError")
        print(error.description)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        print("queue")
        print(queue.description)
        print("updatedDownloads")
        print(downloads.description)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("queue")
        print(queue.description)
        print("updatedTransactions")
        print(transactions.description)
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .Purchasing: // Transaction is being added to the server queue.
                print("Purchasing: \(transaction)")
                break
                
            case .Purchased: // Transaction is in queue, user has been charged.  Client should complete the transaction.
                print("Purchased: \(transaction)")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                self.isPurchasing = false
                GameStore.sharedInstance!.storeItensUpdateAvailable()
                GameStore.sharedInstance!.purchasedItem(transaction.payment.productIdentifier)
                
                break
                
            case .Failed: // Transaction was cancelled or failed before being added to the server queue.
                print("Failed: \(transaction)")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                self.isPurchasing = false
                GameStore.sharedInstance!.storeItensUpdateAvailable()
                break
                
            case .Restored: // Transaction was restored from user's purchase history.  Client should complete the transaction.
                print("Restored: \(transaction)")
                break
                
            case .Deferred: // The transaction is in the queue, but its final status is pending external action.
                print("Deferred: \(transaction)")
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("paymentQueueRestoreCompletedTransactionsFinished")
        print(queue.description)
    }
}






