//
//  main.m
//  smsios_iOS6
//
//  Created by Meirtz on 13-8-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

int main (int argc, const char * argv[])
{

    @autoreleasepool
    {	
    	// insert code here...
        sqlite3 *databaseSms;
        int idMessage = 0;
        if (sqlite3_open("/var/mobile/Library/SMS/sms.db", &databaseSms) == SQLITE_OK)
        {
            sqlite3_stmt *statement;
            sqlite3_stmt *statementHandleID;
            NSMutableDictionary *msIDDict = [[NSMutableDictionary alloc] init];
            
            //add senders' information into msIDDict 
            if (sqlite3_prepare_v2(databaseSms, "SELECT id,rowid from handle", -1, &statementHandleID, nil) == SQLITE_OK)
            {
                while ( sqlite3_step(statementHandleID) == SQLITE_ROW )
                {
                    [msIDDict setValue:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statementHandleID, 0) encoding:NSUTF8StringEncoding] forKey:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statementHandleID, 1) encoding:NSUTF8StringEncoding]];
                }
            }
            //find message and print
            if (sqlite3_prepare_v2(databaseSms, "SELECT text,handle_id,is_from_me,account from message order by date desc", -1, &statement, nil) == SQLITE_OK)
            {
                
                while ( sqlite3_step(statement) == SQLITE_ROW )
                {
                    idMessage += 1;
                    NSString *text = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                    NSString *account = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
                    if (sqlite3_column_int(statement, 2) == 0)
                    {
                        account = [msIDDict valueForKey:[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding]];
                    }
                    printf("---------------***************---------------\n");
                    printf("Message:%i\n",idMessage);
                    
                    if ( text == NULL )
                    {
                        printf("Text:Bad Text\n");
                    }
                    else
                    {
                        printf("Text:%s\n",[text UTF8String]);
                    }
                    if ( account == NULL)
                    {
                        printf("Account:Bad account\n");
                    }
                    else
                    {
                        printf("Account:%s\n",[account UTF8String]);
                    }
                    
                }
            }
        }
    }
	return 0;
}

