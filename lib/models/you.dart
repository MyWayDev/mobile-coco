/*

class YoutubeResponse {
  // Fields and Objects in YoutubeResponse according to JSON Data.

  String kind;
  String etag;
  String nextPageToken;

  String regionCode;
  pageInfo mPageInfo;
  List<Item> items;

  // Constructor

  YoutubeResponse(
      {this.kind,
      this.etag,
      this.nextPageToken,
      this.regionCode,
      this.mPageInfo,
      this.items});

  // toJson() function discussed below.

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'etag': etag,
        'nextPageToken': nextPageToken,
        'regionCode': regionCode,
        'pageInfo': mPageInfo,
        'items': items,
      };

  // fromJSON FUNCTION EXPLAINED BELOW.

  factory YoutubeResponse.fromJSON(Map<String, dynamic> YoutubeResponseJson) {
    var list = YoutubeResponseJson['items'] as List;
    List<Item> itemsList = list.map((i) => Item.fromJSON(i)).toList();

    return new YoutubeResponse(
        kind: YoutubeResponseJson['kind'],
        etag: YoutubeResponseJson['etag'],
        nextPageToken: YoutubeResponseJson['nextPageToken'],
        regionCode: YoutubeResponseJson['regionCode'],
        mPageInfo: pageInfo.fromJSON(YoutubeResponseJson['pageInfo']),
        items: itemsList);
  }
}
*/
