//
//  UploadFile.m
//  CSA
//
//  Created by 3Embed on 07/09/12.
//
//

#import "UploadFiles.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "UploadProgress.h"

@interface UploadFile() {
    NSUInteger chunkSize;
	NSUInteger offset;
	NSUInteger thisChunkSize;
	NSUInteger length;
	NSData* myBlob;
    NSString *imageName;
   
}
@property(nonatomic,strong)NSMutableArray *imagesToUpload;
@property(nonatomic,strong)NSMutableArray *imagesUploadedUrls;
@property(nonatomic,assign)BOOL isUploadingMultipleImages;
@end

@implementation UploadFile
@synthesize imagesToUpload;
@synthesize imagesUploadedUrls;
@synthesize delegate;
@synthesize isUploadingMultipleImages;



-(void)uploadMultipleImages:(NSArray*)images
{
    isUploadingMultipleImages = YES;
    imagesToUpload = [[NSMutableArray alloc] initWithArray:images];
    [self selectImageForUpload];
}
-(void)uploadImageFile:(UIImage*)image{
    
    [self calcImagelength:image];
}
-(void)selectImageForUpload
{
 
    if (imagesToUpload.count > 0) {
        [self uploadImageFile:imagesToUpload[0]];
    }
    
}
-(void)uploadData:(NSData*)data {
    
    myBlob =  data;
	length = [myBlob length];
	chunkSize = 1024 * 1024;
	offset = 0;
    imageName = [NSString stringWithFormat:@"%@.xml",[self getCurrentTime]];
    
    //start uploading image
    [self uploadImage];
}
-(NSString*)getCurrentTime
{
    NSDate *currentDateTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEMMddyyyyHHmmss"];
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    return dateInStringFormated;
        
}
-(void)calcImagelength:(UIImage*)image
{
	
    myBlob =  UIImageJPEGRepresentation(image,1.0);
	length = [myBlob length];
	chunkSize = 1024 * 1024;
	offset = 0;
    imageName = [NSString stringWithFormat:@"%@%@.jpeg",@"image",[self getCurrentTime]];
   
    //start uploading image
    [self uploadImage];
	
}
-(void)uploadImage
{
    //	do {
	//NSLog(@"uploadImage");
//    UploadProgress *up = [UploadProgress sharedInstance];
//    [up updateProgress:(float)offset/length];
    
    TELogInfo(@"%f",(float)offset/length);
    
    thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
    NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[myBlob bytes] + offset
                                         length:thisChunkSize
                                   freeWhenDone:NO];
    
   
	NSString *binaryString = [chunk base64Encoding];
    
    
    [self sendRequestToUploadImageWithChunk:binaryString];
    
}

-(void)sendRequestToUploadImageWithChunk:(NSString*)binaryString {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    static int valueNumberofChunks = 1;
    NSMutableDictionary *requestForUploadSnap= [[NSMutableDictionary alloc] init];
    [requestForUploadSnap setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken] forKey:KDAUploadSessionToken];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    [requestForUploadSnap setObject:deviceId forKey:KDAUploadDeviceId];
    [requestForUploadSnap setObject:imageName forKey:KDAUploadImageName];
    [requestForUploadSnap setObject:binaryString forKey:KDAUploadImageChunck];
    [requestForUploadSnap setObject:[NSNumber numberWithInt:2] forKey:KDAUploadfrom];
    
    [requestForUploadSnap setObject:[NSNumber numberWithInt:1] forKey:KDAUploadtype];
    NSString *inStr = [NSString stringWithFormat: @"%d",valueNumberofChunks];
  //  NSLog(@"valueNumberofChunks %@ ",inStr);
    [requestForUploadSnap setObject:inStr forKey:KDAUploadOffset];
    [requestForUploadSnap setObject:[Helper getCurrentDateTime] forKey:KDAUploadDateTime];
   // NSLog(@"requestForUploadSnap %@ ",requestForUploadSnap);
    
    [manager POST:BASE_URL_UPLOADIMAGE parameters:requestForUploadSnap success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        TELogInfo(@"JSON: %@", responseObject);
        if ([responseObject[@"errFlag"] integerValue] == 0)
        {
            offset += thisChunkSize;
            if(offset < length) {
                valueNumberofChunks++;
                [self uploadImage];
            }
            else
            {
                if (!imagesUploadedUrls) {
                    imagesUploadedUrls = [[NSMutableArray alloc] init];
                }
                
                // collect the uploaded image urls
                if ([imagesUploadedUrls indexOfObject:responseObject[@"data"][@"picURL"]] == NSNotFound) {
                    [imagesUploadedUrls addObject:responseObject[@"data"][@"picURL"]];
                }
                
                //check if user is uploading multiple images
                if (isUploadingMultipleImages) {
                    
                    [imagesToUpload removeObjectAtIndex:0];
                    if (imagesToUpload.count > 0) {
                        
                        [self selectImageForUpload];
                        myBlob = nil;
                    }
                    else {
                        [self notifyForSuccessfullUpload];
                    }
                }
                else {
                    [self notifyForSuccessfullUpload];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (delegate && [delegate respondsToSelector:@selector(uploadFile:didFailedWithError:)]) {
            [delegate uploadFile:self didFailedWithError:error];
        }
    }];
    
}

-(void)notifyForSuccessfullUpload {
    if (delegate && [delegate respondsToSelector:@selector(uploadFile:didUploadSuccessfullyWithUrl:)]) {
        [delegate uploadFile:self didUploadSuccessfullyWithUrl:imagesUploadedUrls];
    }
}

- (void)timeout:(NSDictionary*)dict {
    
    AFHTTPRequestOperation *operation = [dict objectForKey:@"operation"];
    if (operation) {
        [operation cancel];
    }
    [self perform:[[dict objectForKey:@"selector"] pointerValue] on:[dict objectForKey:@"object"] with:nil];
}

- (void)perform:(SEL)selector on:(id)target with:(id)object {
    if (target && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:object];
    }
}


@end
