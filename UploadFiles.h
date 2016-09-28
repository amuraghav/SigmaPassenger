//
//  UploadFile.h
//  CSA
//
//  Created by 3Embed on 07/09/12.
//
//

#import <Foundation/Foundation.h>
@protocol UploadFileDelegate;
@interface UploadFile : NSObject
{
}
@property(nonatomic,assign)id <UploadFileDelegate> delegate;
-(void)calcImagelength:(UIImage*)image;

-(void)uploadImageFile:(UIImage*)image;
-(void)uploadMultipleImages:(NSArray*)images;
-(void)uploadData:(NSData*)data;

@end

@protocol UploadFileDelegate <NSObject>
-(void)uploadFile:(UploadFile*)uploadfile didUploadSuccessfullyWithUrl:(NSArray*)imageUrls;
-(void)uploadFile:(UploadFile*)uploadfile didFailedWithError:(NSError*)error;
@end