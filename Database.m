//
//  Database.m
//  privMD
//
//  Created by Rahul Sharma on 20/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "Database.h"
#import "Entity.h"
#import "PatientAppDelegate.h"
#import "SourceAddress.h"
#import "DestinationAddress.h"

@implementation Database

-(void)makeDataBaseEntry:(NSDictionary *)dictionary
{
	TELogInfo(@"DATABASE dictionary : %@",dictionary);
	NSError *error;
	PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	Entity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    
    [entity setExpMonth:flStrForObj([dictionary objectForKey:@"exp_month"])];
    [entity setExpYear:flStrForObj([dictionary objectForKey:@"exp_year"])];
    [entity setIdCard:flStrForObj([dictionary objectForKey:@"id"])];
    [entity setCardtype:flStrForObj([dictionary objectForKey:@"type"])];
   // [entity setLast4:[NSString stringWithFormat:@"%ld",dictionary objectForKey:@"type"]];
    [entity setLast4:flStrForObj([dictionary objectForKey:@"last4"])];

    
	BOOL isSaved = [context save:&error];
	if (isSaved)
    {
        
    }
    
}
+ (NSArray *)getCardDetails;
{
    
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
	//	[fetchRequest release];
    TELogInfo(@"resutl : %@",result);
    return result;
    
    return nil;
}

+ (BOOL)DeleteCard:(NSString*)Campaign_id
{
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"idCard == %@", Campaign_id];
    [fetch setPredicate:pred];
    //... add sorts if you want them
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        [context deleteObject:product];
    }
    
    if ([context save:&error]) {
        return YES;
    }
    else {
        return NO;
    }
    return NO;
}


/**
 *  On logout it will delete all cards
 */

+ (void)DeleteAllCard
{
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:context];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    //  NSPredicate *pred = [NSPredicate predicateWithFormat:@"idCard == %@", Campaign_id];
    //[fetch setPredicate:pred];
    //... add sorts if you want them
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        [context deleteObject:product];
    }
    [context save:&error];
}

/**
 *  Adding Address to the Database and managing that
 */

-(void)addSourceAddressInDataBase:(NSDictionary *)dictionary
{
    NSDictionary *location = dictionary[@"geometry"][@"location"];
    
    NSError *error;
	PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	SourceAddress *entity = [NSEntityDescription insertNewObjectForEntityForName:@"SourceAddress" inManagedObjectContext:context];
    
    [entity setSrcAddress:flStrForStr(dictionary[@"name"])];
    [entity setSrcAddress2:flStrForStr(dictionary[@"formatted_address"])];
    [entity setSrcLatitude:[NSNumber numberWithDouble:[[location objectForKey:@"lat"] doubleValue]]];
    [entity setSrcLongitude:[NSNumber numberWithDouble:[[location objectForKey:@"lng"] doubleValue]]];
    BOOL isSaved = [context save:&error];
    if (isSaved) {
        
    }

}

+(NSArray *)getSourceAddressFromDataBase
{
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SourceAddress" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
     NSLog(@"%@",result);
 
    
   // NSManagedObject *data=result[0];
   
    //NSString *string=[data valueForKey:@"srcAddress"];
  //  NSLog(@"%@",string);
	return result;
    
    
}

+ (void)deleteAllSourceAddress
{
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"SourceAddress" inManagedObjectContext:context];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        [context deleteObject:product];
    }
    [context save:&error];
}

-(void)addDestinationAddressInDataBase:(NSDictionary *)dictionary
{
    NSDictionary *location = dictionary[@"geometry"][@"location"];
    
    NSError *error;
	PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	DestinationAddress *entity = [NSEntityDescription insertNewObjectForEntityForName:@"DestinationAddress" inManagedObjectContext:context];
    
    [entity setDesAddress:flStrForStr(dictionary[@"name"])];
    [entity setDesAddress2:flStrForStr(dictionary[@"formatted_address"])];
    [entity setDesLatitude:[NSNumber numberWithDouble:[[location objectForKey:@"lat"] doubleValue]]];
    [entity setDesLongitude:[NSNumber numberWithDouble:[[location objectForKey:@"lng"] doubleValue]]];
    
    BOOL isSaved = [context save:&error];
    if (isSaved) {
        
    }
}

+(NSArray *)getDestinationAddressFromDataBase
{
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DestinationAddress" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
	return result;
    
}

+ (void)deleteAllDestinationAddress
{
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"DestinationAddress" inManagedObjectContext:context];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSError *fetchError;
    NSError *error;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *product in fetchedProducts) {
        [context deleteObject:product];
    }
    [context save:&error];
}


@end
