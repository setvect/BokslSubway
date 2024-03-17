class Station {
  final String stationCd; // 역코드
  final String stationNm; // 역명
  final String lineNum; // 호선
  final String frCode; // 외부코드

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
