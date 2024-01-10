class BannerCamper {
  String? id;
  String? collectionId;
  String? thumbnail;
  String? categoryId;

  BannerCamper(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.categoryId,
  );

  factory BannerCamper.fromJson(Map<String, dynamic> jsonObject) {
    return BannerCamper(
      jsonObject['id'],
      jsonObject['collectionId'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['categoryId'],
    );
  }
}
