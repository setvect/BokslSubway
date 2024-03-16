class Station {
  final String stationCd;
  final String stationNm;
  final String lineNum;
  final String frCode;

  Station({required this.stationCd, required this.stationNm, required this.lineNum, required this.frCode});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationCd: json['STATION_CD'],
      stationNm: json['STATION_NM'],
      lineNum: json['LINE_NUM'].replaceFirst('0', ''), // '0'을 제거
      frCode: json['FR_CODE'],
    );
  }
}
