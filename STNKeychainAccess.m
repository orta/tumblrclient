//
//  STNKeychainAccess.m
//  STNKeychainAccess
//
//  Created by Simon Stiefel on 01.08.06.
//  Copyright 2006 Simon Stiefel. All rights reserved.
//
//  $Id: STNKeychainAccess.m 5 2006-11-30 20:11:41Z sst $
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

#import "STNKeychainAccess.h"
#import <Security/Security.h>


@implementation STNKeychainAccess

- (id)initWithServiceName:(NSString *)serviceName
              accountName:(NSString *)accountName
{
    self = [super init];
    if (self != nil) {
        [self setAccountName:accountName];
        [self setServiceName:serviceName];
    }
    return self;
}

- (id) init {
    return [self initWithServiceName:nil accountName:nil];
}

- (void)setServiceName:(NSString *)serviceName
{
    [_serviceName release];
    _serviceName = [serviceName copy];
}

- (NSString *)serviceName
{
    return _serviceName;
}

- (void)setAccountName:(NSString *)accountName
{
    [_accountName release];
    _accountName = [accountName copy];
}

- (NSString *)accountName
{
    return _accountName;
}

- (OSStatus)savePassword:(NSString *)password
{
    NSString *tempPassword = nil;
    SecKeychainItemRef itemRef;
    OSStatus status;
    
    // check if keychain entry already exists
    if ([self getPassword:&tempPassword
            itemReference:&itemRef] == noErr) {
        // entry exists - check if password differs
        if (! [tempPassword isEqualToString:password]) {
            
            // differs - change it
            SecKeychainAttribute attrs[] = {
            { kSecAccountItemAttr, [_accountName cStringLength], [_accountName cString] },
            { kSecServiceItemAttr, [_serviceName cStringLength], [_serviceName cString] } };
            
            const SecKeychainAttributeList attributes = { sizeof(attrs) / sizeof(attrs[0]), attrs };
            
            status = SecKeychainItemModifyAttributesAndData(itemRef,
                                                            &attributes,
                                                            [password cStringLength],
                                                            [password cString]);
            if (status != noErr) {
                log(@"STN: Error while updating keychain data: %d", status);
            }         
            return status;
        } else {
            // doesn't differ - all ok
            return noErr;
        }
    } else {
        // no entry - add it
        return SecKeychainAddGenericPassword(NULL,
                                             [_serviceName cStringLength],
                                             [_serviceName cString],
                                             [_accountName cStringLength],
                                             [_accountName cString],
                                             [password cStringLength],
                                             [password cString],
                                             NULL);
    }
}

- (OSStatus)getPassword:(NSString **)password
          itemReference:(SecKeychainItemRef *)itemRef
{
    void *passwordData;
    UInt32 passwordLength;
    
    OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                     [_serviceName cStringLength],
                                                     [_serviceName cString],
                                                     [_accountName cStringLength],
                                                     [_accountName cString],
                                                     &passwordLength,
                                                     &passwordData,
                                                     itemRef);
    
    if (status != errSecItemNotFound) {
        if (*password != nil) {
            [*password release];
        }
        *password = [NSString stringWithCString:(char *)passwordData];
        SecKeychainItemFreeContent(NULL, passwordData);
    } else {
        *password = nil;
    }

    return status;
}
+ (BOOL)checkForExistanceOfKeychainItem:(NSString *)keychainItemName forUsername:(NSString *)username
{
	SecKeychainSearchRef search;
	SecKeychainItemRef item;
	SecKeychainAttributeList list;
	SecKeychainAttribute attributes[3];
    OSErr result;
    int numberOfItemsFound = 0;
	
	attributes[0].tag = kSecAccountItemAttr;
    attributes[0].data = [username cString];
    attributes[0].length = [username length];
    
	attributes[1].tag = kSecLabelItemAttr;
    attributes[1].data = [keychainItemName cString];
    attributes[1].length = [keychainItemName length];

    list.count = 2;
    list.attr = &attributes;

    result = SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);

    if (result != noErr) {
        log (@"STN: status %d from SecKeychainSearchCreateFromAttributes\n", result);
    }
    
	while (SecKeychainSearchCopyNext (search, &item) == noErr) {
        CFRelease (item);
        numberOfItemsFound++;
    }
	
    CFRelease (search);
	return numberOfItemsFound;
}

- (NSString *)getPassword
{
    SecKeychainSearchRef search;
    SecKeychainItemRef item;
    SecKeychainAttributeList list;
    SecKeychainAttribute attributes[3];
    OSErr result;
    int i = 0;

		attributes[0].tag = kSecLabelItemAttr;
    attributes[0].data = [_serviceName cString];
    attributes[0].length = [_serviceName length];
    
		attributes[1].tag = kSecAccountItemAttr;
    attributes[1].data = [_accountName cString];
    attributes[1].length = [_accountName length];

    list.count = 2;
    list.attr = &attributes;

    result = SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
    if (result != noErr) {
        log (@"STN: status %d from SecKeychainSearchCreateFromAttributes\n", result);
    }
	
    NSString *password = @"error";
    if (SecKeychainSearchCopyNext (search, &item) == noErr) {
		password = [self getPasswordFromSecKeychainItemRef:item];
		CFRelease(item);
		CFRelease (search);
	}
	return password;
}

- (NSString *)getPasswordFromSecKeychainItemRef:(SecKeychainItemRef)item
{
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
    OSStatus status;
	
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
 
    list.count = 4;
    list.attr = attributes;

    status = SecKeychainItemCopyContent (item, NULL, &list, &length, 
                                         (void **)&password);

    // use this version if you don't really want the password,
    // but just want to peek at the attributes
    //status = SecKeychainItemCopyContent (item, NULL, &list, NULL, NULL);
		if (status == -25293) {
			//password has been typed in wrong too many times
			return @"##THISisApasswordNOONEshouldHAVE##";
		}	
		if (status == -128) {
  			//user has hit deny
  			return @"##THISisApasswordNOONEshouldHAVE##";
  	}					
    // make it clear that this is the beginning of a new
    // keychain item
    if (status == noErr) {
        if (password != NULL) {

            // copy the password into a buffer so we can attach a
            // trailing zero byte in order to be able to print
            // it out with printf
            char passwordBuffer[1024];

            if (length > 1023) {
                length = 1023; // save room for trailing \0
            }
            strncpy (passwordBuffer, password, length);

            passwordBuffer[length] = '\0';
			//printf ("passwordBuffer = %s\n", passwordBuffer);
			return [NSString stringWithCString:passwordBuffer];
        }

        SecKeychainItemFreeContent (&list, password);

    } else {
      printf("STNKeychain Error = %d\n", (int)status);
      return @"ERROR";
    }
}

@end
