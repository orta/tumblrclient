//
//  STNKeychainAccess.h
//  STNKeychainAccess
//
//  Created by Simon Stiefel on 01.08.06.
//  Copyright 2006 Simon Stiefel. All rights reserved.
//
//  $Id: STNKeychainAccess.h 5 2006-11-30 20:11:41Z sst $
//
//  Redistribution and use in source and binary forms, with or
//  without modification, are permitted provided that the
//  following conditions are met:
//
//  1. Redistributions of source code must retain the above
//  copyright notice, this list of conditions and the following
//  disclaimer.
//
//  2. Redistributions in binary form must reproduce the above
//  copyright notice, this list of conditions and the following
//  disclaimer in the documentation and/or other materials
//  provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOTLIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
//  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <Cocoa/Cocoa.h>


/*!
    @class       STNKeychainAccess 
    @superclass  NSObject
    @abstract    Handles keychain access
    @discussion  currently only generic passwords can be handled
*/
@interface STNKeychainAccess : NSObject {
    NSString *_serviceName;
    NSString *_accountName;
}

/*!
    @method     initWithServiceName:accountName:
    @abstract   initializes object with service name and account name
    @discussion initializes instance of class with service name and account name. Both can be changed later.
    @param      serviceName service name
    @param      accountName account name
    @result     STNKeychainAccess object
*/
- (id)initWithServiceName:(NSString *)serviceName
              accountName:(NSString *)accountName;

/*!
    @method     setServiceName:
    @abstract   sets service name
    @discussion sets or overwrites service name
    @param      serviceName name of service
*/
- (void)setServiceName:(NSString *)serviceName;

/*!
    @method     serviceName
    @abstract   returns current service name
    @result     service name
*/
- (NSString *)serviceName;

/*!
    @method     setAccountName:
    @abstract   sets account name
    @discussion sets or overwrites account name
    @param      accountName name of account
*/
- (void)setAccountName:(NSString *)accountName;

/*!
    @method     accountName
    @abstract   returns current account name
    @result     account name
*/
- (NSString *)accountName;

/*!
    @method     savePassword:
    @abstract   saves or updates password in keychain
    @discussion saves or updates password in keychain to parameter password. Password is automatically updated if password entry already exists
    @param      password new password
    @result     error code, noErr on success (see http://developer.apple.com/documentation/Security/Reference/keychainservices/Reference/reference.html#//apple_ref/doc/uid/TP30000898-CH5g-95690)
*/
- (OSStatus)savePassword:(NSString *)password;

/*!
    @method     getPassword:itemReference:
    @abstract   fetches current password from keychain and stores it in parameter password
    @discussion fetches password from keychain database and writes it in the password parameter
    @param      password pointer to NSString pointer
    @param      itemRef On return, a pointer to the item of the generic password. Pass nil if you don't want to obtain this object.
    @result     error code, noErr on success (see http://developer.apple.com/documentation/Security/Reference/keychainservices/Reference/reference.html#//apple_ref/doc/uid/TP30000898-CH5g-95690)
*/
- (OSStatus)getPassword:(NSString **)password
          itemReference:(SecKeychainItemRef *)itemRef;

- (NSString *)getPassword;
+ (BOOL)checkForExistanceOfKeychainItem:(NSString *)keychainItemName withItemKind:(NSString *)keychainItemKind forUsername:(NSString *)username;

@end
