//
//  tumb_main.m
//  Tumblg
//
//  Created by orta on 16/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <stdlib.h>
#import "PostController.h"
#import "ConnectionController.h"


int main (int argc, char* argv[]){
  
  
  // -f : filename
  // -u : username
  // -p : password
  
  int ch;
  bool somethingFound = false;
  NSString * username;
  NSString * password;
  
  while (( ch = getopt(argc, argv, "f:u:p:d:")) != -1 )  {
    switch (ch) {
      case 'u':
        //username = [NSString stringWithCString: encoding:<#(NSStringEncoding)enc#>];
        break;
      
      case 'p':
        password = [NSString stringWithFormat:@"%s", optarg];
        break;
        
      case 'f':
        printf("F found!");
        printf("arg = %s", optarg);
        somethingFound = true;
        
        if(username = nil){
          
          ConnectionController *cc =  [[ConnectionController alloc] init];
          username = [cc password];
          password = [cc password];
        }
        break;
      default:
        break;
    }
  }

  if(somethingFound == false){
    printf("Tumblg's command line helper: \n");  
    printf("\tusage: tumb [-u username] [-p password] [-f filepath] [-d description] \n");
  }else{
    NSLog(@"u = %@, p = %@",username, password);

  }
  
}