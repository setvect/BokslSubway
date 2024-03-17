class ErrorMessage {
  final int status;
  final String code;
  final String message;
  final String link;
  final String developerMessage;
  final int total;

  ErrorMessage({
    required this.status,
    required this.code,
    required this.message,
    required this.link,
    required this.developerMessage,
    required this.total,
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      link: json['link'],
      developerMessage: json['developerMessage'],
      total: json['total'],
    );
  }
}

class RealtimeArrival {
  final String subwayId;
  final String updnLine;
  final String trainLineNm;
  final String statnNm;
  final String btrainSttus;
  final String barvlDt;
  final String btrainNo;
  final String bstatnNm;
  final String arvlMsg2;
  final String arvlMsg3;
  final String arvlCd;

  RealtimeArrival({
    required this.subwayId,
    required this.updnLine,
    required this.trainLineNm,
    required this.statnNm,
    required this.btrainSttus,
    required this.barvlDt,
    required this.btrainNo,
    required this.bstatnNm,
    required this.arvlMsg2,
    required this.arvlMsg3,
    required this.arvlCd,
  });

  factory RealtimeArrival.fromJson(Map<String, dynamic> json) {
    return RealtimeArrival(
      subwayId: json['subwayId'],
      updnLine: json['updnLine'],
      trainLineNm: json['trainLineNm'],
      statnNm: json['statnNm'],
      btrainSttus: json['btrainSttus'],
      barvlDt: json['barvlDt'],
      btrainNo: json['btrainNo'],
      bstatnNm: json['bstatnNm'],
      arvlMsg2: json['arvlMsg2'],
      arvlMsg3: json['arvlMsg3'],
      arvlCd: json['arvlCd'],
    );
  }
}

class ResRealtimeArrival {
  final ErrorMessage errorMessage;
  final List<RealtimeArrival> realtimeArrivalList;

  ResRealtimeArrival({
    required this.errorMessage,
    required this.realtimeArrivalList,
  });

  factory ResRealtimeArrival.fromJson(Map<String, dynamic> json) {
    return ResRealtimeArrival(
      errorMessage: ErrorMessage.fromJson(json['errorMessage']),
      realtimeArrivalList: (json['realtimeArrivalList'] as List).map((i) => RealtimeArrival.fromJson(i)).toList(),
    );
  }
}
