#import "../headers/Scrobbler.h"

static NSString *currentSongLocalID = @"";
static double currentTotalMediaTime = 0;
static NSTimer *timer = nil;
static BOOL scrobbled = NO;
static BOOL isPlaying = NO;

@implementation LFMScrobbler

+ (void) poll {
	YTQueueController *controller = [LFMYouTubeInstances queueController];
	YTQueueItem *item = [controller nowPlayingMusicQueueItem];
	YTIPlaylistPanelVideoRenderer *renderer = [item videoRenderer];

	NSString *artist = [[renderer shortBylineText] stringWithFormattingRemoved];
	NSString *track = [[renderer title] stringWithFormattingRemoved];
	double mediaTime = [controller nowPlayingVideoMediaTime];
	NSString *localID = [item localID];

	if (localID != currentSongLocalID) {
		NSLog(@"Now Playing: %@ - %@", artist, track);

		scrobbled = NO;
		currentSongLocalID = localID;
		[LFMClient setNowPlaying:track artist:artist duration:currentTotalMediaTime];
	}

	if (!scrobbled && isPlaying && mediaTime >= (currentTotalMediaTime / 2)) {
		NSLog(@"Scrobbling: %@ - %@", artist, track);

		[LFMClient scrobble:track artist:artist duration:currentTotalMediaTime elapsed:mediaTime];
		scrobbled = YES;
	}
}

@end

%hook MLHAMPlayerItem

- (void) playerStateDidChangeFrom:(NSInteger*)from to:(NSInteger*)to {
	%orig;

	// 3 - Playing
	if ((int)(size_t)to == 3) {
		isPlaying = TRUE;

		timer = [NSTimer
			scheduledTimerWithTimeInterval:1.0f
			target:[NSBlockOperation blockOperationWithBlock:^{ [LFMScrobbler poll]; }]
			selector:@selector(main)
			userInfo:nil
			repeats:YES
		];
	} else {
		if (timer) {
			[timer invalidate];
		}

		isPlaying = FALSE;
	}

	currentTotalMediaTime = [self totalMediaTime];
}

%end