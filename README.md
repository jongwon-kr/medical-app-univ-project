# 헬스케어 모바일 서비스 앱
### 프로젝트 목적
동의보감 서비스를 통해 자신의 몸 상태에 대해 심각한 질병을 가지고 있을거라고 생각하는 현대인들에게 가정에서 쉽고 빠르게 자신의 상태를 측정하고 이를 스마트폰 앱을 통하여 확인할 수 있도록 하여 건강 염려증을 예방하는것을 목표로 한다.

### 프로젝트 기간
2023.09 ~ 2023.12

### 프로젝트 팀원 구성
팀원 모두 BE, FE에 부분을 나눠 개발 진행

### 개발 환경 및 언어
Java, Dart, JSP, Oracle, Flutter, Firebase, OpenAI, Arduino, VsCode, Eclipse, Arduino

### 주요 기능 구현 및 상세역할
- 질병 진단 : 질환 백과에 있는 데이터들을 통해 사용자의 문진결과를 바탕으로 의심 질병을 진단해주는 시스템 일일 문진으로 마일리지 지급
- 질환 백과사전, 유저 채팅 방 운영 : 사용자가 특정 신체부위나 특정 키워드 검색을 통해 질환 정보를 열람할 수 있다. 유저 간 채팅방을 통한 소통 가능
- ChatGPT Q&A, 일일 OX 퀴즈 : ChatGPT를 통해 사용자의 질문에 대한 답변 서비스, ox 퀴즈를 이용한 건강 상식 제공 및 마일리지 제공
- 일일 건강 체크 : 심전도, 근전도, 심박수, 체온 검사를 개발된 아두이노 기기를 통해 검사할 수 있다. 일일 자가 진단 마일리지 지급

#### 나의 역할
- APP 개발 , DB 구축, 데이터 수집 및 정제, Arduino
- 화면 구현 : 메인, 질환 백과사전 메인, 채팅방, 일일 건강 체크, ChatGPT Q&A
- 질환데이터베이스의 구축을 하였고, Java의 URL과 HttpURLConnection등을 활용하여 약 1100가지의 질환 상세 정보를 크롤링하여 데이터 정제후 DB에 저장
- Firebase의 Authentication, FirestroeDB를 활용하여 사용자 회원가입 및 로그인, 마일리지 서비스 기능을 개발
- ChatGPT연동을 통해 Q&A 챗봇 개발, Dart의 Stream과 Builder를 통한 실시간 채팅방 개발
- 메인화면의 OX퀴즈, 건강칼럼 top10개발
- Arduino의 터치LCD를 통한 심전도, 근전도, 심박, 체온센서의 하드웨어 구축 후 일일 검진후 결과 데이터 블루투스 통신 구현

### 데이터베이스
**OracleDB / 테이블명(Column)**
- **질환**(!질환번호, 질환명, 정의, 원인, 증상, 진단, 치료, 경과, 주의사항, 부위)
- **빈도**(질환번호,  빈도수)
- **문진**(순번, 날짜, 이름, 증상)
- **문진정보**(이름,  의심질병)

**Firebase / 컬렉션명(필드)**
- **dailyquest**(checkarduino, checkhealth, date, oxquiz)
- **messages**(createdAt, msgTime, nickname, sender, text)
- **mileages**(email, point)
- **quiz**(answer, comment, id, quiz)
- **userinfo**(nickname, birth, gender, hint, answer)

### 시스템 아키텍처

![image](https://github.com/user-attachments/assets/9259866c-8d03-4427-9297-efb562e04996)

### 구현 기능 및 이미지

#### 메인화면
##### 기능
- OX 퀴즈 : firebase의 quiz컬렉션을 통해 약 20개의 건강퀴즈 제공(하루에 5개 맞추면 최대 마일리지 획득)
- BBC 건강칼럼 top10 : flutter내부에서 크롤링을 통해 건강칼럼 데이터를 가져와서 리스트로 보여주고 클릭시 해당 칼럼 WebView를 띄움
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/7d386a6c-936f-4313-9a6a-d2e004cf0ed6" width="400" height="400">

#### 로그인 / 회원가입
##### 기능
- 로그인 및 회원가입 : firebase의 Authentication을 이용해서 회원가입과 로그인 기능 구현
- 비밀번호 재설정 : 회원가입 이메일을 통해 비밀번호 재설정 메일로 변경가능
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/d4f4585b-e158-4e2f-a5cb-e691e26dad7b" width="1000" height="420">

#### 채팅방
##### 기능
- 실시간 채팅 스트림 : 로그인 시 이용할 수 있으며 사용자의 nickname과 email을 통해 DB에있는 메시지 데이터를 스트림에 담아 보여주고 채팅전송시 실시간으로 업데이트 구현
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/d22fd36f-ba20-4b68-bd36-12dcd70dcff6" width="400" height="420">

#### 문진 / 내정보
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/bf47665e-519a-4097-85e4-f525a40d41b0" width="600" height="420">

#### 질환 백과
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/49c0ea39-6d88-42c7-85de-dacd750a7016" width="1000" height="420">

#### ChatBot
##### 기능
- 챗봇 : OpenAI의 chatgpt API를 활용하여 Q&A 챗봇 구현
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/1cf5ee6e-2d41-4732-acf7-25334bf8af66" width="400" height="420">

#### 자가진단 블루투스 연결
##### 기능
- 블루투스 연동
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/b066fbb4-b371-4a41-b02d-bf16e31fb0ad" width="800" height="420">

#### 자가진단
##### 기능
- 자가 진단 : Arduino에서 검사를 완료하면 블루투스를 통해 데이터를 전송받아 활용가능
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/1b2fd91a-280c-45c1-8fcf-30bcc5e2c86b" width="600" height="420">

#### 내 정보
##### 이미지
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/1f864325-f208-4726-a9e4-bed245746447" width="800" height="420">

### Arduino
#### LCD / 모듈 / 보드
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/d65ca76a-c842-4876-b007-5ccaa2748410" width="800" height="300">

#### 센서
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/fad89ece-f5c5-4402-bd77-49d424c124ee" width="800" height="300">

#### 설계도
<img src="https://github.com/jongwon-kr/medical-app-univ-project/assets/76871947/0730e568-fe06-46a7-b49b-56bee38bcc9a" width="800" height="350">


##### Arduino 및 Data수집 Github
https://github.com/jongwon-kr/univ4-1-capstoneProject-utils
##### 서버 Github
https://github.com/jongwon-kr/medical-app-univ-project-server-









## END
