
@interface LSApplicationWorkspace
+ (id)defaultWorkspace;
- (id)allInstalledApplications;
@end

@interface LSBundleProxy
@property (nonatomic, readonly) NSURL *bundleContainerURL;
@property (nonatomic, readonly) NSString *bundleExecutable;
@property (nonatomic, readonly) NSString *bundleIdentifier;
@property (nonatomic, readonly) NSString *bundleType;
@property (nonatomic, readonly) NSURL *bundleURL;
@property (nonatomic, readonly) NSString *bundleVersion;
@property (nonatomic, readonly) NSURL *containerURL;
@property (nonatomic, readonly) NSURL *dataContainerURL;
@property (nonatomic, readonly) NSDictionary *entitlements;
@property (nonatomic, readonly) NSDictionary *groupContainerURLs;
@property (nonatomic, readonly) BOOL isContainerized;
@property (nonatomic, readonly) NSString *localizedShortName;
@property (nonatomic, readonly) NSString *signerIdentity;
@property (nonatomic, readonly) NSString *teamID;
@end


@interface LSApplicationProxy : LSBundleProxy
- (id)localizedName;
@end

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface AppUtils : NSObject

+ (instancetype)sharedInstance;
- (void) searchApp:(NSString *)name;

@end

@implementation AppUtils

static NSArray* apps;

+ (instancetype)sharedInstance
{
    static AppUtils *sharedInstance;
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppUtils alloc] init];
        apps = [[LSApplicationWorkspace defaultWorkspace] allInstalledApplications];
    });
    return sharedInstance;
}

- (void) searchApp:(NSString *)searchTerm
{
    NSPredicate *predicateExecutable = [NSPredicate predicateWithFormat:@"bundleExecutable contains[cd] %@", searchTerm];
    NSPredicate *predicateIdentifier = [NSPredicate predicateWithFormat:@"bundleIdentifier contains[cd] %@", searchTerm];
    NSPredicate *nameIdentifier = [NSPredicate predicateWithFormat:@"localizedName contains[cd] %@", searchTerm];
    NSArray *subPredicates = [NSArray arrayWithObjects:predicateExecutable, predicateIdentifier, nameIdentifier, nil];
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];

    NSArray *filtered = [apps filteredArrayUsingPredicate:predicate];

    int i = 1;

    for (LSApplicationProxy *app in filtered)
    {
        NSString *teamID = app.teamID;
        NSString *identifier = app.bundleIdentifier;
        NSString *bundleContainer = app.bundleContainerURL.path;

        NSString *dataContainer = app.dataContainerURL.path;
        NSString *localizedName = app.localizedName;
        NSDictionary *groupContainerURLs = app.groupContainerURLs;

        if(bundleContainer == nil)
            bundleContainer = app.bundleURL.path;

        if(![teamID isEqualToString:@"0000000000"])
            identifier = [NSString stringWithFormat:@"%@.%@", teamID, identifier];

        NSLog(@"[%i] %@ (%@)", i, localizedName, identifier);

        if(bundleContainer)
            NSLog(@"Bundle: %@", bundleContainer);

        if(dataContainer)
            NSLog(@"Data: %@", dataContainer);

        if(groupContainerURLs != nil && [groupContainerURLs count] > 0) {
            for (id key in groupContainerURLs ) {
                NSURL *groupURL = [groupContainerURLs objectForKey:key];
                NSLog(@"Group: %@ (%@)\n", groupURL.path, key);
            }
        } else {
            NSLog(@"");
        }

        i++;
    }
    
}
@end

int main(int argc, char **argv, char **envp) {

    if(argc < 2) {
        fprintf(stderr, "Syntax: %s searchTerm\n", argv[0]);
        return 1;
    }

    char *filter = NULL;

  if (optind < argc)
    {
        filter = argv[optind++];
    }

    if(filter == NULL) {
        NSLog(@"Error: Search term is missing.")
        exit(0);
    }

    NSString* searchTerm = [NSString stringWithUTF8String:filter];
    [[AppUtils sharedInstance] searchApp:searchTerm];

  exit (0);
    
}