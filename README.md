# 복슬지하철
실시간 수도권 지하철 도착시간 안내

## 1. 주요 기능

- 수도권 실시간 지하철 도착안내
  - 지원 노선: 1호선, 2호선, 3호선, 4호선, 5호선, 6호선, 7호선, 8호선, 9호선, 중앙선, 경의선, 공항철도, 경춘선, 수인분당선, 신분당선, 우이신설경전철, 서해선, 경강선
- 역 검색(초성검색)
- 즐겨찾기

## 2. 실행 및 빌드
### 2.1. 초기 셋팅

```shell
$ flutter pub get
```

### 2.2. 실행 방법

```shell
$ flutter run
```

### 2.3. 빌드 방법 

#### 2.3.1. 안드로이드

```shell
$ flutter build apk
```

생성된 apk 경로: build/app/outputs/flutter-apk/app-release.apk

앱 아이콘 이미지를 변경하는 경우`/assets/boksl_subway.png` 파일을 변경한 후 다음 명령어 실행
```shell
$ flutter pub run flutter_launcher_icons:main
```

## 3. 실행 화면


## 4. 관련 정보

### 4.1. 공공 API
- [서울시 지하철 실시간 도착정보](https://data.seoul.go.kr/dataList/OA-12764/F/1/datasetView.do)
- [서울시 지하철역 정보 검색 (역명)](https://data.seoul.go.kr/dataList/OA-121/S/1/datasetView.do)
  
### 4.2. 참고한 사이트
- [dartpad](https://dartpad.dev/)
- [첫 번째 Flutter 앱](https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=ko)
- [Widget catalog](https://docs.flutter.dev/ui/widgets)

### 4.3. 유용한 명령어

- 로그 확인
```shell
$ adb logcat 
```
