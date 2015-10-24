//
//  CONST.h
//  GKMusic
//
//  Created by qianfeng on 14-9-25.
//  Copyright (c) 2014年 gao. All rights reserved.
//

#ifndef GKMusic_CONST_h
#define GKMusic_CONST_h

//乐库推荐订阅
#define RECOMMEND @"http://iosservice.kugou.com/api/v3/recommend/index?plat=2&showtype=1"
//排行总界面各种排行榜列表
#define RANKTOTAL @"http://iosservice.kugou.com/api/v3/rank/list"
//排行具体界面
#define RANKDETAIL(rankid,ranktype,page,pagesize) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/rank/song?rankid=%@&ranktype=%@&page=%d&pagesize=%d",rankid,ranktype,page,pagesize]
//歌单总界面横幅图片
#define BANNER @"http://ioscdn.kugou.com/api/v3/banner/index?plat=2&count=5"
//歌单总界面分类列表
#define CATEGORY @"http://ioscdn.kugou.com/api/v3/category/list"
//歌单二级界面分类列表
#define SPECIALLIST(categoryid,page,pagesize) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/category/special?categoryid=%@&page=%d&pagesize=%d",categoryid,page,pagesize]

//歌曲信息
#define MUSICURL(hash) [NSString stringWithFormat:@"http://cloud.kugou.com/app/checkIllegal.php?hash=%@",hash]
#define MUSICINFO(hash) [NSString stringWithFormat:@"http://m.kugou.com/app/i/getSongInfo.php?hash=%@&cmd=playInfo",hash]

//电台全部
#define FMALL @"http://lib3.service.kugou.com/index.php?cmd=12&ver=4070&pid=ios"
//电台歌单
#define FMMUSIC(offset0,fmtype0,offset,fmid0) [NSString stringWithFormat:@"http://lib3.service.kugou.com/index.php?size=20&pid=ios&offset0=%@&ver=4070&fmtype0=%@&offset=%@&fmcount=1&fmid0=%@",offset0,fmtype0,offset,fmid0]

//歌手列表(语言)
#define SINGER(type) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/singer/recommend?type=%d",type]
//歌手列表(语言,性别)
#define SINGERCAT(type,sextype) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/singer/list?type=%d&sextype=%d&showtype=2",type,sextype]
//歌手音乐列表(单曲)
#define SINGERSONG(singerid,page,pagesize) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/singer/song?singerid=%@&page=%d&pagesize=%d",singerid,page,pagesize]
//歌手音乐列表(专辑)
#define SINGERALBUM(singerid,page,pagesize) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/singer/album?singerid=%@&page=%d&pagesize=%d",singerid,page,pagesize]
//歌手音乐列表(MV)
#define SINGERMV(singerid,singername,page,pagesize) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/singer/mv?singerid=%@&singername=%@&page=%d&pagesize=%d",singerid,singername,page,pagesize]
//歌手头像
#define SINGERINFO(singerid) [NSString stringWithFormat:@"http://iosservice.kugou.com/api/v3/singer/info?singerid=%@",singerid]
//专辑信息
#define ALBUMINFO(albumid) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/album/info?albumid=%@",albumid]
//专辑歌曲
#define ALBUMSONG(albumid) [NSString stringWithFormat:@"http://ioscdn.kugou.com/api/v3/album/song?albumid=%@&page=1&pagesize=-1&plat=2",albumid]

//本地歌曲地址
#define PATH [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Documents"]

#define FULLPATH(filename) [NSString stringWithFormat:@"%@/%@/%@.mp3",NSHomeDirectory(),@"Documents",filename]

#endif
